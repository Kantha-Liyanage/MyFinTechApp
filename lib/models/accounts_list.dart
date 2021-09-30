import 'package:flutter/foundation.dart';
import 'package:my_fintech_app/models/account.dart';

class AccountsList extends ChangeNotifier {

  final List<Account> _items = <Account>[
    Account('Cash', AccountType.Asset, 12500.00),
    Account('SYLN', AccountType.Asset, 45000.00),
    Account('HSBC CC', AccountType.Liability, 100000.00),
    Account('HNB CC', AccountType.Liability, 100000.00),
    Account('SYLN CC', AccountType.Liability, 500000.00)
  ];
  
  List<Account> get items => _items;

  void add(Account item) {
    _items.add(item);
    notifyListeners();
  }

  void remove(Account item) {
    _items.remove(item);
    notifyListeners();
  }

}
