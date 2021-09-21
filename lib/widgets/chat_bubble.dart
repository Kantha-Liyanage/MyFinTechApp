import 'package:my_fintech_app/models/chat_message.dart';
import 'package:flutter/material.dart';

class ChatBubble extends StatefulWidget {
  ChatMessage chatMessage;

  ChatBubble(this.chatMessage, {Key? key}) : super(key: key);

  @override
  State<ChatBubble> createState() => _ChatBubbleState();
}

class _ChatBubbleState extends State<ChatBubble> {
  @override
  Widget build(BuildContext context) {
    //for Device Messages
    Color messageColor;
    CrossAxisAlignment messageAlignment;
    BorderRadius messageRadius;
    bool isDeviceMessageMode = false;

    switch (widget.chatMessage.messageType) {
      case ChatMessageType.USER_MESSAGE:
        messageColor = Colors.greenAccent.shade100;
        messageAlignment = CrossAxisAlignment.end;
        messageRadius = const BorderRadius.only(
          topLeft: Radius.circular(15.0),
          bottomLeft: Radius.circular(15.0),
          bottomRight: Radius.circular(15.0),
        );
        break;
      case ChatMessageType.SERVER_MESSAGE:
        messageColor = Colors.white;
        messageAlignment = CrossAxisAlignment.start;
        messageRadius = const BorderRadius.only(
          topRight: Radius.circular(15.0),
          bottomLeft: Radius.circular(15.0),
          bottomRight: Radius.circular(15.0),
        );
        break;
      default:
        //ChatMessageTypes.DEVICE_MESSAGE
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
    final iconStatus = widget.chatMessage.savedOnline
        ? Icons.cloud_done_rounded
        : Icons.cloud_off_rounded;

    return Column(
      crossAxisAlignment: messageAlignment,
      children: <Widget>[
        Container(
          margin: const EdgeInsets.all(8.0),
          padding: const EdgeInsets.all(8.0),
          decoration: BoxDecoration(
            boxShadow: [
              BoxShadow(
                  blurRadius: .5,
                  spreadRadius: 1.0,
                  color: Colors.black.withOpacity(.12))
            ],
            color: messageColor,
            borderRadius: messageRadius,
          ),
          child: Stack(
            children: <Widget>[
              Visibility(
                visible: isDeviceMessageMode,
                child: Text(widget.chatMessage.message),
              ),
              Visibility(
                visible: !isDeviceMessageMode,
                child: Padding(
                  padding: const EdgeInsets.only(right: 78.0),
                  child: Text(widget.chatMessage.message),
                ),
              ),
              Visibility(
                  visible: !isDeviceMessageMode,
                  child: Positioned(
                    bottom: 0.0,
                    right: 0.0,
                    child: Row(
                      children: <Widget>[
                        Text(widget.chatMessage.createdTime,
                            style: const TextStyle(
                              color: Colors.black38,
                              fontSize: 10.0,
                            )),
                        const SizedBox(width: 3.0),
                        Icon(
                          iconStatus,
                          size: 12.0,
                          color: Colors.black38,
                        )
                      ],
                    ),
                  )),
            ],
          ),
        )
      ],
    );
  }
}
