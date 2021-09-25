class Account {
  String name;
  AccountType accountType;
  double currentBalance;
  String createdDate;
  String createdTime;

  Account(this.name, this.accountType, this.currentBalance, this.createdDate, this.createdTime);
}

class AccountTypeWithDescription {
  String name;
  AccountType accountType;

  AccountTypeWithDescription(this.name, this.accountType);

  static List<AccountTypeWithDescription> getAll() {
    List<AccountTypeWithDescription> list = <AccountTypeWithDescription>[
      AccountTypeWithDescription('Asset', AccountType.Asset),
      AccountTypeWithDescription('Liability', AccountType.Liability),
    ];
    return list;
  }

  static AccountTypeWithDescription get(AccountType accountType) {
    return AccountTypeWithDescription.getAll()
        .firstWhere((element) => element.accountType == accountType);
  }
}

enum AccountType { Asset, Liability }
