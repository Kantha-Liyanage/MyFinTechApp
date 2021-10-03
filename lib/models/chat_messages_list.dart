import 'package:flutter/foundation.dart';
import 'package:my_fintech_app/models/chat_message.dart';

class ChatMessagesList extends ChangeNotifier {
  final List<ChatMessage> _items = <ChatMessage>[];

  List<ChatMessage> get items => _items;

  void add(ChatMessage item) {
    _items.add(item);
    notifyListeners();
  }

  void addOfflineMessage() {
    removeOfflineMessage();
    ChatMessage msg = ChatMessage();
    msg.message = 'You are offline.';
    msg.messageType = ChatMessageType.deviceMessage;
    add(msg);
  }

  void removeOfflineMessage() {
    _items.removeWhere(
        (msg) => (msg.messageType == ChatMessageType.deviceMessage));
    notifyListeners();
  }
}
