class Account {
  String name;
  AccountType accountType;
  final String createdDate;
  final String createdTime;

  Account(this.name, this.accountType, this.createdDate, this.createdTime);
}

enum AccountType { DEBIT, CREDIT }
