import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:flutter/material.dart';
import 'package:my_fintech_app/models/chat_message.dart';
import 'package:my_fintech_app/screens/transaction/bubbles/bar_chart_chat_bubble.dart';
import 'package:my_fintech_app/screens/transaction/bubbles/photo_bubble.dart';
import 'package:my_fintech_app/screens/transaction/bubbles/pie_chart_chat_bubble.dart';
import 'package:my_fintech_app/services/chart_service.dart';
import 'package:my_fintech_app/services/connectivity_service.dart';
import 'package:my_fintech_app/services/util.dart';
import 'package:provider/provider.dart';
import 'package:my_fintech_app/models/chat_messages_list.dart';
import 'package:my_fintech_app/screens/transaction/chat_box.dart';
import 'package:my_fintech_app/screens/transaction/bubbles/chat_bubble.dart';

class TransactionScreen extends StatelessWidget {
  TransactionScreen({Key? key}) : super(key: key);

  final ScrollController _scrollController = ScrollController();

  @override
  Widget build(BuildContext context) {
    ChatMessagesList chats =
        Provider.of<ChatMessagesList>(context, listen: true);

    ConnectivityService connectivityService =
        Provider.of<ConnectivityService>(context, listen: true);

    connectivityService.addListener(
        () => {_handleNetworkConnectivity(connectivityService, chats)});

    return Stack(
      children: [
        //Chat ListView
        Expanded(
          child: Padding(
            padding: const EdgeInsets.fromLTRB(0, 0, 0, 75),
            child: RefreshIndicator(
                onRefresh: () async {
                  _loadMoreCharts(chats);
                },
                child: ListView.builder(
                  physics: const AlwaysScrollableScrollPhysics(),
                  padding: const EdgeInsets.all(8),
                  itemCount: chats.items.length,
                  controller: _scrollController,
                  itemBuilder: (BuildContext context, int index) {
                    if (chats.items[index].photoMessage) {
                      return ChangeNotifierProvider.value(
                        value: chats.items[index],
                        child: const PhotoBubble(),
                      );
                    } else if (chats.items[index].pieChartMessage) {
                      return ChangeNotifierProvider.value(
                        value: chats.items[index],
                        child: PieChartChatBubble(
                            '', chats.items[index].reportData),
                      );
                    } else if (chats.items[index].barChartMessage) {
                      return ChangeNotifierProvider.value(
                        value: chats.items[index],
                        child: BarChartChatBubble.withActualData(
                            chats.items[index].reportData),
                      );
                    } else {
                      return ChangeNotifierProvider.value(
                        value: chats.items[index],
                        child: const ChatBubble(),
                      );
                    }
                  },
                )),
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
    try {
      _scrollController.animateTo(
          (_scrollController.position.maxScrollExtent +
              _scrollController.position.extentAfter),
          duration: const Duration(milliseconds: 1000),
          curve: Curves.easeOut);
    } catch (er) {}
  }

  _handleNetworkConnectivity(
      ConnectivityService connectivityService, ChatMessagesList chats) {
    if (ConnectivityService.connectivityResult == ConnectivityResult.none) {
      chats.addOfflineMessage();
      _scrollChatToBottom();
    } else {
      chats.removeOfflineMessage();
    }
  }

  Future<void> _loadMoreCharts(ChatMessagesList chats) async {
    try {
      List<ChatMessage> olderChats =
          await ChatService().fetch(ChatService.pageCount);
      chats.addOlderMessages(olderChats);
      ChatService.pageCount += 10;
      Util.showToast('Older entries retrieved.');
    } catch (er) {
      Util.showToast("No more older messages.");
    }
  }
}
