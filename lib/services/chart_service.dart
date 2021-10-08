import 'dart:convert';
import 'package:my_fintech_app/models/chat_message.dart';
import 'package:my_fintech_app/services/http_service.dart';

class ChatService extends HTTPSerivce {
  Future<List<ChatMessage>> fetch(int count) async {
    final response = await authenticatedHttpGet('chats/' + count.toString());

    if (response.statusCode == 200) {
      var listObj = List.from(jsonDecode(response.body)['chats']);
      List<ChatMessage> list = [];
      for (int i = 0; i < listObj.length; i++) {
        ChatMessage chat = ChatMessage(
            listObj[i]['id'],
            listObj[i]['message'],
            ChatMessageType.userMessage,
            listObj[i]['createdDate'],
            listObj[i]['createdTime'],
            true,
            listObj[i]['deleted'],
            listObj[i]['imagePath']);
        list.add(chat);
      }
      return list;
    } else {
      // If the server did not return a 200 OK response,
      // then throw an exception.
      throw Exception('Failed to load accounts.');
    }
  }

  Future<bool> create(ChatMessage chartMessage) async {
    var data = {
      "message" : chartMessage.message,
      "createdDate" : chartMessage,
      "createdTime" : chartMessage,
      "imagePath": chartMessage.imagePath
    };

    final response = await authenticatedHttpPost('chats', data);
    if (response.statusCode == 200) {
      return true;
    }
    return false;
  }

  Future<bool> delete(int id) async {
    var data = {
      "id" : id.toString()
    };

    final response = await authenticatedHttpDelete('chats', data);
    if (response.statusCode == 200) {
      return true;
    }
    return false;
  }
}
