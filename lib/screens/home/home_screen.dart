import 'package:my_fintech_app/screens/account/account_screen.dart';
import 'package:my_fintech_app/screens/budget/budget_screen.dart';
import 'package:my_fintech_app/screens/transaction/transaction_screen.dart';
import 'package:flutter/material.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({Key? key}) : super(key: key);

  static const String _title = 'MyFinApp';

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      initialIndex: 0,
      length: 3,
      child: Scaffold(
        appBar: AppBar(
          title: const Text(HomeScreen._title),
          actions: [
            IconButton(
              icon: const Icon(Icons.more_vert_sharp),
              tooltip: 'More options',
              onPressed: () {},
            ),
          ], 
          bottom: const TabBar(
            tabs: <Widget>[
              Tab(
                icon: Icon(Icons.forum_sharp),
                text: 'FinChat',
              ),
              Tab(
                icon: Icon(Icons.account_balance_sharp),
                text: 'Accounts',
              ),
              Tab(
                icon: Icon(Icons.tune_sharp),
                text: 'Budget',
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
              child: BudgetScreen(),
            ),
          ],
        ),
      ),
    );
  }
}
