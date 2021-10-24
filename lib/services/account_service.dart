import 'dart:convert';
import 'package:my_fintech_app/models/account.dart';
import 'package:my_fintech_app/services/http_service.dart';

import 'connectivity_service.dart';
import 'database_service.dart';

class AccountService extends HTTPSerivce {
  Future<List<Account>> fetchAll() async {
    List<Account> list = [];
    //Online?
    if (ConnectivityService.isConnected()) {
      final response = await authenticatedHttpGet('accounts');
      //OK
      if (response.statusCode == 200) {
        var listObj = List.from(jsonDecode(response.body)['accounts']);
        for (int i = 0; i < listObj.length; i++) {
          Account acc = Account(
              listObj[i]['id'],
              listObj[i]['name'].toString(),
              ((listObj[i]['accountType'] == 'asset')
                  ? AccountType.asset
                  : AccountType.liability),
              double.parse(listObj[i]['currentBalance']),
              false);
          list.add(acc);
        }
      } else {
        throw Exception('Failed to load accounts.');
      }
    }

    if (list.length == 0) {
      //Offline
      list = await DatabaseSerivce.getAccounts();
      return list;
    } else {
      throw Exception('Failed to load accounts.');
    }
  }

  Future<bool> create(Account account) async {
    //Save offline and get ID
    await DatabaseSerivce.createAccount(account);

    //Online?
    if (ConnectivityService.isConnected()) {
      var data = {
        "id": account.id.toString(),
        "name": account.name,
        "accountType":
            (account.accountType == AccountType.asset) ? 'asset' : 'liability',
        "currentBalance": account.currentBalance.toString()
      };

      //online
      final response = await authenticatedHttpPost('accounts', data);
      if (response.statusCode == 200) {
        account.offline = false;
        return true;
      } else {
        return false;
      }
    } else {
      return true;
    }
  }

  Future<bool> update(Account account) async {
    //Save offline
    await DatabaseSerivce.updateAccount(account);

    //Online?
    if (ConnectivityService.isConnected()) {
      var data = {
        "id": account.id.toString(),
        "name": account.name,
        "accountType":
            (account.accountType == AccountType.asset) ? 'asset' : 'liability',
        "currentBalance": account.currentBalance.toString()
      };

      final response = await authenticatedHttpPatch('accounts', data);
      if (response.statusCode == 200) {
        return true;
      } else {
        return false;
      }
    } else {
      return true;
    }
  }

  Future<bool> delete(int id) async {
    var data = {"id": id.toString()};

    final response = await authenticatedHttpDelete('accounts', data);
    if (response.statusCode == 200) {
      return true;
    }
    return false;
  }
}
