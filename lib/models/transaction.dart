import 'account.dart';
import 'tag.dart';

class Transaction {
  final String account;
  final String tag;
  final double amount;
  final String date;
  final String time;

  Transaction(this.account, this.tag, this.amount, this.date, this.time);

  static List<Transaction> createTransactions(String text, List<Account> accounts, List<Tag> tags){
    return [];
  }
}
