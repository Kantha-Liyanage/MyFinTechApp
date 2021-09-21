class ChatMessage {
  
  final String message;
  final ChatMessageType messageType;
  final String createdDate;
  final String createdTime;
  bool savedOnline;

  ChatMessage(this.message, this.messageType, this.createdDate,
      this.createdTime, this.savedOnline);
}

enum ChatMessageType { USER_MESSAGE, SERVER_MESSAGE, DEVICE_MESSAGE }
