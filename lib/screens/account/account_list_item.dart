import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:my_fintech_app/models/accounts_list.dart';
import 'package:my_fintech_app/services/account_service.dart';
import 'package:my_fintech_app/widgets/popup_confirmation.dart';
import 'package:provider/provider.dart';
import 'package:my_fintech_app/models/account.dart';

class AccountListItem extends StatefulWidget {
  const AccountListItem({Key? key}) : super(key: key);

  @override
  State<AccountListItem> createState() => _AccountListItemState();
}

class _AccountListItemState extends State<AccountListItem> {
  late String tmpAccountName;
  late AccountType tmpAccountType;
  late TextEditingController textEditingController;
  late Account account;
  late AccountsList accounts;

  @override
  Widget build(BuildContext context) {
    account = Provider.of<Account>(context, listen: true);
    accounts = Provider.of<AccountsList>(context, listen: true);

    return GestureDetector(
      child: (account.editable
          ? _buildEditableWidget(context)
          : _buildViewOnlyWidget(context)),
      onLongPress: () {
        _toggleEditMode(account);
      },
    );
  }

  _toggleEditMode(Account account) {
    account.editable = !account.editable;
    tmpAccountName = account.name;
    tmpAccountType = account.accountType;
    textEditingController = TextEditingController(text: tmpAccountName);
  }

  _buildEditableWidget(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.start,
      children: [
        Row(
          children: [
            Expanded(
              flex: 2,
              child: TextField(
                controller: textEditingController,
                decoration: const InputDecoration(
                    border: UnderlineInputBorder(), labelText: 'Account Name'),
                onChanged: (String newValue) {
                  setState(() {
                    tmpAccountName = newValue;
                  });
                },
                style: Theme.of(context).textTheme.bodyText1,
              ),
            ),
            Expanded(
              flex: 1,
              child: DropdownButton<AccountType>(
                value: tmpAccountType,
                icon: const Icon(Icons.keyboard_arrow_down_sharp),
                iconSize: 24,
                elevation: 16,
                style: Theme.of(context).textTheme.bodyText1,
                onChanged: (AccountType? newValue) {
                  setState(() {
                    tmpAccountType = newValue!;
                  });
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
                    //Update account locally
                    account.editable = false;
                    account.name = tmpAccountName;
                    account.accountType = tmpAccountType;

                    //Update account at server-side
                    AccountService().update(account);
                  },
                  icon: const Icon(Icons.check_sharp),
                )),
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
                  PopupConfirmation(
                          'Are you sure you want to delete the selected account?',
                          _delete)
                      .showConfirmationDialog(context);
                },
                icon: const Icon(Icons.delete_sharp),
              ),
            ),
          ],
        ),
      ],
    );
  }

  _delete() {
    AccountService().delete(account.id);
    accounts.remove(account);
  }

  _buildViewOnlyWidget(BuildContext context) {
    return Container(
        padding: const EdgeInsets.all(12),
        decoration: BoxDecoration(
            boxShadow: [
              BoxShadow(
                  blurRadius: .5,
                  spreadRadius: 1.5,
                  color: Colors.black.withOpacity(.20))
            ],
            color: Colors.amber.shade50,
            borderRadius: BorderRadius.circular(15)),
        child: Row(
          children: [
            Expanded(
              flex: 3,
              child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(account.name,
                        style: Theme.of(context).textTheme.caption),
                    Container(
                      padding: const EdgeInsets.fromLTRB(0, 8, 0, 0),
                      child: Text(
                        'Current Balance',
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
                  Text(
                    AccountTypeWithDescription.get(account.accountType).name,
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
        ));
  }
}
