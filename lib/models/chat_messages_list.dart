import 'package:flutter/foundation.dart';
import 'package:my_fintech_app/models/chat_message.dart';
import 'package:my_fintech_app/services/chart_service.dart';

class ChatMessagesList extends ChangeNotifier {
  List<ChatMessage> _items = <ChatMessage>[];

  List<ChatMessage> get items => _items;

  ChatMessagesList() {
    _getRemoteData();
  }

  void add(ChatMessage item) {
    _items.add(item);
    notifyListeners();
  }

  void addOlderMessages(List<ChatMessage> olderList) {
    _items.insertAll(0, olderList);
    notifyListeners();
  }

  void addOfflineMessage() {
    removeOfflineMessage();
    ChatMessage msg =
        ChatMessage.device('You are offline.', ChatMessageType.deviceMessage);
    add(msg);
  }

  void removeOfflineMessage() {
    _items.removeWhere(
        (msg) => (msg.messageType == ChatMessageType.deviceMessage));
    notifyListeners();
  }

  Future<void> _getRemoteData() async {
    try {
      _items = await ChatService().fetch(0);
      ChatService.pageCount += 10;
      notifyListeners();
    } catch (e) {
      print(e.toString());
    }
  }

  void refresh() {
    notifyListeners();
  }
}
