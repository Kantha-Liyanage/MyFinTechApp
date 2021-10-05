import 'package:flutter/foundation.dart';
import 'package:my_fintech_app/models/budget_category.dart';

class BudgetCategoriesList extends ChangeNotifier {

  final List<BudgetCategory> _items = <BudgetCategory>[
    BudgetCategory('Grocery', BudgetCategoryType.expense,  0, 0),
    BudgetCategory('UtilityBills/Phone', BudgetCategoryType.expense, 0, 0),
    BudgetCategory('Entertainment', BudgetCategoryType.expense, 0, 0),
    BudgetCategory('Salary', BudgetCategoryType.income, 0, 0),
  ];
  
  List<BudgetCategory> get items => _items;

  void add(BudgetCategory item) {
    _items.add(item);
    notifyListeners();
  }

  void remove(BudgetCategory item) {
    _items.remove(item);
    notifyListeners();
  }

}
