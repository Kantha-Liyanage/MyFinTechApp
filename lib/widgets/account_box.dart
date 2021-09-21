import 'package:flutter/material.dart';
import 'package:my_fintech_app/models/account.dart';

class AccountBox extends StatefulWidget {
  Account account;

  AccountBox(this.account, {Key? key}) : super(key: key);

  @override
  _AccountBoxState createState() => _AccountBoxState();
}

class _AccountBoxState extends State<AccountBox> {
  String dropdownValue = 'Debit';

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Expanded(
          flex: 4,
          child: Text(widget.account.name),
        ),
        Expanded(
          flex: 1,
          child: DropdownButton<String>(
            value: dropdownValue,
            icon: const Icon(Icons.keyboard_arrow_down_sharp),
            iconSize: 24,
            elevation: 16,
            style: const TextStyle(color: Colors.deepPurple),
            underline: Container(
              height: 2,
              color: Colors.deepPurpleAccent,
            ),
            onChanged: (String? newValue) {
              setState(() {
                dropdownValue = newValue!;
              });
            },
            items: <String>['Debit', 'Credit']
                .map<DropdownMenuItem<String>>((String value) {
              return DropdownMenuItem<String>(
                value: value,
                child: Text(value),
              );
            }).toList(),
          ),
        ),
      ],
    );
  }
}
