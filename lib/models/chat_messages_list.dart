import 'package:flutter/foundation.dart';
import 'chat_message.dart';

class ChatMessagesList extends ChangeNotifier {

  final List<ChatMessage> _items = <ChatMessage>[];
  
  List<ChatMessage> get items => _items;

  void add(ChatMessage item) {
    _items.add(item);
    notifyListeners();
  }

}
