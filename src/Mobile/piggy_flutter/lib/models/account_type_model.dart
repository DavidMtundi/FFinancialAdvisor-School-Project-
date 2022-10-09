class AccountType {
  final String? name;
  final String? id;

  AccountType(this.name, this.id);

  AccountType.fromJson(Map<String, dynamic> json)
      : id = json['id'],
        name = json['name'];

  // AccountType.fromListJson(List<Map<String,dynamic>> json){
  //   var result = List<AccountType>.empty();
  //   for(Map<String,dynamic> value in json){
  //     result.add(AccountType.fromJson(value));
  //   }
  //   return result;
  // }
}
