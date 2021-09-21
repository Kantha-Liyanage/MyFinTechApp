import 'chat_message.dart';

class Transaction {
  final int id;
  final String account;
  final List<String> tags;
  final double amount;
  final String date;

  Transaction(this.id, this.account, this.tags, this.amount, this.date);

  static Transaction createTransaction(ChatMessage message) {
    return Transaction(0,'', [], 0.0, '');
  }
}
