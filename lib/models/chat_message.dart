import 'package:flutter/foundation.dart';

class ChatMessage extends ChangeNotifier {
  int id = 0;
  String message = '';
  ChatMessageType messageType = ChatMessageType.deviceMessage;
  String createdDate = '';
  String createdTime = '';
  bool _savedOnline = false;
  bool transaction = false;
  bool _deleted = false;
  String imagePath = '';
  dynamic reportData;

  ChatMessage.user(this.message, this.messageType, this.createdDate, this.createdTime, this._savedOnline);

  ChatMessage.device(this.message, this.messageType);

  ChatMessage.photo(this.imagePath, this.messageType, this.createdDate, this.createdTime);

  ChatMessage.report(this.reportData, this.messageType);

  ChatMessage(
      this.id,
      this.message,
      this.messageType,
      this.createdDate,
      this.createdTime,
      this._savedOnline,
      this.transaction,
      this._deleted,
      this.imagePath);

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
