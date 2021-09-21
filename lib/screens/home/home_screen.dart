import 'package:em_fintech_app/screens/account/account_screen.dart';
import 'package:em_fintech_app/screens/transaction/transaction_screen.dart';
import 'package:flutter/material.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({Key? key}) : super(key: key);

  static const String _title = 'MyFinApp';

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      initialIndex: 0,
      length: 3,
      child: Scaffold(
        appBar: AppBar(
          title: const Text(_title),
          bottom: const TabBar(
            tabs: <Widget>[
              Tab(
                icon: Icon(Icons.forum_sharp),
              ),
              Tab(
                icon: Icon(Icons.account_balance_sharp),
              ),
              Tab(
                icon: Icon(Icons.tag_sharp),
              ),
            ],
          ),
        ),
        body: const TabBarView(
          children: <Widget>[
            Center(
              child: TransactionScreen(),
            ),
            Center(
              child: AccountScreen(),
            ),
            Center(
              child: Text("It's sunny here"),
            ),
          ],
        ),
      ),
    );
  }
}
