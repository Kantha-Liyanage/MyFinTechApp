import 'package:flutter/material.dart';
import 'package:my_fintech_app/models/account.dart';
import 'package:my_fintech_app/models/accounts_list.dart';
import 'package:my_fintech_app/models/budget_categories_list.dart';
import 'package:my_fintech_app/models/budget_category.dart';
import 'package:my_fintech_app/models/user.dart';
import 'package:my_fintech_app/screens/account/account_screen.dart';
import 'package:my_fintech_app/screens/budget/category_screen.dart';
import 'package:my_fintech_app/screens/home/intro_logon_screen.dart';
import 'package:my_fintech_app/screens/transaction/transaction_screen.dart';
import 'package:my_fintech_app/services/util.dart';
import 'package:my_fintech_app/widgets/popup_confirmation.dart';
import 'package:provider/provider.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({Key? key}) : super(key: key);

  static const String _title = 'FinChat';

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen>
    with SingleTickerProviderStateMixin {
  late TabController tabController;
  late AccountsList accounts;
  late BudgetCategoriesList tags;
  List<String> moreMenuItems = ['New Account', 'New Category', 'Logout'];

  @override
  void initState() {
    super.initState();
    tabController = TabController(length: 3, vsync: this);
  }

  @override
  Widget build(BuildContext context) {
    accounts = Provider.of<AccountsList>(context, listen: true);
    tags = Provider.of<BudgetCategoriesList>(context, listen: true);

    return DefaultTabController(
      initialIndex: 0,
      length: 3,
      child: Scaffold(
        appBar: AppBar(
          title: const Text(HomeScreen._title),
          actions: <Widget>[
            PopupMenuButton<String>(
              onSelected: _handleAppBarMenuItemClick,
              itemBuilder: (BuildContext context) {
                return moreMenuItems.map((String choice) {
                  return PopupMenuItem<String>(
                    value: choice,
                    child: Text(
                      choice,
                      style: Theme.of(context).textTheme.caption,
                    ),
                  );
                }).toList();
              },
            ),
          ],
          bottom: TabBar(
            controller: tabController,
            tabs: const <Widget>[
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
                text: 'CATEGORIES',
              ),
            ],
          ),
        ),
        body: TabBarView(
          controller: tabController,
          children: <Widget>[
            Center(
              child: TransactionScreen(),
            ),
            const Center(
              child: AccountScreen(),
            ),
            const Center(
              child: CategoryScreen(),
            ),
          ],
        ),
      ),
    );
  }

  int accountCount = 1;
  int categoryCount = 1;

  void _handleAppBarMenuItemClick(String value) {
    //New Account
    if (value == moreMenuItems[0]) {
      _moveToTab(1);
      _addNewAccount();
    }
    //New budget category
    else if (value == moreMenuItems[1]) {
      _moveToTab(2);
      _addNewCategory();
    }
    //Logout
    else if (value == moreMenuItems[2]) {
      PopupConfirmation('Are you sure you want to logout?', _logout)
          .showConfirmationDialog(context);
    }
  }

  void _addNewAccount() {
    Account acc =
        Account(0, 'New Account ' + accountCount.toString(), AccountType.asset, 0);
    setState(() {
      accountCount++;
    });
    accounts.insert(0, acc);
    Util.showToast("New account added.");
  }

  _addNewCategory() {
    BudgetCategory tag =
        BudgetCategory(0, 'New Category ' + categoryCount.toString() , BudgetCategoryType.expense, 0, 0);
    setState(() {
      categoryCount++;
    });
    tags.insert(0, tag);
    Util.showToast("New Category added.");
  }

  void _logout() {
    User.logout();
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => const IntroLogonScreen()),
    );
  }

  void _moveToTab(int index) {
    tabController.animateTo(index);
  }
}
