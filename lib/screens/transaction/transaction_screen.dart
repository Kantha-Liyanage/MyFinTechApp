import 'package:my_fintech_app/models/chat_messages_list.dart';
import 'package:my_fintech_app/screens/transaction/chat_box.dart';
import 'package:my_fintech_app/screens/transaction/chat_bubble.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class TransactionScreen extends StatelessWidget {
  TransactionScreen({Key? key}) : super(key: key);

  final ScrollController _scrollController = ScrollController();

  @override
  Widget build(BuildContext context) {
    ChatMessagesList chats =
        Provider.of<ChatMessagesList>(context, listen: true);

    return Stack(
      children: [
        //Chat ListView
        Expanded(
          child: Padding(
            padding: const EdgeInsets.fromLTRB(0, 0, 0, 75),
            child: ListView.builder(
              padding: const EdgeInsets.all(8),
              itemCount: chats.items.length,
              controller: _scrollController,
              itemBuilder: (BuildContext context, int index) {
                return ChangeNotifierProvider.value(
                  value: chats.items[index],
                  child: const ChatBubble(),
                );
              },
            ),
          ),
        ),

        //Input ChatBox
        Expanded(
          child: Align(
            alignment: FractionalOffset.bottomCenter,
            child: ChatBox(scrollChatToBottom),
          ),
        ),
      ],
    );
  }

  scrollChatToBottom() {
    _scrollController.animateTo(
      _scrollController.position.maxScrollExtent + 70, 
      duration: const Duration(milliseconds: 2000), 
      curve: Curves.easeOut
    );
  }
}
