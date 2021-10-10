import 'package:flutter/material.dart';
import 'package:my_fintech_app/models/budget_categories_list.dart';
import 'package:my_fintech_app/screens/budget/category_list_item.dart';
import 'package:my_fintech_app/widgets/tab_title.dart';
import 'package:provider/provider.dart';

class CategoryScreen extends StatelessWidget {
  const CategoryScreen({Key? key}) : super(key: key);
 
  @override
  Widget build(BuildContext context) {
    BudgetCategoriesList tags = Provider.of<BudgetCategoriesList>(context, listen: true);

    return Column(
      children: [
        const TabTitle('Categories'),
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
                  child: const CategoryListItem(),
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
