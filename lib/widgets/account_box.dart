import 'package:flutter/material.dart';
import 'package:my_fintech_app/models/account.dart';

class AccountBox extends StatefulWidget {
  Account account;

  AccountBox(this.account, {Key? key}) : super(key: key);

  @override
  _AccountBoxState createState() => _AccountBoxState();
}

class _AccountBoxState extends State<AccountBox> {
  AccountType dropdownValue = AccountType.Asset;
  bool editable = false;

  @override
  Widget build(BuildContext context) {
    return Container(
      child: (editable?buildEditableWidget():buildViewOnlyWidget()) 
    );
  }

  buildEditableWidget() {
    return Row(
      children: [
        Expanded(
          flex: 3,
          child: TextField(
            controller: TextEditingController()..text = widget.account.name,
            decoration: const InputDecoration(
                border: UnderlineInputBorder(), labelText: 'Account Name'),
          ),
        ),
        Expanded(
          flex: 1,
          child: DropdownButton<AccountType>(
            value: dropdownValue,
            icon: const Icon(Icons.keyboard_arrow_down_sharp),
            iconSize: 24,
            elevation: 16,
            style: const TextStyle(color: Colors.deepPurple),
            underline: Container(
              height: 2,
              color: Colors.blue,
            ),
            onChanged: (AccountType? newValue) {
              setState(() {
                dropdownValue = newValue!;
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
    );
  }

  buildViewOnlyWidget() {
    return Row(
      children: [
        Expanded(
          flex: 3,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start, 
            children: [
              Text(widget.account.name, style: const TextStyle(fontWeight: FontWeight.bold)),
              Container(
                padding: const EdgeInsets.fromLTRB(0, 8, 0, 0),
                child: const Text('Current Balance'),
              ),
            ]
          ),
        ),
        Expanded(
          flex: 1,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.end, 
            children: [
              Text(AccountTypeWithDescription.get(dropdownValue).name),
              Container(
                padding: const EdgeInsets.fromLTRB(0, 8, 0, 0),
                child: Text(widget.account.currentBalance.toString(), style: const TextStyle(fontWeight: FontWeight.bold)),
              ),
            ],
          ),
        ),
      ],
    );
  }
}
