import 'package:flutter/material.dart';
import 'package:my_fintech_app/models/budget_category.dart';
import 'package:provider/provider.dart';

class BudgetListItem extends StatelessWidget {
  const BudgetListItem({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    BudgetCategory tag = Provider.of<BudgetCategory>(context, listen: true);

    return GestureDetector(
      child:
          (tag.editable ? buildEditableWidget(context, tag) : buildViewOnlyWidget(context, tag)),
      onLongPress: () {
        toggleEditMode(tag);
      },
    );
  }

  toggleEditMode(BudgetCategory tag) {
    tag.editable = !tag.editable;
  }

  buildViewOnlyWidget(BuildContext context, BudgetCategory tag) {
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
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start, 
              children: [
                Text(tag.name, 
                  style: Theme.of(context).textTheme.caption),
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
                  style: Theme.of(context).textTheme.caption),
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
      )
    );
  }

  buildEditableWidget(BuildContext context, BudgetCategory tag) {
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
                style: Theme.of(context).textTheme.bodyText1,
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
                  style: Theme.of(context).textTheme.bodyText1,
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
