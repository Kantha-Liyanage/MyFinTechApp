import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '/models/tags_list.dart';
import '/widgets/tab_title.dart';
import 'budget_list_item.dart';

class BudgetScreen extends StatelessWidget {
  const BudgetScreen({Key? key}) : super(key: key);
 
  @override
  Widget build(BuildContext context) {
    TagsList tags = Provider.of<TagsList>(context, listen: true);

    return Column(
      children: [
        const TabTitle('Monthly Budget'),
        Expanded(
          flex: 1,
          child: Padding(
            padding: const EdgeInsets.all(8),
            child: ListView.separated(
              padding: const EdgeInsets.all(8),
              itemCount: tags.items.length,
              itemBuilder: (BuildContext context, int index) {
                return ChangeNotifierProvider.value(
                  value: tags.items[index],
                  child: const BudgetListItem(),
                ); 
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
