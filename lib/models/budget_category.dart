import 'package:flutter/foundation.dart';

class BudgetCategory extends ChangeNotifier {
  String _name;
  BudgetCategoryType budgetCategoryType;
  double _budgetAmount;
  double _utilizedAmount;
  bool _editable = false;

  BudgetCategory(this._name, this.budgetCategoryType, this._budgetAmount, this._utilizedAmount);

  String get name => _name;
  set name(String name) {
    _name = name;
    notifyListeners();
  }

  double get balance => (_budgetAmount - _utilizedAmount);

  double get budgetAmount => _budgetAmount;
  set budgetAmount(double currentBalance) {
    _budgetAmount = currentBalance;
    notifyListeners();
  }

  double get utilizedAmount => _utilizedAmount;
  set utilizedAmount(double currentBalance) {
    _utilizedAmount = currentBalance;
    notifyListeners();
  }

  bool get editable => _editable;
  set editable(bool editable) {
    _editable = editable;
    notifyListeners();
  }
}

class BudgetCategoryTypeWithDescription {
  String name;
  BudgetCategoryType budgetCategoryType;

  BudgetCategoryTypeWithDescription(this.name, this.budgetCategoryType);

  static List<BudgetCategoryTypeWithDescription> getAll() {
    List<BudgetCategoryTypeWithDescription> list = <BudgetCategoryTypeWithDescription>[
      BudgetCategoryTypeWithDescription('Income', BudgetCategoryType.income),
      BudgetCategoryTypeWithDescription('Expense', BudgetCategoryType.expense),
    ];
    return list;
  }

  static BudgetCategoryTypeWithDescription get(BudgetCategoryType budgetCategoryType) {
    return BudgetCategoryTypeWithDescription.getAll()
        .firstWhere((element) => element.budgetCategoryType == budgetCategoryType);
  }
}

enum BudgetCategoryType { income, expense }
