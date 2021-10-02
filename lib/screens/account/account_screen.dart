import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '/models/accounts_list.dart';
import '/widgets/tab_title.dart';
import 'account_list_item.dart';

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
                //return AccountBox(accounts.items[index]);
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