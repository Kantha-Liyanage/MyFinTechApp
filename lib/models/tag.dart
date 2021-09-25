class Tag {
  String name;
  double budgetAmount;
  double utilizedAmount;

  Tag(this.name, this.budgetAmount, this.utilizedAmount);

  double getBalance() {
    return budgetAmount - utilizedAmount;
  }
}
