import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:my_fintech_app/models/chat_message.dart';

class ChatBubble extends StatelessWidget {

  const ChatBubble({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    ChatMessage chatMessage = Provider.of<ChatMessage>(context, listen: true);

    //for Device Messages
    Color messageColor;
    CrossAxisAlignment messageAlignment;
    BorderRadius messageRadius;
    bool isDeviceMessageMode = false;

    switch (chatMessage.messageType) {
      case ChatMessageType.userMessage:
        messageColor = Colors.greenAccent.shade100;
        messageAlignment = CrossAxisAlignment.end;
        messageRadius = const BorderRadius.only(
          topLeft: Radius.circular(15.0),
          bottomLeft: Radius.circular(15.0),
          bottomRight: Radius.circular(15.0),
        );
        break;
      case ChatMessageType.serverMessage:
        messageColor = Colors.white;
        messageAlignment = CrossAxisAlignment.start;
        messageRadius = const BorderRadius.only(
          topRight: Radius.circular(15.0),
          bottomLeft: Radius.circular(15.0),
          bottomRight: Radius.circular(15.0),
        );
        break;
      default:
        messageColor = Colors.grey;
        messageAlignment = CrossAxisAlignment.center;
        messageRadius = const BorderRadius.only(
          topRight: Radius.circular(15.0),
          topLeft: Radius.circular(15.0),
          bottomLeft: Radius.circular(15.0),
          bottomRight: Radius.circular(15.0),
        );
        isDeviceMessageMode = true;
    }

    //Status icon
    final iconStatus = chatMessage.savedOnline
        ? Icons.cloud_done_rounded
        : Icons.cloud_off_rounded;

    return Column(
      crossAxisAlignment: messageAlignment,
      children: <Widget>[
        Container(
          margin: const EdgeInsets.fromLTRB(4, 4, 4, 16),
          padding: const EdgeInsets.all(10.0),
          decoration: BoxDecoration(
            boxShadow: [
              BoxShadow(
                  blurRadius: .5,
                  spreadRadius: 1.5,
                  color: Colors.black.withOpacity(.20))
            ],
            color: messageColor,
            borderRadius: messageRadius,
          ),
          child: Stack(
            children: <Widget>[
              Visibility(
                visible: isDeviceMessageMode,
                child: Text(chatMessage.message,
                  style: Theme.of(context).textTheme.bodyText1,
                ),
              ),
              Visibility(
                visible: !isDeviceMessageMode,
                child: Padding(
                  padding: const EdgeInsets.fromLTRB(0, 0, 0, 16),
                  child: Text(chatMessage.message,
                    style: Theme.of(context).textTheme.bodyText1,
                  ),
                ),
              ),
              Visibility(
                  visible: !isDeviceMessageMode,
                  child: Positioned(
                    bottom: 0.0,
                    right: 0.0,
                    child: Row(
                      children: <Widget>[
                        Text(chatMessage.createdTime,
                          style: Theme.of(context).textTheme.bodyText2),
                        const SizedBox(width: 3.0),
                        Icon(
                          iconStatus,
                          size: 12.0,
                          color: Colors.black38,
                        )
                      ],
                    ),
                  ),
                ),
            ],
          ),
        )
      ],
    );
  }
}
