class TransactionModel {
  TransactionModel(
      {this.id,
      this.balance,
      this.categoryName,
      this.categoryIcon,
      this.description,
      this.creatorUserName,
      this.accountName,
      // this.accountCurrencySymbol,
      this.amount,
      this.transactionTime,
      this.amountInDefaultCurrency});

  TransactionModel.fromJson(Map<String, dynamic> json)
      : id = json['id'],
        balance = json['balance'] ?? 00,
        categoryName = json['category']['name'],
        categoryIcon = json['category']['icon'],
        description = json['description'],
        creatorUserName = json['creatorUserName'] ?? "n",
        accountName = json['account']['name'],
        // accountCurrencySymbol = json['account']['currency']['symbol'],
        transactionTime = json['transactionTime'],
        amount = json['amount'],
        amountInDefaultCurrency = json['amount'];
  toMap() {
    Map<String, dynamic> returnthis = new Map<String, dynamic>();
    returnthis['id'] = this.id;
    returnthis['balance'] = this.balance;
    returnthis['categoryName'] = this.categoryName;
    returnthis['categoryIcon'] = this.categoryIcon;
    returnthis['description'] = this.description;
    returnthis['creatorUserName'] = this.creatorUserName;
    returnthis['accountName'] = this.accountName;
    returnthis['amount'] = this.amount;
    returnthis['transactionTime'] = this.transactionTime;
    returnthis['amountInDefaultCurrency'] = this.amountInDefaultCurrency;
  }

  final String? id,
      categoryName,
      categoryIcon,
      description,
      creatorUserName,
      accountName,
      transactionTime;
  //  accountCurrencySymbol;
  final double? amount, amountInDefaultCurrency, balance;
}
