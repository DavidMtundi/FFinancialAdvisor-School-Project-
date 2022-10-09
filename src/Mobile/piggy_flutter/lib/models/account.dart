class Account {
  Account(this.id, this.name, this.accountType, this.currencySymbol,
      this.currentBalance, this.currencyCode, this.isArchived);

  Account.fromJson(Map<String, dynamic> json)
      : id = json['id'],
        name = json['name'],
        accountType = json['accountTypeId'],
        currencySymbol = "Kshs",

        // currencySymbol = json['currency']['symbol'],
        currencyCode = (json['currencyId']).toString(),
        currentBalance = json['currentBalance'] ?? 0,
        isArchived = json['isArchived'];
  //  data['id'] = this.id;
  //   data['name'] = this.name;
  //   data['currencyId'] = this.currencyId;
  //   data['accountTypeId'] = this.accountTypeId;
  //   data['isArchived'] = this.isArchived;
  final String? id, name, accountType, currencySymbol, currencyCode;
  final double? currentBalance;
  final bool isArchived;

  @override
  String toString() {
    return '$name - ${currentBalance.toString()}';
  }
}
