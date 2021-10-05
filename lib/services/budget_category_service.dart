import 'dart:convert';
import 'package:my_fintech_app/models/budget_category.dart';
import 'package:my_fintech_app/services/http_service.dart';

class BudgetCategoryService extends HTTPSerivce{
  
  Future<List<BudgetCategory>> fetchBudgetCategories() async {
    final response = await authenticatedHttpGet('categories');

    if (response.statusCode == 200) {
      var listObj = List.from(jsonDecode(response.body)['categories']);
      List<BudgetCategory> list = [];
      for(int i=0;i<listObj.length;i++){
        BudgetCategory acc = BudgetCategory(
          listObj[i]['name'].toString(), 
          ((listObj[i]['budgetCategoryType']=='expense')?BudgetCategoryType.expense : BudgetCategoryType.income), 
          double.parse(listObj[i]['budgetAmount']),
          double.parse(listObj[i]['utilizedAmount'])
        );
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
