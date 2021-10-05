import 'package:flutter/foundation.dart';
import 'package:my_fintech_app/models/budget_category.dart';
import 'package:my_fintech_app/services/budget_category_service.dart';

class BudgetCategoriesList extends ChangeNotifier {
  List<BudgetCategory> _items = <BudgetCategory>[];

  BudgetCategoriesList() {
    _getRemoteData();
  }

  List<BudgetCategory> get items => _items;

  void add(BudgetCategory item) {
    _items.add(item);
    notifyListeners();
  }

  void remove(BudgetCategory item) {
    _items.remove(item);
    notifyListeners();
  }

  Future<void> _getRemoteData() async {
    try {
      _items = await BudgetCategoryService().fetchBudgetCategories();
    } catch (e) {}
  }
}
