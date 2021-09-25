import 'package:flutter/material.dart';
import 'package:my_fintech_app/models/account.dart';
import 'package:my_fintech_app/widgets/account_box.dart';
import 'package:my_fintech_app/widgets/tab_title.dart';

class AccountScreen extends StatefulWidget {
  const AccountScreen({Key? key}) : super(key: key);

  @override
  _AccountScreenState createState() => _AccountScreenState();
}

class _AccountScreenState extends State<AccountScreen> {
  List<Account> accounts = <Account>[
    Account('Cash', AccountType.Asset, 12500.00, '2021-09-21', '13:34:00'),
    Account('Seylan', AccountType.Asset, 45000.00, '2021-09-21', '13:34:00'),
    Account('HSBC CC', AccountType.Liability, 100000.00, '2021-09-21', '13:34:00'),
    Account('HNB CC', AccountType.Liability, 100000.00, '2021-09-21', '13:34:00'),
    Account('SYLN CC', AccountType.Liability, 500000.00, '2021-09-21', '13:34:00')
  ];

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [ 
        TabTitle('Accounts'),
        Expanded(
          flex: 1,
          child: Padding(
            padding: const EdgeInsets.all(8),
            child: ListView.separated(
              padding: const EdgeInsets.all(8),
              itemCount: accounts.length,
              itemBuilder: (BuildContext context, int index) {
                return AccountBox(accounts[index]);
              }, 
              separatorBuilder: (BuildContext context, int index) {
                return const Divider(
                  color: Colors.blue,
                );
              },
            )
          )
        )
      ]
    );
  }
}
