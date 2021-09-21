class Account {
  String name;
  int accountType;
  final String createdDate;
  final String createdTime;

  Account(this.name, this.accountType, this.createdDate, this.createdTime);
}

class AccountTypes {
  static const CASH = 0;
  static const CREDIT = 1;
}
