import 'package:flutter/foundation.dart';
import 'package:my_fintech_app/models/account.dart';
import 'package:my_fintech_app/services/account_service.dart';

class AccountsList extends ChangeNotifier {
  
  List<Account> _items = <Account>[];

  AccountsList() {
    _getRemoteData();
  }

  List<Account> get items => _items;

  void add(Account item) {
    _items.add(item);
    notifyListeners();
  }

  void remove(Account item) {
    _items.remove(item);
    notifyListeners();
  }

  Future<void> _getRemoteData() async {
    try {
      _items = await AccountService().fetchAccounts();
    } catch (e) {}
  }
}
