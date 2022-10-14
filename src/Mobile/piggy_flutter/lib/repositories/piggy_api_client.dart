import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_sms_inbox/flutter_sms_inbox.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:piggy_flutter/models/models.dart';
import 'package:piggy_flutter/repositories/FirebaseMethods.dart';

class PiggyApiClient {
  PiggyApiClient();

  static const String baseUrl = 'https://piggyvault.abhith.net';

  // ACCOUNT
  Future<AccountFormModel?> getAccountForEdit(String? id) async {
    var result = await CRUDModel<AccountFormModel>("account").getById(id!);

    return AccountFormModel.fromJson(result);
  }

  // CATEGORY
  Future<bool> createOrUpdateCategory(Category input) async {
    // Map<String, dynamic> returnthis = new Map();
    try {
      input.id == null
          ? await CRUDModel("category").addProduct(input.toJson(), null, "id")
          : await CRUDModel("category")
              .updateProduct(input.toJson(), input.id.toString());
      return true;
    } catch (e) {
      return false;
    }
  }

  Future<IsTenantAvailableResult> isTenantAvailable(String tenancyName) async {
    final tenantUrl = '$baseUrl/api/services/app/Account/IsTenantAvailable';

    Map<String, dynamic> response = ({});

    return IsTenantAvailableResult.fromJson(response);
  }

  Future<AuthenticateResult> authenticate(
      {required String usernameOrEmailAddress,
      required String password}) async {
    late UserCredential credential;
    try {
      credential = await FirebaseAuth.instance.signInWithEmailAndPassword(
          email: usernameOrEmailAddress, password: password);
    } catch (e) {
      throw Exception("Please Check YOur email and password");
    }
    Map<String, dynamic> loginResult = ({
      "accessToken": credential.user!.uid,
      "encryptedAccessToken": credential.user!.uid,
      "expireInSeconds": 100000,
      "userId": credential.user!.uid
    });
    // final loginUrl = '$baseUrl/api/TokenAuth/Authenticate';
    // final loginResult = await this.postAsync<dynamic>(loginUrl, {
    //   "usernameOrEmailAddress": usernameOrEmailAddress,
    //   "password": password,
    //   "rememberClient": true
    // });

    // if (loginResult.success!) {
    //   throw Exception(loginResult.error);
    // }
    return AuthenticateResult.fromJson(loginResult);
    //return AuthenticateResult.fromJson(loginResult.result);
  }

  Future<LoginInformationResult?> getCurrentLoginInformations() async {
    // const String userUrl =
    //     '$baseUrl/api/services/app/session/GetCurrentLoginInformations';
    // final ApiResponse<dynamic> response = await getAsync<dynamic>(userUrl);
    var response = await FirebaseAuth.instance.currentUser;
    if (response != null) {
      Map<String, dynamic> result = ({
        "id": response.uid,
        "name": response.displayName ?? response.email!.substring(0, 6),
        "surname": response.displayName ?? response.email!.substring(0, 6),
        "userName": response.displayName ?? response.email!.substring(0, 6),
        "emailAddress": response.email,
        "profilePictureId": response.photoURL
      });
      Map<String, dynamic> tenantResult = ({
        "id": response.uid,
        "name": response.displayName ?? response.email!.substring(0, 6),
        "tenancyName": response.displayName ?? response.email!.substring(0, 6),
      });
      // if (response != null) {
      return LoginInformationResult(
          user: UserModel.fromJson(result),
          tenant: Tenant.fromJson(tenantResult));
    }

    return null;
  }

//get transaction
  Future<TransactionSummary> getTransactionSummary(String duration) async {
    // var ans = TransactionSummary(
    //     20000, 200, 121210, 23289, 9999, 9992, 232230, 23232, "12", "Kshs", 10);
    var id = FirebaseAuth.instance.currentUser!.uid;
    var data = await CRUDModel("allaccounts").getById(id);

    return TransactionSummary.fromJson(data);
  }

  Future<TenantAccountsResult> getTenantAccounts() async {
    List<Account> userAccountItems = [];
    List<Account> familyAccountItems = [];

    // try {
    var resultdocs = await CRUDModel("account").fetch([]);
    for (var i in resultdocs) {
      userAccountItems.add(Account.fromJson(i));
    }
    print("here we go");
    print("successfully gotten all the docs");

    return TenantAccountsResult(
        familyAccounts: familyAccountItems, userAccounts: userAccountItems);
    // } catch (e) {
    //   return TenantAccountsResult(
    //       familyAccounts: familyAccountItems, userAccounts: userAccountItems);
    // }
  }

