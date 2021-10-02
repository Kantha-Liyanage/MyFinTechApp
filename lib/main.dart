import 'package:flutter/material.dart';
import 'package:my_fintech_app/models/chat_messages_list.dart';
import 'package:my_fintech_app/models/tags_list.dart';
import 'package:provider/provider.dart';
import 'models/accounts_list.dart';
import 'screens/home/home_screen.dart';

void main() => runApp(
      MultiProvider(
        providers: [
          ChangeNotifierProvider(create: (context) => AccountsList()),
          ChangeNotifierProvider(create: (context) => TagsList()),
          ChangeNotifierProvider(create: (context) => ChatMessagesList()),
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
    return MaterialApp(
      title: _title,
      theme: getTheme(),
      home: const HomeScreen(),
    );
  }

  ThemeData getTheme() {
    return ThemeData(
      // Define the default `TextTheme`. Use this to specify the default
      // text styling for headlines, titles, bodies of text, and more.
      textTheme: const TextTheme(
        headline1: TextStyle(fontSize: 18.0, fontWeight: FontWeight.bold, color: Colors.blue),
        caption: TextStyle(fontSize: 18.0, color: Colors.black),
        bodyText1: TextStyle(fontSize: 14.0),
        bodyText2: TextStyle(fontSize: 10.0, color: Colors.black38),
        subtitle1: TextStyle(fontSize: 12.0, color: Colors.black87),
      ),
    );
  }
}
