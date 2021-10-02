import 'package:flutter/foundation.dart';
import 'tag.dart';

class TagsList extends ChangeNotifier {

  final List<Tag> _items = <Tag>[
    Tag('Grocery', 0, 0),
    Tag('UtilityBills/Phone', 0, 0),
    Tag('Entertainment', 0, 0),
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
