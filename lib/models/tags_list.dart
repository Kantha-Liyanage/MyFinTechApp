import 'package:flutter/foundation.dart';
import 'package:my_fintech_app/models/tag.dart';

class TagsList extends ChangeNotifier {

  final List<Tag> _items = <Tag>[
    Tag('#Grocery', 22500, 1200.0),
    Tag('#Bills#Telecom', 8000, 5000),
    Tag('#Entertainment', 2000, 500),
    Tag('#Meals', 5000, 2000)
  ];
  
  List<Tag> get items => _items;

  void add(Tag item) {
    _items.add(item);
    notifyListeners();
  }

  void remove(Tag item) {
    _items.remove(item);
    notifyListeners();
  }

}
