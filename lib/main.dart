import 'package:flutter/material.dart';
import 'package:my_fintech_app/models/tags_list.dart';
import 'package:provider/provider.dart';
import 'models/accounts_list.dart';
import 'screens/home/home_screen.dart';

void main() => runApp(
  MultiProvider(
    providers: [
      ChangeNotifierProvider(create: (context) => AccountsList()),
      ChangeNotifierProvider(create: (context) => TagsList()),
    ],
    child: const MyApp(),
  ),
);

/// This is the main application widget.
class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  static const String _title = 'FinChat';

  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      title: _title,
      home: HomeScreen(),
    );
  }
}
