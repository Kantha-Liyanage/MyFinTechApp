import 'dart:convert';
import 'package:my_fintech_app/models/budget_category.dart';
import 'package:my_fintech_app/services/http_service.dart';

class BudgetCategoryService extends HTTPSerivce {
  Future<List<BudgetCategory>> fetchAll() async {
    final response = await authenticatedHttpGet('categories');

    if (response.statusCode == 200) {
      var listObj = List.from(jsonDecode(response.body)['categories']);
      List<BudgetCategory> list = [];
      for (int i = 0; i < listObj.length; i++) {
        BudgetCategory acc = BudgetCategory(
            listObj[i]['id'],
            listObj[i]['name'].toString(),
            ((listObj[i]['budgetCategoryType'] == 'expense')
                ? BudgetCategoryType.expense
                : BudgetCategoryType.income),
            double.parse(listObj[i]['budgetAmount']),
            double.parse(listObj[i]['utilizedAmount']));
        list.add(acc);
      }
      return list;
    } else {
      // If the server did not return a 200 OK response,
      // then throw an exception.
      throw Exception('Failed to load accounts.');
    }
  }

  Future<bool> create(BudgetCategory category) async {
    var data = {
      "name" : category.name,
      "budgetCategoryType" : (category.budgetCategoryType == BudgetCategoryType.expense)? 'expense' : 'income',
      "budgetAmount" : category.budgetAmount.toString()
    };

    final response = await authenticatedHttpPost('categories', data);
    if (response.statusCode == 200) {
      return true;
    }
    return false;
  }

  Future<bool> update(BudgetCategory category) async {
    var data = {
      "id": category.id,
      "name" : category.name,
      "budgetCategoryType" : (category.budgetCategoryType == BudgetCategoryType.expense)? 'expense' : 'income',
      "budgetAmount" : category.budgetAmount.toString()
    };

    final response = await authenticatedHttpPatch('categories', data);
    if (response.statusCode == 200) {
      return true;
    }
    return false;
  }

  Future<bool> delete(int id) async {
    var data = {
      "id": id.toString()
    };

    final response = await authenticatedHttpDelete('categories', data);
    if (response.statusCode == 200) {
      return true;
    }
    return false;
  }
}
