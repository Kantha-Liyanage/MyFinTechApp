import 'package:flutter/material.dart';
import 'package:my_fintech_app/models/accounts_list.dart';
import 'package:my_fintech_app/screens/account/account_list_item.dart';
import 'package:my_fintech_app/widgets/tab_title.dart';
import 'package:provider/provider.dart';

class AccountScreen extends StatelessWidget {
  const AccountScreen({ Key? key }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    AccountsList accounts = Provider.of<AccountsList>(context, listen: true);

    return Column(
      children: [
        const TabTitle('Accounts'),
        Expanded(
          flex: 1,
          child: Padding(
            padding: const EdgeInsets.all(8),
            child: ListView.separated(
              padding: const EdgeInsets.all(8),
              itemCount: accounts.items.length,
              itemBuilder: (BuildContext context, int index) {
                return ChangeNotifierProvider.value(
                  value: accounts.items[index],
                  child: const AccountListItem(),
                );  
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