  Future<List<Category>> getTenantCategories() async {
    List<Category> tenantCategories = [];

    try {
      var resultdocs = await CRUDModel("category").fetch([]);
      for (var i in resultdocs) {
        tenantCategories.add(Category.fromJson(i));
      }
      print("here we go");

      return tenantCategories;
    } catch (e) {
      return tenantCategories;
    }
  }

//create or update a transaction
  Future<ApiResponse<dynamic>> createOrUpdateTransaction(
      TransactionEditDto input) async {
    Map<String, dynamic> returnthis = new Map<String, dynamic>();
    var id = FirebaseAuth.instance.currentUser!.uid;
    var data = new Map<String, dynamic>();
    double balance = 0;
    try {
      data = await CRUDModel("allaccounts").getById(id);

      if (data.isEmpty) {
        await CRUDModel("allaccounts").addProduct(
            ({
              "balance": 0,
              "tenantNetWorth": 0,
              "userNetWorth": 0,
              "tenantIncome": 0,
              "userIncome": 0,
              "tenantExpense": 0,
              "userExpense": 0,
              "tenantSaved": 0,
              "userSaved": 0,
              "netWorthPercentage": 100,
              "totalFamilyTransactionsCount": 0
            }),
            id,
            "id");
      }
      balance = data['balance'] ?? 0;
    } catch (e) {
      await CRUDModel("allaccounts").addProduct(
          ({
            "balance": 0,
            "tenantNetWorth": 0,
            "userNetWorth": 0,
            "tenantIncome": 0,
            "userIncome": 0,
            "tenantExpense": 0,
            "userExpense": 0,
            "tenantSaved": 0,
            "userSaved": 0,
            "netWorthPercentage": 0,
            "totalFamilyTransactionsCount": 0
          }),
          id,
          "id");
      balance = 0;
    }
    try {
      balance = input.amount! + balance;
      var tenantincome = data['tenantIncome'] ?? 0;
      var userincome = data["userIncome"] ?? 0;
      var tenantexpense = data['tenantExpense'] ?? 0;
      var userExpense = data['userExpense'] ?? 0;
      var totalFamilyTransactionsCount =
          data['totalFamilyTransactionsCount'] ?? 0;
      var userSaved = data['userSaved'] ?? 0;
      var tenantSaved = data['tenantSaved'] ?? 0;
      data["balance"] = balance;
      data["tenantNetWorth"] = balance;
      data["userNetWorth"] = balance;
      data["tenantIncome"] =
          input.amount! > 0 ? tenantincome + input.amount : tenantincome;
      data["userIncome"] =
          input.amount! > 0 ? userincome + input.amount : userincome;
      data["tenantExpense"] =
          input.amount! < 0 ? tenantexpense + input.amount : tenantexpense;
      data["userExpense"] =
          input.amount! < 0 ? userExpense + input.amount : userExpense;
      data["tenantSaved"] =
          tenantSaved + input.amount! > 0 ? tenantSaved + input.amount! : 0;
      data["userSaved"] =
          userSaved + input.amount! > 0 ? userSaved + input.amount! : 0;
      data["totalFamilyTransactionsCount"] = totalFamilyTransactionsCount + 1;
      data["netWorthPercentage"] = data["userIncome"] > 0 && data["balance"] > 0
          ? (data['balance'] / data['userIncome']) * 100
          : 0;
    } catch (e) {
      print(e);
    }

    var sendthis = input.toJson();

    sendthis['balance'] = balance;
    try {
      var thefirst = await CRUDModel("allaccounts").addProduct(data, id, "id");
      var result =
          await CRUDModel("transactions").addProduct(sendthis, input.id, "id");
      returnthis = ({
        "success": true,
        "result": "success",
        "unAuthorizedRequest": false,
      });
    } catch (e) {
      returnthis = ({
        "success": false,
        "result": "success",
        "unAuthorizedRequest": false,
      });
    }

    return ApiResponse.fromJson(returnthis);
  }

//transfer from one account to another
  Future<ApiResponse<dynamic>> transfer(TransferInput input) async {
    final result = ApiResponse(
        success: true,
        result: ({}),
        unAuthorizedRequest: false); // final result =
    //     await postAsync('$baseUrl/api/services/app/transaction/transfer', {
    //   "id": input.id,
    //   "description": input.description,
    //   "amount": input.amount,
    //   "toAmount": input.toAmount,
    //   "categoryId": input.categoryId,
    //   "accountId": input.accountId,
    //   "toAccountId": input.toAccountId,
    //   "transactionTime": input.transactionTime
    // });

    return result;
  }

