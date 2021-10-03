import 'package:flutter/material.dart';
import 'package:my_fintech_app/screens/account/account_screen.dart';
import 'package:my_fintech_app/screens/budget/budget_screen.dart';
import 'package:my_fintech_app/screens/transaction/transaction_screen.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({Key? key}) : super(key: key);

  static const String _title = 'FinChat';

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      initialIndex: 0,
      length: 3,
      child: Scaffold(
        appBar: AppBar(
          title: const Text(HomeScreen._title),
          actions: <Widget>[
          PopupMenuButton<String>(
            onSelected: handleAppBarMenuItemClick,
            itemBuilder: (BuildContext context) {
              return {'New Account', 'New Budget Item', 'Settings', 'Logout'}.map((String choice) {
                return PopupMenuItem<String>(
                  value: choice,
                  child: Text(choice, 
                    style: Theme.of(context).textTheme.caption,
                  ),
                );
              }).toList();
            },
          ),
        ], 
          bottom: const TabBar(
            tabs: <Widget>[
              Tab(
                icon: Icon(Icons.forum_sharp),
                text: 'CHAT',
              ),
              Tab(
                icon: Icon(Icons.account_balance_sharp),
                text: 'ACCOUNTS',
              ),
              Tab(
                icon: Icon(Icons.tune_sharp),
                text: 'BUDGET',
              ),
            ],
          ),
        ),
        body: TabBarView(
          children: <Widget>[
            Center(
              child: TransactionScreen(),
            ),
            const Center(
              child: AccountScreen(),
            ),
            const Center(
              child: BudgetScreen(),
            ),
          ],
        ),
      ),
    );
  }

  void handleAppBarMenuItemClick(String value) {
    switch (value) {
      case 'New Account':
        break;
      case 'New Budget Item':
        break;
      case 'Settings':
        break;
      case 'Logout':
        break;
    }
  }
}
