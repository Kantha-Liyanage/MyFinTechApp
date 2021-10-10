import 'package:camera/camera.dart';
import 'package:flutter/material.dart';
import 'package:my_fintech_app/models/report_repo.dart';
import 'package:my_fintech_app/screens/transaction/full_screen_camera.dart';
import 'package:my_fintech_app/services/chart_service.dart';
import 'package:my_fintech_app/services/connectivity_service.dart';
import 'package:my_fintech_app/services/report_service.dart';
import 'package:my_fintech_app/widgets/popup_error.dart';
import 'package:provider/provider.dart';
import 'package:my_fintech_app/models/accounts_list.dart';
import 'package:my_fintech_app/models/chat_message.dart';
import 'package:my_fintech_app/models/chat_messages_list.dart';
import 'package:my_fintech_app/models/account.dart';
import 'package:my_fintech_app/models/suggestion.dart';
import 'package:my_fintech_app/models/suggestions_list.dart';
import 'package:my_fintech_app/models/budget_category.dart';
import 'package:my_fintech_app/models/budget_categories_list.dart';
import 'package:my_fintech_app/models/transaction.dart';

class ChatBox extends StatefulWidget {
  final VoidCallback scrollChatToBottom;

  const ChatBox(this.scrollChatToBottom, {Key? key}) : super(key: key);

  @override
  State<ChatBox> createState() => _ChatBoxState();
}

class _ChatBoxState extends State<ChatBox> {
  final TextEditingController _controller = TextEditingController();

  bool suggestionBarVisible = false;
  SuggestionsList suggestions = SuggestionsList();

