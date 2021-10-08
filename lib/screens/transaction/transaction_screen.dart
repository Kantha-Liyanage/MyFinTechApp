import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:flutter/material.dart';
import 'package:my_fintech_app/screens/transaction/photo_bubble.dart';
import 'package:my_fintech_app/services/connectivity_service.dart';
import 'package:provider/provider.dart';
import 'package:my_fintech_app/models/chat_messages_list.dart';
import 'package:my_fintech_app/screens/transaction/chat_box.dart';
import 'package:my_fintech_app/screens/transaction/chat_bubble.dart';

class TransactionScreen extends StatelessWidget {
  TransactionScreen({Key? key}) : super(key: key);

  final ScrollController _scrollController = ScrollController();

  @override
  Widget build(BuildContext context) {
    ChatMessagesList chats =
        Provider.of<ChatMessagesList>(context, listen: true);

    ConnectivityService connectivityService =
        Provider.of<ConnectivityService>(context, listen: true);

    connectivityService.addListener(()=>{
      _handleNetworkConnectivity(connectivityService, chats)
    });

    return Stack(
      children: [
        //Chat ListView
        Expanded(
          child: Padding(
            padding: const EdgeInsets.fromLTRB(0, 0, 0, 75),
            child: ListView.builder(
              padding: const EdgeInsets.all(8),
              itemCount: chats.items.length,
              controller: _scrollController,
              itemBuilder: (BuildContext context, int index) {
                if(chats.items[index].photoMessage){
                  return ChangeNotifierProvider.value(
                    value: chats.items[index],
                    child: const PhotoBubble(),
                  );
                } else{
                  return ChangeNotifierProvider.value(
                    value: chats.items[index],
                    child: const ChatBubble(),
                  );
                }
              },
            ),
          ),
        ),

        //Input ChatBox
        Expanded(
          child: Align(
            alignment: FractionalOffset.bottomCenter,
            child: ChatBox(_scrollChatToBottom),
          ),
        ),
      ],
    );
  }

  _scrollChatToBottom() {
    _scrollController.animateTo(_scrollController.position.maxScrollExtent + 250,
        duration: const Duration(milliseconds: 1000), curve: Curves.easeOut);
  }

  _handleNetworkConnectivity(ConnectivityService connectivityService, ChatMessagesList chats) {
    if(connectivityService.connectivityResult == ConnectivityResult.none){
      chats.addOfflineMessage();
    } else{
      chats.removeOfflineMessage();
    }
  }
}
