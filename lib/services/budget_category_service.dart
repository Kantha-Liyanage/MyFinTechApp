import 'dart:convert';
import 'package:my_fintech_app/models/budget_category.dart';
import 'package:my_fintech_app/services/http_service.dart';

import 'connectivity_service.dart';
import 'database_service.dart';

class BudgetCategoryService extends HTTPSerivce {
  Future<List<BudgetCategory>> fetchAll() async {
    List<BudgetCategory> list = [];
    //Online?
    if (ConnectivityService.isConnected()) {
      final response = await authenticatedHttpGet('categories');

      if (response.statusCode == 200) {
        var listObj = List.from(jsonDecode(response.body)['categories']);
        for (int i = 0; i < listObj.length; i++) {
          BudgetCategory acc = BudgetCategory(
              listObj[i]['id'],
              listObj[i]['name'].toString(),
              ((listObj[i]['budgetCategoryType'] == 'expense')
                  ? BudgetCategoryType.expense
                  : BudgetCategoryType.income),
              double.parse(listObj[i]['budgetAmount']),
              double.parse(listObj[i]['utilizedAmount']),
              false);
          list.add(acc);
        }
      } else {
        // If the server did not return a 200 OK response,
        // then throw an exception.
        throw Exception('Failed to load categories.');
      }
    }

    if (list.length == 0) {
      //Offline
      List<BudgetCategory> list = await DatabaseSerivce.getCategories();
      return list;
    } else {
      // If the server did not return a 200 OK response,
      // then throw an exception.
      throw Exception('Failed to load categories.');
    }
  }

  Future<bool> create(BudgetCategory category) async {
    //Save offline and get ID
    await DatabaseSerivce.createCategory(category);

    //online
    if (ConnectivityService.isConnected()) {
      var data = {
        "id": category.id.toString(),
        "name": category.name,
        "budgetCategoryType":
            (category.budgetCategoryType == BudgetCategoryType.expense)
                ? 'expense'
                : 'income',
        "budgetAmount": category.budgetAmount.toString()
      };

      final response = await authenticatedHttpPost('categories', data);
      if (response.statusCode == 200) {
        category.offline = false;
        return true;
      } else {
        return false;
      }
    } else {
      return true;
    }
  }

  Future<bool> update(BudgetCategory category) async {
    //Save offline
    await DatabaseSerivce.updateCategory(category);

    //online
    if (ConnectivityService.isConnected()) {
      var data = {
        "id": category.id.toString(),
        "name": category.name,
        "budgetCategoryType":
            (category.budgetCategoryType == BudgetCategoryType.expense)
                ? 'expense'
                : 'income',
        "budgetAmount": category.budgetAmount.toString()
      };

      final response = await authenticatedHttpPatch('categories', data);
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

    final response = await authenticatedHttpDelete('categories', data);
    if (response.statusCode == 200) {
      return true;
    }
    return false;
  }
}
