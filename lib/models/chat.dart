class ChatMessage {
  final String message;
  final int messageType;
  final String createdDate;
  final String createdTime;
  bool savedOnline;

  ChatMessage(this.message, this.messageType, this.createdDate,
      this.createdTime, this.savedOnline);
}

class ChatMessageTypes {
  static const int USER_MESSAGE = 0;
  static const int SERVER_MESSAGE = 1;
  static const int DEVICE_MESSAGE = 2;
}
