import 'package:flutter/cupertino.dart';
import 'package:my_fintech_app/models/account.dart';
import 'package:my_fintech_app/models/tag.dart';

class Transaction {
  String account = '';
  String tag = '';
  double amount = 0.0;
  String date = '';

  static bool isAnAttemptedTransaction(String text) {
    RegExp exp = RegExp(r"[@|#|+|&]");
    return exp.allMatches(text).length > 0;
  }

  static Transaction createTransaction(
      String text, List<Account> accounts, List<Tag> tags) {
    Transaction t = Transaction();

    //Account
    if (_getCountOf('@', text) != 1) {
      throw ErrorDescription('Account not given!');
    }

    //Category
    if (_getCountOf('#', text) != 1) {
      throw ErrorDescription('Category not given!');
    }

    //Amount
    if (_getCountOf('+', text) != 1) {
      throw ErrorDescription('Amount not given!');
    }

    //Account
    t.account = text.substring(1, text.indexOf('#'));

    Iterable<Account> resultAccount = accounts
        .where((acc) => acc.name.toLowerCase() == t.account.toLowerCase());

    if (resultAccount.length != 1) {
      throw ErrorDescription('Account not found!');
    }

    //Category
    t.tag = text.substring(text.indexOf('#') + 1, text.indexOf('+'));

    Iterable<Tag> resultTag =
        tags.where((tag) => tag.name.toLowerCase() == t.tag.toLowerCase());

    if (resultTag.length != 1) {
      throw ErrorDescription('Category not found!');
    }

    //Amount
    bool dateGiven = text.contains('&');
    double amount = 0.0;
    try {
      if (dateGiven) {
        amount = double.parse(
            text.substring(text.indexOf('+') + 1, text.indexOf('&')));
      } else {
        amount = double.parse(text.substring(text.indexOf('+') + 1));
      }
    } catch (e) {
      amount = 0.0;
    }
    t.amount = amount;

    if (t.amount <= 0) {
      throw ErrorDescription('Amount is invalid!');
    }

    //Date
    if (_getCountOf('&', text) > 1) {
      throw ErrorDescription('Date given is invalid!');
    }

    if (dateGiven) {
      t.date = text.substring(text.indexOf('&') + 1);
    } else {
      t.date = 'Today';
    }

    return t;
  }

  static int _getCountOf(String search, String text) {
    RegExp exp = RegExp(r"[" + search + "]");
    return exp.allMatches(text).length;
  }
}
