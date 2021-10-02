import 'package:flutter/material.dart';
import 'package:my_fintech_app/models/account.dart';
import 'package:my_fintech_app/models/suggestion.dart';
import 'package:my_fintech_app/models/suggestions_list.dart';
import 'package:my_fintech_app/models/tag.dart';
import 'package:my_fintech_app/models/tags_list.dart';
import 'package:provider/provider.dart';
import '/models/accounts_list.dart';
import '/models/chat_message.dart';
import '/models/chat_messages_list.dart';

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
                      onPressed: () {},
                    ),
                  ),
                ),
              )),
          Expanded(
              child: Padding(
                  padding: const EdgeInsets.fromLTRB(0, 0, 0, 12),
                  child: ElevatedButton(
                    onPressed: () {
                      sendChat(chatMessages);
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

  sendChat(ChatMessagesList chatMessages) {
    if (_controller.text.trim() == '') {
      return;
    }

    //validate transaction

    ChatMessage msg = ChatMessage();
    msg.message = _controller.text;
    msg.message = msg.message.replaceFirst('@', '🏦 ');
    msg.message = msg.message.replaceFirst('#', '\n🗂 ');
    msg.message = msg.message.replaceFirst('+', '\n💰 ');
    msg.message = msg.message.replaceFirst('&', '\n📆 ');
    msg.messageType = ChatMessageType.userMessage;
    msg.createdDate = 'Today';
    msg.createdTime = 'Now';
    msg.savedOnline = false;
    msg.deleted = false;
    chatMessages.add(msg);
    _controller.clear();
    widget.scrollChatToBottom();
  }

  insertSuggestion(String text) {
    _controller.text = text;
    _controller.selection = TextSelection.fromPosition(
        TextPosition(offset: _controller.text.length));
  }

  bool getSuggestions(AccountsList accounts, TagsList tags, String value) {
    if (value.length < 1) {
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
}
