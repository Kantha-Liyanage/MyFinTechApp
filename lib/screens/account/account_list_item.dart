import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '/models/account.dart';

class AccountListItem extends StatelessWidget {
  const AccountListItem({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    Account account = Provider.of<Account>(context, listen: true);

    return GestureDetector(
      child: (account.editable
          ? buildEditableWidget(context, account)
          : buildViewOnlyWidget(context, account)),
      onLongPress: () {
        toggleEditMode(account);
      },
    );
  }

  toggleEditMode(Account account) {
    account.editable = !account.editable;
  }

  buildEditableWidget(BuildContext context, Account account) {
    String tmpName = account.name;
    AccountType tmpAccountType = account.accountType;

    return Column(
      mainAxisAlignment: MainAxisAlignment.start,
      children: [
        Row(
          children: [
            Expanded(
              flex: 2,
              child: TextField(
                controller: TextEditingController()..text = account.name,
                decoration: const InputDecoration(
                    border: UnderlineInputBorder(), labelText: 'Account Name'),
                onChanged: (String newValue) {
                  if (newValue.trim() != '') {
                    tmpName = newValue;
                  }
                },
                style: Theme.of(context).textTheme.bodyText1,
              ),
            ),
            Expanded(
              flex: 1,
              child: DropdownButton<AccountType>(
                value: account.accountType,
                icon: const Icon(Icons.keyboard_arrow_down_sharp),
                iconSize: 24,
                elevation: 16,
                style: Theme.of(context).textTheme.bodyText1,
                onChanged: (AccountType? newValue) {
                  if (newValue != Null) {
                    tmpAccountType = newValue!;
                  }
                },
                items: AccountTypeWithDescription.getAll()
                    .map((AccountTypeWithDescription value) {
                  return DropdownMenuItem<AccountType>(
                    value: value.accountType,
                    child: Text(value.name),
                  );
                }).toList(),
              ),
            ),
          ],
        ),
        Row(
          children: [
            Expanded(
              flex: 1,
              child: IconButton(
                onPressed: () {
                  account.editable = false;
                  account.name = tmpName;
                  account.accountType = tmpAccountType;
                },
                icon: const Icon(Icons.check_sharp),
              )
            ),
            Expanded(
              flex: 1,
              child: IconButton(
                onPressed: () {
                  account.editable = false;
                },
                icon: const Icon(Icons.clear_sharp),
              ),
            ),
            Expanded(
              flex: 1,
              child: IconButton(
                onPressed: () {
                  //Confirm delete?
                },
                icon: const Icon(Icons.delete_sharp),
              ),
            ),
          ],
        ),
      ],
    );
  }

  buildViewOnlyWidget(BuildContext context, Account account) {
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        boxShadow: [
          BoxShadow(
              blurRadius: .5,
              spreadRadius: 1.5,
              color: Colors.black.withOpacity(.20))
        ],
        color: Colors.grey.shade200,
        borderRadius: BorderRadius.circular(15)
      ),
      child: Row(
        children: [
          Expanded(
            flex: 3,
            child:
                Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
              Text(account.name,
                  style: Theme.of(context).textTheme.caption),
              Container(
                padding: const EdgeInsets.fromLTRB(0, 8, 0, 0),
                child: Text('Current Balance',
                  style: Theme.of(context).textTheme.subtitle1,
                ),
              ),
            ]),
          ),
          Expanded(
            flex: 1,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                Text(AccountTypeWithDescription.get(account.accountType).name,
                  style: Theme.of(context).textTheme.subtitle1,
                ),
                Container(
                  padding: const EdgeInsets.fromLTRB(0, 8, 0, 0),
                  child: Text(account.currentBalance.toString(),
                      style: Theme.of(context).textTheme.caption),
                ),
              ],
            ),
          ),
        ],
      )
    );
  }
}
