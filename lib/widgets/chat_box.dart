import 'package:flutter/material.dart';
import 'package:my_fintech_app/models/chat_message.dart';
import 'package:my_fintech_app/models/chat_messages_list.dart';
import 'package:provider/provider.dart';

class ChatBox extends StatelessWidget {
  final VoidCallback scrollChatToBottom;

  ChatBox(this.scrollChatToBottom, {Key? key}) : super(key: key);

  final TextEditingController _controller = TextEditingController();

  @override
  Widget build(BuildContext context) {
    ChatMessagesList chatMessages =
        Provider.of<ChatMessagesList>(context, listen: true);

    return Row(
      children: [
        Expanded(
            flex: 4,
            child: Padding(
              padding: const EdgeInsets.fromLTRB(12, 0, 0, 12),
              child: TextField(
                style: const TextStyle(fontSize: 18.0),
                onChanged: (value) {
                  //Match
                },
                controller: _controller,
                minLines: 1,
                maxLines: 3,
                decoration: InputDecoration(
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
    );
  }

  sendChat(ChatMessagesList chatMessages) {
    if (_controller.text.trim() == '') {
      return;
    }

    ChatMessage msg = ChatMessage();
    msg.message = _controller.text;
    msg.messageType = ChatMessageType.user_message;
    msg.createdDate = 'Today';
    msg.createdTime = 'Now';
    msg.savedOnline = false;
    msg.deleted = false;
    chatMessages.add(msg);
    _controller.clear();
    scrollChatToBottom();
  }
}
