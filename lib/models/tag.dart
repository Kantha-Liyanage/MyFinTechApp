import 'package:flutter/foundation.dart';

class Tag extends ChangeNotifier {
  String _name;
  double _budgetAmount;
  double _utilizedAmount;
  bool _editable = false;

  Tag(this._name, this._budgetAmount, this._utilizedAmount);

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
