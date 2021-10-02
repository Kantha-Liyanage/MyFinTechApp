import 'package:flutter/foundation.dart';

class ChatMessage extends ChangeNotifier {
  int id = 0;
  String message = '';
  ChatMessageType messageType = ChatMessageType.deviceMessage;
  String createdDate = '';
  String createdTime = '';
  bool _savedOnline = false;
  bool _deleted = false;

  bool get savedOnline => _savedOnline;
  set savedOnline(bool savedOnline) {
    _savedOnline = savedOnline;
    notifyListeners();
  }

  bool get deleted => _deleted;
  set deleted(bool deleted) {
    _deleted = deleted;
    notifyListeners();
  }
}

enum ChatMessageType { userMessage, serverMessage, deviceMessage }
