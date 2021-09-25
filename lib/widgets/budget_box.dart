import 'package:flutter/material.dart';
import 'package:my_fintech_app/models/tag.dart';
import 'amount_field.dart';

class BudgetBox extends StatefulWidget {
  Tag tag;

  BudgetBox(this.tag, {Key? key}) : super(key: key);

  @override
  _BudgetBoxState createState() => _BudgetBoxState();
}

class _BudgetBoxState extends State<BudgetBox> {
  bool editable = false;

  @override
  Widget build(BuildContext context) {
    return Container(
      child: (editable?buildEditableWidget():buildViewOnlyWidget()) 
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
              Text(widget.tag.name, style: const TextStyle(fontWeight: FontWeight.bold)),
              Container(
                padding: const EdgeInsets.fromLTRB(0, 8, 0, 0),
                child: const Text('Utilized Amount'),
              ),
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
              Text(widget.tag.budgetAmount.toString(), style: const TextStyle(fontWeight: FontWeight.bold)),
              Container(
                padding: const EdgeInsets.fromLTRB(0, 8, 0, 0),
                child: Text(widget.tag.utilizedAmount.toString()),
              ),
              Container(
                padding: const EdgeInsets.fromLTRB(0, 8, 0, 0),
                child: Text(widget.tag.getBalance().toString()),
              ),
            ]
          ),
        ),
      ],
    );  
  }

  buildEditableWidget() {
    return Row(
      children: [
        Expanded(
          flex: 3,
          child: TextField(
            controller: TextEditingController()..text = widget.tag.name,
            decoration: const InputDecoration(
                border: UnderlineInputBorder(), labelText: 'Account Name'),
          ),
        ),
        Expanded(
          flex: 1,
          child: AmountField('Monthly', widget.tag.budgetAmount)
        ),
      ],
    );
  }
}
