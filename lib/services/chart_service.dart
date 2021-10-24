import 'dart:convert';
import 'package:my_fintech_app/models/chat_message.dart';
import 'package:my_fintech_app/models/transaction.dart';
import 'package:my_fintech_app/services/http_service.dart';
import 'battery_service.dart';
import 'connectivity_service.dart';
import 'database_service.dart';

class ChatService extends HTTPSerivce {
  static int pageCount = 0;

  Future<List<ChatMessage>> fetch(int count) async {
    List<ChatMessage> list = [];
    //Online?
    if (ConnectivityService.isConnected()) {
      final response = await authenticatedHttpGet('chats/' + count.toString());
      if (response.statusCode == 200) {
        var listObj = List.from(jsonDecode(response.body)['chats']);
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
      } else {
        // If the server did not return a 200 OK response,
        // then throw an exception.
        throw Exception('Failed to load chats.');
      }
    }

    //Offline
    List<ChatMessage> listOffline = await DatabaseSerivce.getOfflineChats();
    list.addAll(listOffline);
    return list;
  }

  Future<bool> createMessage(ChatMessage chartMessage) async {
    //Battery level
    bool batteryOk = false;
    if (BatteryService.isHealthy()) {
      batteryOk = true;
    }

    //Online? No need to save to local storage
    if (ConnectivityService.isConnected()) {
      //Save offline and get ID
      await DatabaseSerivce.createOfflineChat(chartMessage);

      var data = {
        "id": chartMessage.id.toString(),
        "message": chartMessage.message,
        "createdDate": chartMessage.createdDate,
        "createdTime": chartMessage.createdTime,
        "imagePath": chartMessage.imagePath
      };

      final response = await authenticatedHttpPost('chats', data);
      if (response.statusCode == 200) {
        //Notifier
        chartMessage.savedOnline = true;
        DatabaseSerivce.removeOfflineChat(chartMessage);
        return true;
      } else {
        chartMessage.savedOnline = false;
        return false;
      }
    } else {
      //Save offline
      await DatabaseSerivce.createOfflineChat(chartMessage);
      return true;
    }
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
