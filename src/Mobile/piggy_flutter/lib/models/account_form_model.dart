class AccountFormModel {
  AccountFormModel(
      {required this.id,
      required this.isArchived,
      this.name,
      this.currencyId,
      this.accountTypeId});

  AccountFormModel.fromJson(Map<String, dynamic> json)
      : id = json['id'],
        name = json['name'],
        currencyId = json['currencyId'],
        accountTypeId = json['accountTypeId'],
        isArchived = json['isArchived'];

  String? id;
  String? name;
  int? currencyId;
  String? accountTypeId;
  bool isArchived;
  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['name'] = this.name;
    data['currencyId'] = this.currencyId;
    data['accountTypeId'] = this.accountTypeId;
    data['isArchived'] = this.isArchived;
    return data;
  }

  @override
  String toString() {
    return 'AccountFormModel name $name id $id currencyId $currencyId accountTypeId $accountTypeId';
  }
}
