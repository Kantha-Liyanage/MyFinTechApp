import 'package:flutter/foundation.dart';

class Account extends ChangeNotifier {
  String _name;
  AccountType _accountType;
  double _currentBalance;
  bool _editable = false;

  Account(this._name, this._accountType, this._currentBalance);

  String get name => _name;
  set name(String name) {
    _name = name;
    notifyListeners();
  }

  AccountType get accountType => _accountType;
  set accountType(AccountType accountType) {
    _accountType = accountType;
    notifyListeners();
  }

  double get currentBalance => _currentBalance;
  set currentBalance(double currentBalance) {
    _currentBalance = currentBalance;
    notifyListeners();
  }

  bool get editable => _editable;
  set editable(bool editable) {
    _editable = editable;
    notifyListeners();
  }
}

class AccountTypeWithDescription {
  String name;
  AccountType accountType;

  AccountTypeWithDescription(this.name, this.accountType);

  static List<AccountTypeWithDescription> getAll() {
    List<AccountTypeWithDescription> list = <AccountTypeWithDescription>[
      AccountTypeWithDescription('Asset', AccountType.asset),
      AccountTypeWithDescription('Liability', AccountType.liability),
    ];
    return list;
  }

  static AccountTypeWithDescription get(AccountType accountType) {
    return AccountTypeWithDescription.getAll()
        .firstWhere((element) => element.accountType == accountType);
  }
}

enum AccountType { asset, liability }