  Future<List<TransactionModel>> getTransactions(
      GetTransactionsInput input) async {
    List<TransactionModel> transactions = [];

    String params = '';
    List<String> paramlist = [];

    if (input.type != null) {
      params += 'type=${input.type}';
      paramlist.add('"type",isEqualTo:"${input.type}"');
    }

    if (input.accountId != null) {
      params += '&accountId=${input.accountId}';
      paramlist.add('"accountId",isEqualTo:"${input.accountId}"');
    }

    if (input.categoryId != null) {
      params += '&categoryId=${input.categoryId}';
      paramlist.add('"categoryId",isEqualTo:"${input.categoryId}"');
    }

    if (input.startDate != null && input.startDate.toString() != '')
      params += '&startDate=${input.startDate}';
    paramlist.add('"startDate",isEqualTo:"${input.startDate}"');

    if (input.endDate != null && input.endDate.toString() != '')
      params += '&endDate=${input.endDate}';
    paramlist.add('"endDate",isEqualTo:"${input.endDate}"');

    final result = await CRUDModel("transactions").fetch([]);
    try {
      for (var i in result) {
        var category = await CRUDModel("category").getById(i['categoryId']);
        var account = await CRUDModel("account").getById(i['accountId']);
        i['category'] = category;
        i['account'] = account;
        transactions.add(TransactionModel.fromJson(i));
      }
      print("here we go");

      return transactions;
    } catch (e) {
      return transactions;
    }
    // return transactions;
  }

  Future<Account> getAccountDetails(String accountId) async {
    // var result = await getAsync<dynamic>(
    //     '$baseUrl/api/services/app/account/GetAccountDetails?id=$accountId');
    var result = await CRUDModel("account").getById(accountId);
    return Account.fromJson(result);
  }

  Future<ApiResponse<dynamic>> createOrUpdateAccount(
      AccountFormModel input) async {
    var returnthis = new Map<String, dynamic>();

    try {
      await CRUDModel("account").addProduct(input.toJson(), input.id, "id");
      returnthis = ({
        "success": true,
        "result": "success",
        "unAuthorizedRequest": false,
      });
    } catch (e) {
      returnthis = ({
        "success": false,
        "result": "success",
        "unAuthorizedRequest": false,
      });
    }

    return ApiResponse.fromJson(returnthis);
  }

  Future<List<AccountType>> getAccountTypes() async {
    List<AccountType> returnthis = [];
    try {
      var resultdocs = await CRUDModel("accounttype").fetch([]);
      for (var i in resultdocs) {
        returnthis.add(AccountType.fromJson(i));
      }
      print("here we go");

      return returnthis;
    } catch (e) {
      return returnthis;
    }
  }

  // Reports
  Future<List<CategoryWiseRecentMonthsReportItem>>
      getCategoryWiseTransactionSummaryHistory() async {
    List<CategoryWiseRecentMonthsReportItem> data = [];
    Map<String, dynamic> json = ({});
    Map<String, dynamic> first = ({});
    Map<String, dynamic> second = ({});
    Map<String, dynamic> third = ({});

    List<Map<String, dynamic>> firstdata = [];
    List<Map<String, dynamic>> seconddata = [];
    List<Map<String, dynamic>> thirddata = [];

    double totalfirst = 0;
    double totalsecondmonth = 0;
    double totalthirdmonth = 0;

    //get all transactions
    List<TransactionModel> alltransactions =
        await getTransactions(GetTransactionsInput());
    for (TransactionModel model in alltransactions) {
      int monthtotal =
          DateTime.now().month - DateTime.parse(model.transactionTime!).month;
      if (monthtotal < 1) {
        totalfirst += model.amount!;
        var value = ({'total': totalfirst});
        firstdata.add(value);
        first['categoryName'] = model.categoryName!;
      } else if ((monthtotal < 2)) {
        totalsecondmonth += model.amount!;
        var value = ({'total': totalsecondmonth});
        seconddata.add(value);
        second['categoryName'] = model.categoryName!;
      } else if ((monthtotal < 3)) {
        totalthirdmonth += model.amount!;
        var value = ({'total': totalthirdmonth});
        thirddata.add(value);
        third['categoryName'] = model.categoryName!;
      }
    }
    first['datasets'] = firstdata;
    second['datasets'] = seconddata;
    third['datasets'] = thirddata;

    data.add(CategoryWiseRecentMonthsReportItem.fromJson(first));
    data.add(CategoryWiseRecentMonthsReportItem.fromJson(second));

    data.add(CategoryWiseRecentMonthsReportItem.fromJson(third));

    //group by month

    return data;
  }

