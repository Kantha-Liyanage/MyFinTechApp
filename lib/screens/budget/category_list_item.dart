import 'package:flutter/material.dart';
import 'package:my_fintech_app/models/budget_categories_list.dart';
import 'package:my_fintech_app/models/budget_category.dart';
import 'package:my_fintech_app/services/budget_category_service.dart';
import 'package:my_fintech_app/widgets/popup_confirmation.dart';
import 'package:provider/provider.dart';

class CategoryListItem extends StatefulWidget {
  const CategoryListItem({Key? key}) : super(key: key);

  @override
  State<CategoryListItem> createState() => _CategoryListItemState();
}

class _CategoryListItemState extends State<CategoryListItem> {
  late String tmpName;
  late double tmpBudgetAmount;
  late BudgetCategoryType tmpbudgetCategoryType;
  late TextEditingController textEditingControllerName;
  late TextEditingController textEditingControllerAmount;
  late BudgetCategory tag;
  late BudgetCategoriesList tags;

  @override
  Widget build(BuildContext context) {
    tag = Provider.of<BudgetCategory>(context, listen: true);
    tags = Provider.of<BudgetCategoriesList>(context, listen: true);

    return GestureDetector(
      child: (tag.editable
          ? _buildEditableWidget(context)
          : _buildViewOnlyWidget(context)),
      onLongPress: () {
        _toggleEditMode(tag);
      },
    );
  }

  _toggleEditMode(BudgetCategory tag) {
    tag.editable = !tag.editable;
    tmpName = tag.name;
    tmpBudgetAmount = tag.budgetAmount;
    tmpbudgetCategoryType = tag.budgetCategoryType;
    textEditingControllerName = TextEditingController(text: tmpName);
    textEditingControllerAmount =
        TextEditingController(text: tmpBudgetAmount.toString());
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
                controller: textEditingControllerName,
                style: Theme.of(context).textTheme.bodyText1,
                decoration: const InputDecoration(
                    border: UnderlineInputBorder(), labelText: 'Category'),
                onChanged: (String newValue) {
                  if (newValue.trim() != '') {
                    setState(() {
                      tmpName = newValue;
                    });
                  }
                },
              ),
            ),
            Expanded(
              flex: 1,
              child: DropdownButton<BudgetCategoryType>(
                value: tmpbudgetCategoryType,
                icon: const Icon(Icons.keyboard_arrow_down_sharp),
                iconSize: 24,
                elevation: 16,
                style: Theme.of(context).textTheme.bodyText1,
                onChanged: (BudgetCategoryType? newValue) {
                  if (newValue != Null) {
                    setState(() {
                      tmpbudgetCategoryType = newValue!;
                    });
                  }
                },
                items: BudgetCategoryTypeWithDescription.getAll()
                    .map((BudgetCategoryTypeWithDescription value) {
                  return DropdownMenuItem<BudgetCategoryType>(
                    value: value.budgetCategoryType,
                    child: Text(value.name),
                  );
                }).toList(),
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
                  controller: textEditingControllerAmount,
                  keyboardType: TextInputType.number,
                  onChanged: (String newValue) {
                    if (newValue.trim() != '') {
                      tmpBudgetAmount = double.parse(newValue);
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
                    tag.budgetCategoryType = tmpbudgetCategoryType;
                    tag.budgetAmount = tmpBudgetAmount;
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
                  PopupConfirmation(
                          'Are you sure you want to delete the selected Category?',
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
    BudgetCategoryService().delete(tag.id);
    tags.remove(tag);
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
            color: Colors.green.shade50,
            borderRadius: BorderRadius.circular(15)),
        child: Row(
          children: [
            Expanded(
              flex: 3,
              child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      BudgetCategoryTypeWithDescription.get(
                              tag.budgetCategoryType)
                          .name,
                      style: Theme.of(context).textTheme.subtitle1,
                    ),
                    Text(tag.name, style: Theme.of(context).textTheme.caption),
                    Container(
                      padding: const EdgeInsets.fromLTRB(0, 8, 0, 0),
                      child: Text(
                        'Utilized Amount',
                        style: Theme.of(context).textTheme.subtitle1,
                      ),
                    ),
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
              child:
                  Column(crossAxisAlignment: CrossAxisAlignment.end, children: [
                Text(
                  'Amount',
                  style: Theme.of(context).textTheme.subtitle1,
                ),
                Text(tag.budgetAmount.toString(),
                    style: Theme.of(context).textTheme.caption),
                Container(
                  padding: const EdgeInsets.fromLTRB(0, 8, 0, 0),
                  child: Text(
                    tag.utilizedAmount.toString(),
                    style: Theme.of(context).textTheme.subtitle1,
                  ),
                ),
                Container(
                  padding: const EdgeInsets.fromLTRB(0, 8, 0, 0),
                  child: Text(
                    tag.balance.toString(),
                    style: Theme.of(context).textTheme.subtitle1,
                  ),
                ),
              ]),
            ),
          ],
        ));
  }
}