  @override
  Widget build(BuildContext context) {
    ChatMessagesList chatMessages =
        Provider.of<ChatMessagesList>(context, listen: true);
    AccountsList accounts = Provider.of<AccountsList>(context, listen: true);
    BudgetCategoriesList tags =
        Provider.of<BudgetCategoriesList>(context, listen: true);

    return Column(mainAxisAlignment: MainAxisAlignment.end, children: [
      Visibility(visible: suggestionBarVisible, child: _suggestionBar()),
      Row(
        children: [
          Expanded(
              flex: 4,
              child: Padding(
                padding: const EdgeInsets.fromLTRB(12, 0, 0, 12),
                child: TextField(
                  style: Theme.of(context).textTheme.caption,
                  onChanged: (value) {
                    setState(() {
                      suggestionBarVisible =
                          _getSuggestions(accounts, tags, value);
                    });
                  },
                  controller: _controller,
                  minLines: 1,
                  maxLines: 3,
                  decoration: InputDecoration(
                    isDense: true,
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(30),
                      borderSide: BorderSide(color: Colors.grey.shade900),
                    ),
                    hintText: 'Type here...',
                    filled: true,
                    fillColor: Colors.white,
                    prefixIcon: Icon(
                      Icons.keyboard,
                      color: Colors.grey.shade600,
                      size: 20,
                    ),
                    suffixIcon: IconButton(
                      icon: const Icon(Icons.photo_camera_sharp),
                      onPressed: () async {
                        final cameras = await availableCameras();
                        await Future.delayed(const Duration(milliseconds: 200));
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => FullScreenCamera(
                                  cameras.first, widget.scrollChatToBottom)),
                        );
                      },
                    ),
                  ),
                ),
              )),
          Expanded(
              child: Padding(
                  padding: const EdgeInsets.fromLTRB(0, 0, 0, 12),
                  child: ElevatedButton(
                    onPressed: () {
                      _sendChat(context, chatMessages, accounts, tags);
                    },
                    child: const Icon(Icons.send_sharp),
                    style: ElevatedButton.styleFrom(
                      shape: const CircleBorder(),
                      padding: const EdgeInsets.all(12),
                    ),
                  )))
        ],
      )
    ]);
  }

  _suggestionBar() {
    return Container(
        margin: const EdgeInsets.fromLTRB(0, 0, 0, 1),
        decoration: BoxDecoration(
          color: Colors.grey.shade200,
          border: Border.all(
            color: Colors.grey.shade500,
          ),
          //borderRadius: BorderRadius.circular(30.0),
        ),
        //color: Colors.grey.shade300,
        child: Row(
          children: [
            Expanded(
              flex: 1,
              child: _seggestionButton(suggestions.items[0]),
            ),
            Expanded(
              flex: 1,
              child: _seggestionButton(suggestions.items[1]),
            ),
            Expanded(
              flex: 1,
              child: _seggestionButton(suggestions.items[2]),
            ),
          ],
        ));
  }

  _seggestionButton(Suggestion seggestion) {
    return TextButton(
        onPressed: () {
          _insertSuggestion(seggestion.actualValue);
        },
        child: Text(
          seggestion.displayValue,
          style: const TextStyle(color: Colors.black87),
        ));
  }

  _sendChat(BuildContext context, ChatMessagesList chatMessages,
      AccountsList accounts, BudgetCategoriesList tags) async {
    if (_controller.text.trim() == '') {
      return;
    }

    ChatMessage msg;

    if (Transaction.isAnAttemptedTransaction(_controller.text)) {
      //validate transaction
      try {
        Transaction transaction = Transaction.createTransaction(
            _controller.text.trim(), accounts.items, tags.items);
        msg = _buildUserChatMessage(_controller.text, transaction);

        msg.savedOnline = false;
        if (ConnectivityService.isConnected()) {
          ChatService().createTransaction(msg, transaction);
        }

        chatMessages.add(msg);
      } catch (e) {
        PopupError(e.toString()).showErrorDialog(context);
        return;
      }
    } else {
      msg = _buildUserChatMessage(_controller.text);

      msg.savedOnline = false;
      if (ConnectivityService.isConnected()) {
        ChatService().createMessage(msg);
      }

      chatMessages.add(msg);
    }

    suggestions.clearAll();
    suggestionBarVisible = false;
    _controller.clear();
    widget.scrollChatToBottom();

    //Check for report requests
    if (_isReportRequest(msg.message)) {
      _showReport(msg.message, chatMessages);
    }
  }

  ChatMessage _buildUserChatMessage(String text, [Transaction? transaction]) {
    String message = '';

    if (transaction != null) {
      message = '💵 ' + transaction.account;
      message += '\n🏷 ' + transaction.tag;
      message += '\n💰 ' + transaction.amount.toString();
      message += '\n🗓 ' + transaction.date;
    } else {
      message = text;
    }

    ChatMessage msg = ChatMessage.user(
        message, ChatMessageType.userMessage, 'Today', 'Now', false);
    return msg;
  }

  _insertSuggestion(String text) {
    _controller.text = text;
    _controller.selection = TextSelection.fromPosition(
        TextPosition(offset: _controller.text.length));
  }

  bool _getSuggestions(
      AccountsList accounts, BudgetCategoriesList tags, String value) {
    if (value.isEmpty) {
      return false;
    }

    //Tags
    if (value.contains('@') && value.contains('#')) {
      String tagSearch = value.substring(value.indexOf('#') + 1);
      suggestions.clearAll();
      Iterable<BudgetCategory> result = tags.items.where(
          (acc) => acc.name.toLowerCase().startsWith(tagSearch.toLowerCase()));
      int i = 0;
      for (; i < result.length; i++) {
        suggestions.items[i].displayValue = result.elementAt(i).name;
        suggestions.items[i].actualValue =
            value.substring(0, value.indexOf('#')) +
                '#' +
                result.elementAt(i).name;
        if (i == 2) {
          break;
        }
      }
      if (i > 0) {
        return true;
      }
    }

    //Accounts
    if (value.substring(0, 1) == '@') {
      suggestions.clearAll();
      Iterable<Account> result = accounts.items.where((acc) =>
          acc.name.toLowerCase().startsWith(value.toLowerCase().substring(1)));
      int i = 0;
      for (; i < result.length; i++) {
        suggestions.items[i].displayValue = result.elementAt(i).name;
        suggestions.items[i].actualValue = '@' + result.elementAt(i).name;
        if (i == 2) {
          break;
        }
      }
      if (i > 0) {
        return true;
      }
    }

    return false;
  }

  bool _isReportRequest(String shortCut) {
    return ReportRepo.repo
            .indexWhere((element) => element.shortCut == shortCut.toUpperCase()) >
        0;
  }

  Report _getReport(String text) {
    return ReportRepo.repo
        .firstWhere((element) => element.shortCut == text.toUpperCase());
  }

  void _showReport(String shortCut, ChatMessagesList chatMessages) {
    Report report = _getReport(shortCut);
    //Check online
    if (ConnectivityService.isConnected()) {
      chatMessages.add(ChatMessage.device(
          report.title + ' 👇', ChatMessageType.serverMessage));

      if (report.reportType == ReportType.pie) {
        ReportService().fetchPieChartData(report.shortCut.toUpperCase()).then((data) => {
              chatMessages.add(
                  ChatMessage.pieChart(data, ChatMessageType.serverMessage)),
              widget.scrollChatToBottom()
            });
      } else if (report.reportType == ReportType.bar) {
        ReportService().fetchBarChartData(report.shortCut.toUpperCase()).then((data) => {
              chatMessages.add(
                  ChatMessage.barChart(data, ChatMessageType.serverMessage)),
              widget.scrollChatToBottom()
            });
      }
    } else {
      chatMessages.add(ChatMessage.device(
          'Requested report will be available when you are online 🌏',
          ChatMessageType.serverMessage));
    }
  }
}
