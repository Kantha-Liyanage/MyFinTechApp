import 'package:my_fintech_app/models/chat_message.dart';
import 'package:my_fintech_app/widgets/chat_box.dart';
import 'package:my_fintech_app/widgets/chat_bubble.dart';
import 'package:flutter/material.dart';

class TransactionScreen extends StatefulWidget {
  const TransactionScreen({Key? key}) : super(key: key);

  @override
  _TransactionScreenState createState() => _TransactionScreenState();
}

class _TransactionScreenState extends State<TransactionScreen> {
  final List<ChatMessage> chats = <ChatMessage>[
    ChatMessage('This is a test message. This is a test message. This is a test message.', ChatMessageType.USER_MESSAGE, '2021-09-14', '13:00:00', true),
    ChatMessage('This is a test message', ChatMessageType.SERVER_MESSAGE, '2021-09-14', '13:00:00', true),
    ChatMessage('2021-09-21', ChatMessageType.DEVICE_MESSAGE, '2021-09-14', '13:00:00', true),
    ChatMessage('This is a test message', ChatMessageType.USER_MESSAGE, '2021-09-14', '13:00:00', false)
  ];

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        //Chat ListView
        Expanded(
          child: Padding(
            padding: const EdgeInsets.fromLTRB(0, 0, 0, 85),
            child: ListView.builder(
              padding: const EdgeInsets.all(8),
              itemCount: chats.length,
              itemBuilder: (BuildContext context, int index) {
                return ChatBubble(chats[index]);
              }
            ),
          ),
        ),

        //Input ChatBox
        Expanded(
          child: Align(
            alignment: FractionalOffset.bottomCenter,
            child: ChatBox(),
          ),
        )
      ],
    );
  }
}
