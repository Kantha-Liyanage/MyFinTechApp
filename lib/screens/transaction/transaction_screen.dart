import 'package:my_fintech_app/models/chat_message.dart';
import 'package:my_fintech_app/widgets/chat_box.dart';
import 'package:my_fintech_app/widgets/chat_bubble.dart';
import 'package:flutter/material.dart';
import 'package:my_fintech_app/widgets/pie_chart_chat_bubble.dart';

class TransactionScreen extends StatefulWidget {
  const TransactionScreen({Key? key}) : super(key: key);

  @override
  _TransactionScreenState createState() => _TransactionScreenState();
}

class _TransactionScreenState extends State<TransactionScreen> {
  
  @override
  Widget build(BuildContext context) {
    Map<String, double> dataMap = {
      "Grocery": 5,
      "Clothing": 3,
      "Utility Bills": 2,
      "Medicine": 2,
      "Education": 2,
      "Charity": 2,
      "Parents": 2,
      "Hobby": 2,
    };

    final List<Widget> chatWidgets = <Widget>[
      ChatBubble(ChatMessage('This is a test message. This is a test message. This is a test message.', ChatMessageType.USER_MESSAGE, '2021-09-14', '13:00:00', true)),
      ChatBubble(ChatMessage('This is a test message', ChatMessageType.SERVER_MESSAGE, '2021-09-14', '13:00:00', true)),
      ChatBubble(ChatMessage('@Cash#Grocery+1300', ChatMessageType.USER_MESSAGE, '2021-09-14', '13:00:00', false)),
      PieChartChatBubble('', dataMap),
      PieChartChatBubble('', dataMap),
      PieChartChatBubble('', dataMap),
      ChatBubble(ChatMessage('This is a test message', ChatMessageType.SERVER_MESSAGE, '2021-09-14', '13:00:00', true)),
      ChatBubble(ChatMessage('This is a test message', ChatMessageType.SERVER_MESSAGE, '2021-09-14', '13:00:00', true)),
      ChatBubble(ChatMessage('2021-09-21', ChatMessageType.DEVICE_MESSAGE, '2021-09-14', '13:00:00', true)),
      ChatBubble(ChatMessage('This is a test message', ChatMessageType.USER_MESSAGE, '2021-09-14', '13:00:00', true))
    ];


    return Stack(
      children: [
        //Chat ListView
        Expanded(
          child: Padding(
            padding: const EdgeInsets.fromLTRB(0, 0, 0, 85),
            child: ListView.builder(
              padding: const EdgeInsets.all(8),
              itemCount: chatWidgets.length,
              itemBuilder: (BuildContext context, int index) {
                return chatWidgets[index];
              },
            ),  
          ),
        ),

        //Input ChatBox
        Expanded(
          child: Align(
            alignment: FractionalOffset.bottomCenter,
            child: ChatBox(),
          ),
        ),
      ],
    );
  }
}
