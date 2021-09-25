import 'package:flutter/material.dart';
import 'package:my_fintech_app/models/tag.dart';
import 'package:my_fintech_app/widgets/budget_box.dart';
import 'package:my_fintech_app/widgets/tab_title.dart';

class BudgetScreen extends StatefulWidget {
  const BudgetScreen({Key? key}) : super(key: key);

  @override
  _BudgetScreenState createState() => _BudgetScreenState();
}

class _BudgetScreenState extends State<BudgetScreen> {
  List<Tag> tags = <Tag>[
    Tag('#Grocery', 22500, 1200.0),
    Tag('#Bills#Telecom', 8000, 5000),
    Tag('#Entertainment', 2000, 500),
    Tag('#Meals', 5000, 2000)
  ];

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        TabTitle('Monthly Budget'),
        Expanded(
          flex: 1,
          child: Padding(
            padding: const EdgeInsets.all(8),
            child: ListView.separated(
              padding: const EdgeInsets.all(8),
              itemCount: tags.length,
              itemBuilder: (BuildContext context, int index) {
                return BudgetBox(tags[index]);
              }, 
              separatorBuilder: (BuildContext context, int index) {
                return const Divider(
                  color: Colors.blue,
                );
              },
            )
          )
        ),
      ],
    );
  }
}
