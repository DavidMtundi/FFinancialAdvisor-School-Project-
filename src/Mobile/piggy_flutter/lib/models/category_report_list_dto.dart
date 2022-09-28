class CategoryReportListDto {
  CategoryReportListDto({
    this.accountName,
    this.amountInDefaultCurrency,
    this.amount,
    this.categoryIcon,
    this.categoryName,
    this.currencyCode,
  });

  CategoryReportListDto.fromJson(Map<String, dynamic> json)
      : accountName = json['accountName'],
        amount = json['amount'],
        amountInDefaultCurrency = json['amountInDefaultCurrency'],
        categoryIcon = json['categoryIcon'],
        categoryName = json['categoryName'],
        currencyCode = json['currencyCode'];
        
  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['accountName'] = this.accountName;
    data['amountInDefaultCurrency'] = this.amountInDefaultCurrency;
    data['amount'] = this.amount;
    data['categoryIcon'] = this.categoryIcon;
    data['categoryName'] = this.categoryName;
    data['currencyCode'] = this.currencyCode;
    return data;
  }

  final String? accountName, categoryIcon, categoryName, currencyCode;
  final double? amount, amountInDefaultCurrency;
}
