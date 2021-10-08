import 'package:flutter/foundation.dart';

class ChatMessage extends ChangeNotifier {
  int id = 0;
  String message = '';
  ChatMessageType messageType = ChatMessageType.deviceMessage;
  String createdDate = '';
  String createdTime = '';
  bool _savedOnline = false;
  bool _deleted = false;
  String imagePath = '';

  ChatMessage.user(this.message, this.messageType, this.createdDate, this.createdTime, this._savedOnline);

  ChatMessage.device(this.message, this.messageType);

  ChatMessage.photo(
      this.imagePath, this.messageType, this.createdDate, this.createdTime);

  ChatMessage(this.id, this.message, this.messageType, this.createdDate,
      this.createdTime, this._savedOnline, this._deleted, this.imagePath);

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

  bool get photoMessage => (imagePath.isNotEmpty);
}

enum ChatMessageType { userMessage, serverMessage, deviceMessage }
