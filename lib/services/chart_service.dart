import 'dart:convert';
import 'package:my_fintech_app/models/chat_message.dart';
import 'package:my_fintech_app/models/transaction.dart';
import 'package:my_fintech_app/services/http_service.dart';

class ChatService extends HTTPSerivce {
  static int pageCount = 0;

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
            listObj[i]['transaction'],
            listObj[i]['deleted'],
            listObj[i]['imagePath']);
        list.add(chat);
      }
      return list;
    } else {
      // If the server did not return a 200 OK response,
      // then throw an exception.
      throw Exception('Failed to load chats.');
    }
  }

  Future<bool> createMessage(ChatMessage chartMessage) async {
    var data = {
      "message": chartMessage.message,
      "createdDate": chartMessage.createdDate,
      "createdTime": chartMessage.createdTime,
      "imagePath": chartMessage.imagePath
    };

    final response = await authenticatedHttpPost('chats', data);
    if (response.statusCode == 200) {
      //Notifier
      chartMessage.savedOnline = true;
      return true;
    }
    return false;
  }

  Future<bool> createTransaction(
      ChatMessage chartMessage, Transaction transaction) async {
    var data = {
      "message": chartMessage.message,
      "createdDate": chartMessage.createdDate,
      "createdTime": chartMessage.createdTime,
      "imagePath": chartMessage.imagePath,
      "transaction": json.encode({
        "account": transaction.account,
        "category": transaction.tag,
        "amount": transaction.amount.toString(),
        "date": transaction.date
      })
    };

    final response = await authenticatedHttpPost('chats', data);
    if (response.statusCode == 200) {
      //Notifier
      chartMessage.savedOnline = true;
      return true;
    }
    return false;
  }

  Future<bool> delete(int id) async {
    var data = {"id": id.toString()};

    final response = await authenticatedHttpDelete('chats', data);
    if (response.statusCode == 200) {
      return true;
    }
    return false;
  }
}
