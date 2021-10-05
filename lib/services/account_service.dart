import 'dart:convert';
import 'package:my_fintech_app/models/account.dart';
import 'package:my_fintech_app/services/http_service.dart';

class AccountService extends HTTPSerivce {
 
  Future<List<Account>> fetchAccounts() async {
    final response = await authenticatedHttpGet('accounts');

    if (response.statusCode == 200) {
      var listObj = List.from(jsonDecode(response.body)['accounts']);
      List<Account> list = [];
      for (int i = 0; i < listObj.length; i++) {
        Account acc = Account(
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
}
