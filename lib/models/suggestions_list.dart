import 'suggestion.dart';

class SuggestionsList {
  List<Suggestion> _items = <Suggestion>[
    Suggestion('', ''),
    Suggestion('', ''),
    Suggestion('', ''),
  ];

  List<Suggestion> get items => _items;

  void clearAll() {
    _items = <Suggestion>[
    Suggestion('', ''),
    Suggestion('', ''),
    Suggestion('', ''),
  ];
  }
}
