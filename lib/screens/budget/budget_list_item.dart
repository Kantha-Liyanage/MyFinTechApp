import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '/models/tag.dart';

class BudgetListItem extends StatelessWidget {
  const BudgetListItem({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    Tag tag = Provider.of<Tag>(context, listen: true);

    return GestureDetector(
      child:
          (tag.editable ? buildEditableWidget(tag) : buildViewOnlyWidget(context, tag)),
      onLongPress: () {
        toggleEditMode(tag);
      },
    );
  }

  toggleEditMode(Tag tag) {
    tag.editable = !tag.editable;
  }

  buildViewOnlyWidget(BuildContext context, Tag tag) {
    return Row(
      children: [
        Expanded(
          flex: 3,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start, 
            children: [
              Text(tag.name, 
                style: Theme.of(context).textTheme.bodyText1),
              Container(
                padding: const EdgeInsets.fromLTRB(0, 8, 0, 0),
                child: Text('Utilized Amount',
                  style: Theme.of(context).textTheme.subtitle1,
                ),
              ),
              Container(
                padding: const EdgeInsets.fromLTRB(0, 8, 0, 0),
                child: Text('Current Balance',
                  style: Theme.of(context).textTheme.subtitle1,
                ),
              ),
            ]
          ),
        ),
        Expanded(
          flex: 1,
          child: Column(crossAxisAlignment: CrossAxisAlignment.end, children: [
            Text(tag.budgetAmount.toString(),
                style: Theme.of(context).textTheme.bodyText1),
            Container(
              padding: const EdgeInsets.fromLTRB(0, 8, 0, 0),
              child: Text(tag.utilizedAmount.toString(),
                style: Theme.of(context).textTheme.subtitle1,
              ),
            ),
            Container(
              padding: const EdgeInsets.fromLTRB(0, 8, 0, 0),
              child: Text(tag.balance.toString(),
                style: Theme.of(context).textTheme.subtitle1,
              ),
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
                onChanged: (String newValue) {
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
                  onChanged: (String newValue) {
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
