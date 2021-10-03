import 'package:camera/camera.dart';
import 'package:flutter/material.dart';
import 'package:my_fintech_app/screens/transaction/full_screen_camera.dart';
import 'package:provider/provider.dart';
import 'package:my_fintech_app/models/accounts_list.dart';
import 'package:my_fintech_app/models/chat_message.dart';
import 'package:my_fintech_app/models/chat_messages_list.dart';
import 'package:my_fintech_app/models/account.dart';
import 'package:my_fintech_app/models/suggestion.dart';
import 'package:my_fintech_app/models/suggestions_list.dart';
import 'package:my_fintech_app/models/tag.dart';
import 'package:my_fintech_app/models/tags_list.dart';
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
    TagsList tags = Provider.of<TagsList>(context, listen: true);

    return Column(mainAxisAlignment: MainAxisAlignment.end, children: [
      Visibility(visible: suggestionBarVisible, child: suggestionBar()),
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
                          getSuggestions(accounts, tags, value);
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
                        Navigator.push(
                          context,
                          MaterialPageRoute(builder: (context) => FullScreenCamera(cameras.first)),
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
                      sendChat(chatMessages, accounts, tags);
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

  suggestionBar() {
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
              child: seggestionButton(suggestions.items[0]),
            ),
            Expanded(
              flex: 1,
              child: seggestionButton(suggestions.items[1]),
            ),
            Expanded(
              flex: 1,
              child: seggestionButton(suggestions.items[2]),
            ),
          ],
        ));
  }

  seggestionButton(Suggestion seggestion) {
    return TextButton(
        onPressed: () {
          insertSuggestion(seggestion.actualValue);
        },
        child: Text(
          seggestion.displayValue,
          style: const TextStyle(color: Colors.black87),
        ));
  }

  sendChat(
      ChatMessagesList chatMessages, AccountsList accounts, TagsList tags) {
    if (_controller.text.trim() == '') {
      return;
    }

    ChatMessage msg = ChatMessage();

    if (Transaction.isAnAttemptedTransaction(_controller.text)) {
      //validate transaction
      try {
        Transaction transaction = Transaction.createTransaction(
            _controller.text.trim(), accounts.items, tags.items);
        msg = _buildUserChatMessage(_controller.text, transaction);
      } catch (e) {
        _showMyDialog(e.toString());
        return;
      }
    } else {
      msg = _buildUserChatMessage(_controller.text);
    }

    chatMessages.add(msg);
    suggestions.clearAll();
    suggestionBarVisible = false;
    _controller.clear();
    widget.scrollChatToBottom();
  }

  ChatMessage _buildUserChatMessage(String text, [Transaction? transaction]) {
    ChatMessage msg = ChatMessage();
    if (transaction != null) {
      msg.message = '💵 ' + transaction.account;
      msg.message += '\n🏷 ' + transaction.tag;
      msg.message += '\n💰 ' + transaction.amount.toString();
      msg.message += '\n🗓 ' + transaction.date;
    } else {
      msg.message = text;
    }
    msg.messageType = ChatMessageType.userMessage;
    msg.createdDate = 'Today';
    msg.createdTime = 'Now';
    msg.savedOnline = false;
    msg.deleted = false;
    return msg;
  }

  ChatMessage _buildDeviceChatMessage(String text) {
    ChatMessage msg = ChatMessage();
    msg.message = text;
    msg.messageType = ChatMessageType.deviceMessage;
    msg.createdDate = 'Today';
    msg.createdTime = 'Now';
    msg.savedOnline = false;
    msg.deleted = false;
    return msg;
  }

  ChatMessage _buildServerChatMessage(String text) {
    ChatMessage msg = ChatMessage();
    msg.message = text;
    msg.messageType = ChatMessageType.serverMessage;
    msg.createdDate = 'Today';
    msg.createdTime = 'Now';
    msg.savedOnline = false;
    msg.deleted = false;
    return msg;
  }

  insertSuggestion(String text) {
    _controller.text = text;
    _controller.selection = TextSelection.fromPosition(
        TextPosition(offset: _controller.text.length));
  }

  bool getSuggestions(AccountsList accounts, TagsList tags, String value) {
    if (value.isEmpty) {
      return false;
    }

    //Tags
    if (value.contains('@') && value.contains('#')) {
      String tagSearch = value.substring(value.indexOf('#') + 1);
      suggestions.clearAll();
      Iterable<Tag> result = tags.items.where(
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

  Future<void> _showMyDialog(String message) async {
    return showDialog<void>(
      context: context,
      barrierDismissible: false, // user must tap button!
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('FinChat'),
          content: SingleChildScrollView(
            child: ListBody(
              children: <Widget>[
                Text(
                  message + '\nPlease correct.',
                  style: Theme.of(context).textTheme.caption,
                ),
              ],
            ),
          ),
          actions: <Widget>[
            TextButton(
              child: const Text('OK'),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );
  }
}
