import 'dart:convert';
import 'package:my_fintech_app/models/account.dart';
import 'package:my_fintech_app/services/http_service.dart';

class AccountService extends HTTPSerivce {
  Future<List<Account>> fetchAll() async {
    final response = await authenticatedHttpGet('accounts');

    if (response.statusCode == 200) {
      var listObj = List.from(jsonDecode(response.body)['accounts']);
      List<Account> list = [];
      for (int i = 0; i < listObj.length; i++) {
        Account acc = Account(
            listObj[i]['id'],
            listObj[i]['name'].toString(),
            ((listObj[i]['accountType'] == 'asset')
                ? AccountType.asset
                : AccountType.liability),
            double.parse(listObj[i]['currentBalance']));
        list.add(acc);
      }
      return list;
    } else {
      // If the server did not return a 200 OK response,
      // then throw an exception.
      throw Exception('Failed to load accounts.');
    }
  }

  Future<bool> create(Account account) async {
    var data = {
      "name" : account.name,
      "accountType": (account.accountType == AccountType.asset) ? 'asset' : 'liability',
      "currentBalance":account.currentBalance.toString()
    };

    final response = await authenticatedHttpPost('accounts', account);
    if (response.statusCode == 200) {
      return true;
    }
    return false;
  }

  Future<bool> update(Account account) async {
    var data = {
      "id": account.id.toString(),
      "name" : account.name,
      "accountType": (account.accountType == AccountType.asset) ? 'asset' : 'liability',
      "currentBalance":account.currentBalance.toString()
    };

    final response = await authenticatedHttpPatch('accounts', data);
    if (response.statusCode == 200) {
      return true;
    }
    return false;
  }

  Future<bool> delete(int id) async {
    var data = {
      "id": id.toString()
    };

    final response = await authenticatedHttpDelete('accounts', data);
    if (response.statusCode == 200) {
      return true;
    }
    return false;
  }
}
