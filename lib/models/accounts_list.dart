import 'package:flutter/foundation.dart';
import 'package:my_fintech_app/models/account.dart';

class AccountsList extends ChangeNotifier {

  final List<Account> _items = <Account>[
    Account('Cash', AccountType.asset, 12500.00),
    Account('SYLN', AccountType.asset, 45000.00),
    Account('HSBC CC', AccountType.liability, 100000.00),
    Account('HNB CC', AccountType.liability, 100000.00),
    Account('SYLN CC', AccountType.liability, 500000.00)
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