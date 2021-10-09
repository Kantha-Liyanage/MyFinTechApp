import 'package:flutter/material.dart';
import 'package:my_fintech_app/models/accounts_list.dart';
import 'package:my_fintech_app/models/chat_messages_list.dart';
import 'package:my_fintech_app/models/budget_categories_list.dart';
import 'package:my_fintech_app/models/user.dart';
import 'package:my_fintech_app/screens/home/home_screen.dart';
import 'package:my_fintech_app/screens/home/intro_logon_screen.dart';
import 'package:my_fintech_app/services/connectivity_service.dart';
import 'package:provider/provider.dart';
import 'dart:async';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  bool loggedIn = await User.isLoggedIn();

  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (context) => AccountsList()),
        ChangeNotifierProvider(create: (context) => BudgetCategoriesList()),
        ChangeNotifierProvider(create: (context) => ChatMessagesList()),
        ChangeNotifierProvider(create: (context) => ConnectivityService()),
      ],
      child: MyApp(loggedIn),
    ),
  );
}

/// This is the main application widget.
class MyApp extends StatelessWidget {
  bool loggedIn;

  MyApp(this.loggedIn, {Key? key}) : super(key: key);

  static const String _title = 'FinChat';

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: _title,
      theme: getTheme(),
        home: loggedIn ? const HomeScreen() : const IntroLogonScreen(),
    );
  }

  ThemeData getTheme() {
    return ThemeData(
      // Define the default `TextTheme`. Use this to specify the default
      // text styling for headlines, titles, bodies of text, and more.
      textTheme: const TextTheme(
        headline1: TextStyle(
            fontSize: 18.0, fontWeight: FontWeight.bold, color: Colors.blue),
        headline2: TextStyle(
            fontSize: 48.0, fontWeight: FontWeight.bold, color: Colors.blue),
        caption: TextStyle(fontSize: 18.0, color: Colors.black),
        bodyText1: TextStyle(fontSize: 14.0),
        bodyText2: TextStyle(fontSize: 14.0, color: Colors.black38),
        subtitle1: TextStyle(fontSize: 14.0, color: Colors.black),
      ),
    );
  }
}