  Future<List<CategoryReportListDto>> getCategoryReport(
      GetCategoryReportInput input) async {
    final List<CategoryReportListDto> data = [];
    // final ApiResponse result = await getAsync<dynamic>(
    //     '$baseUrl/api/services/app/Report/GetCategoryReport?startDate=${input.startDate}&endDate=${input.endDate}');
    //
    // if (result.success!) {
    //   result.result['items']
    //       .forEach((item) => data.add(CategoryReportListDto.fromJson(item)));
    // }
    return data;
  }

  // Transaction
  Future<void> deleteTransaction(String id) async {}

  Future<void> createOrUpdateTransactionComment(
      String? transactionId, String content) async {
    try {
      var value = ({
        "id": transactionId,
        "transactionid": transactionId,
        "content": content
      });
      transactionId == null
          ? await CRUDModel("transactioncomment")
              .addProduct(value, transactionId, "id")
          : await CRUDModel("transactioncomment")
              .updateProduct(value, transactionId);
    } catch (e) {}
  }

  Future<List<TransactionComment>> getTransactionComments(String id) async {
    List<TransactionComment> comments = [];

    try {
      var resultdocs = await CRUDModel("transactioncomments").fetch([]);
      for (var i in resultdocs) {
        comments.add(TransactionComment.fromJson(i));
      }
      print("here we go");

      return comments;
    } catch (e) {
      return comments;
    }
  }

  ///it gets a list of all sms messages from the phone message
  Future<List<SmsMessage>> getAllSmsInbox() async {
    final SmsQuery _query = SmsQuery();
    List<SmsMessage> _messages = [];
    var permission = await Permission.sms.status;
    if (permission.isGranted) {
      _messages = await _query.querySms(
        kinds: [SmsQueryKind.inbox],
        address: 'MPESA',
        // count: 10,
      );
    } else {
      await Permission.sms.request();
    }
    return _messages;
  }

  Future<List<TransactionModel>> getFromSmsandAddToTransaction() async {
    List<TransactionModel> transactions = [];
    List<SmsMessage> _sms = await getAllSmsInbox();
    for (SmsMessage smsMessage in _sms) {
      TransactionModel transactionModel = await transactionFromSms(smsMessage);
      if (transactionModel.amount != null) {
        transactions.add(transactionModel);
      }
    }
    return transactions;
  }

  Future<TransactionModel> transactionFromSms(SmsMessage message) async {
    TransactionModel transactionModel = TransactionModel();

    double amount = await getTransactionAmount(message.body!);
    bool isvalid = amount != 0;
    if (isvalid) {
      transactionModel = TransactionModel(
        id: message.id.toString(),
        amount: amount,
        description: 'From phone',
        transactionTime: message.date.toString(),
        amountInDefaultCurrency: amount,
        accountName: "Phone Sms",
      );
    }

    return transactionModel;
  }

  Future<double> getTransactionAmount(String message) async {
    RegExp reg = RegExp(r' ?[0-9]{0,}\.?,?[0-9]+\.[0-9]+');
    Iterable<RegExpMatch> matches = reg.allMatches(message);
    double totalamount = 0;
    bool ismessagevalid = await isMessageValid(message);

    if (ismessagevalid) {
      bool isReceived =
          (message.contains('have received') || (message.contains('has sent')));
      // print(isReceived);
      var amount = matches.first[0];
      amount = amount.toString().replaceAll(',', '');
      totalamount = double.parse(amount.toString());

      if (isReceived) {
        totalamount = totalamount;
      } else {
        totalamount = totalamount * -1;
      }
    }
    return totalamount;
  }

  Future<bool> isMessageValid(String message) async {
    bool ismessageValid = await !(message.contains('Failed') ||
        (message.contains('Insufficient')) ||
        message.contains('PIN') ||
        message.contains('Entered') ||
        (message.contains('partially pay')));
    // print(ismessageValid);
    return ismessageValid;
  }

// utils

}
