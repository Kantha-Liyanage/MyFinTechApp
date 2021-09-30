import 'package:flutter/material.dart';
import 'package:my_fintech_app/models/tag.dart';
import 'package:provider/provider.dart';

class BudgetListItem extends StatelessWidget {
  const BudgetListItem({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    Tag tag = Provider.of<Tag>(context, listen: true);

    return GestureDetector(
      child:
          (tag.editable ? buildEditableWidget(tag) : buildViewOnlyWidget(tag)),
      onLongPress: () {
        toggleEditMode(tag);
      },
    );
  }

  toggleEditMode(Tag tag) {
    tag.editable = !tag.editable;
  }

  buildViewOnlyWidget(Tag tag) {
    return Row(
      children: [
        Expanded(
          flex: 3,
          child:
              Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
            Text(tag.name, style: const TextStyle(fontWeight: FontWeight.bold)),
            Container(
              padding: const EdgeInsets.fromLTRB(0, 8, 0, 0),
              child: const Text('Utilized Amount'),
            ),
            Container(
              padding: const EdgeInsets.fromLTRB(0, 8, 0, 0),
              child: const Text('Current Balance'),
            ),
          ]),
        ),
        Expanded(
          flex: 1,
          child: Column(crossAxisAlignment: CrossAxisAlignment.end, children: [
            Text(tag.budgetAmount.toString(),
                style: const TextStyle(fontWeight: FontWeight.bold)),
            Container(
              padding: const EdgeInsets.fromLTRB(0, 8, 0, 0),
              child: Text(tag.utilizedAmount.toString()),
            ),
            Container(
              padding: const EdgeInsets.fromLTRB(0, 8, 0, 0),
              child: Text(tag.balance.toString()),
            ),
          ]),
        ),
      ],
    );
  }

  buildEditableWidget(Tag tag) {
    String tmpName = tag.name;
    double budgetAmount = tag.budgetAmount;

    return Column(
      mainAxisAlignment: MainAxisAlignment.start,
      children: [
        Row(
          children: [
            Expanded(
              flex: 3,
              child: TextField(
                controller: TextEditingController()..text = tag.name,
                decoration: const InputDecoration(
                    border: UnderlineInputBorder(), labelText: 'Account Name'),
                onSubmitted: (String newValue) {
                  if (newValue.trim() != '') {
                    tag.name = newValue;
                  }
                },
              ),
            ),
            Expanded(
                flex: 1,
                child: TextField(
                  decoration: const InputDecoration(
                    border: UnderlineInputBorder(),
                    labelText: 'Monthly (Rs)',
                  ),
                  controller: TextEditingController()
                    ..text = tag.budgetAmount.toString(),
                  keyboardType: TextInputType.number,
                  onSubmitted: (String newValue) {
                    if (newValue.trim() != '') {
                      tag.budgetAmount = double.parse(newValue);
                    }
                  },
                ))
          ],
        ),
        Row(
          children: [
            Expanded(
                flex: 1,
                child: IconButton(
                  onPressed: () {
                    tag.editable = false;
                    tag.name = tmpName;
                    tag.budgetAmount = budgetAmount;
                  },
                  icon: const Icon(Icons.check_sharp),
                )),
            Expanded(
              flex: 1,
              child: IconButton(
                onPressed: () {
                  tag.editable = false;
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
}
