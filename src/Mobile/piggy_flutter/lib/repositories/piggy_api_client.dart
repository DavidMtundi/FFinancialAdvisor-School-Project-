import 'dart:convert';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:http/http.dart' as http;
import 'package:piggy_flutter/models/models.dart';
import 'package:piggy_flutter/repositories/FirebaseMethods.dart';
import 'package:piggy_flutter/utils/uidata.dart';
import 'package:shared_preferences/shared_preferences.dart';

class PiggyApiClient {
  PiggyApiClient({required this.httpClient});

  static const String baseUrl = 'https://piggyvault.abhith.net';

  final http.Client httpClient;

  // ACCOUNT
  Future<AccountFormModel?> getAccountForEdit(String? id) async {
    //get the accountid
    //get it from the location
//     DocumentReference DocumentChange =
//         FirebaseFirestore.instance.collection("account").doc(id);
// //DocumentReference doc = await CRUDModel(
//     final ApiResponse<dynamic> result = await getAsync<dynamic>(
//         '$baseUrl/api/services/app/account/getAccountForEdit?id=$id');
    var result = await CRUDModel<AccountFormModel>("account").getById(id!);

    //if (result!) {
    return AccountFormModel.fromJson(result);
    // }

    // return null;
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
    // try {
    //   final resultgotten = input.id != null
    //       ? await FirebaseFirestore.instance
    //           .collection("category")
    //           .doc(input.id)
    //       : await FirebaseFirestore.instance.collection("category").doc();
    //   input.id = resultgotten.id;
    //   var value = input.toJson();
    //   await resultgotten.set(value);
    //   return true;
    // } catch (e) {
    //   return false;
    // }

    // final result = await postAsync(
    //     '$baseUrl/api/services/app/transaction/CreateOrUpdateTransaction', {
    //   "id": input.id,
    //   "description": input.description,
    //   "amount": input.amount,
    //   "categoryId": input.categoryId,
    //   "accountId": input.accountId,
    //   "transactionTime": input.transactionTime
    // });

    //return ApiResponse.fromJson(returnthis);

    // final response = await postAsync<dynamic>(
    //     '$baseUrl/api/services/app/Category/CreateOrUpdateCategory',
    //     {'id': input.id, 'name': input.name, 'icon': input.icon});
    // if (!response.success!) {
    //   throw Exception(response.error);
    // }

    // return true;
  }

  Future<IsTenantAvailableResult> isTenantAvailable(String tenancyName) async {
    final tenantUrl = '$baseUrl/api/services/app/Account/IsTenantAvailable';
    final response =
        await this.postAsync<dynamic>(tenantUrl, {"tenancyName": tenancyName});

    if (!response.success!) {
      throw Exception('invalid credentials');
    }

    return IsTenantAvailableResult.fromJson(response.result);
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
      "accessToken": credential.user!.getIdToken(),
      "encryptedAccessToken": credential.user!.getIdToken(),
      "expireInSeconds": 100,
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
    var response = FirebaseAuth.instance.currentUser;
    Map<String, dynamic> result = ({
      "id": response!.uid,
      "name": response.displayName,
      "surname": response.displayName,
      "userName": response.displayName,
      "emailAddress": response.email,
      "profilePictureId": response.photoURL
    });
    Map<String, dynamic> tenantResult = ({
      "id": response.uid,
      "name": response.displayName,
      "tenancyName": response.displayName,
    });
    if (result['user'] != null) {
      return LoginInformationResult(
          user: UserModel.fromJson(result),
          tenant: Tenant.fromJson(tenantResult));
    }

    return null;
  }

//get transaction
  Future<TransactionSummary> getTransactionSummary(String duration) async {
    var result = await getAsync<dynamic>(
        '$baseUrl/api/services/app/Transaction/GetSummary?duration=$duration');

    return TransactionSummary.fromJson(result.result);
  }

  Future<TenantAccountsResult> getTenantAccounts() async {
    List<Account> userAccountItems = [];
    List<Account> familyAccountItems = [];

    // var result = await getAsync<dynamic>(
    //     '$baseUrl/api/services/app/account/GetTenantAccounts');
    var result = await CRUDModel("allaccounts").fetch([]);

    /// if (result.success!) {
    result['useraccounts'].forEach((account) {
      userAccountItems.add(Account.fromJson(account));
    });

    result.result['otheraccounts'].forEach((account) {
      familyAccountItems.add(Account.fromJson(account));
    });

    return TenantAccountsResult(
        familyAccounts: familyAccountItems, userAccounts: userAccountItems);
  }

  Future<List<Category>> getTenantCategories() async {
    List<Category> tenantCategories = [];

    // var result = await getAsync(
    //     '$baseUrl/api/services/app/Category/GetTenantCategories');
    //var result = await FirebaseFirestore.instance.collection("category").get();
    tenantCategories = await CRUDModel<Category>("category").fetch([]);
    //if (result.) {

    // result.docs.forEach(
    //     (category) => tenantCategories.add(Category.fromJson(category.data())));
    //  }
    return tenantCategories;
  }

//create or update a transaction
  Future<ApiResponse<dynamic>> createOrUpdateTransaction(
      TransactionEditDto input) async {
    Map<String, dynamic> returnthis = new Map();
    try {
      var result = await CRUDModel("transaction")
          .addProduct(input.toJson(), input.id, "id");
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
    final result =
        await postAsync('$baseUrl/api/services/app/transaction/transfer', {
      "id": input.id,
      "description": input.description,
      "amount": input.amount,
      "toAmount": input.toAmount,
      "categoryId": input.categoryId,
      "accountId": input.accountId,
      "toAccountId": input.toAccountId,
      "transactionTime": input.transactionTime
    });

    return result;
  }

  Future<List<TransactionModel>> getTransactions(
      GetTransactionsInput input) async {
    final List<TransactionModel> transactions = <TransactionModel>[];

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

    // final ApiResponse<dynamic> result = await getAsync<dynamic>(
    //     '$baseUrl/api/services/app/transaction/GetTransactions?$params');

    // List<TransactionModel> allfound =
    //     await CRUDModel<TransactionModel>("transaction").fetch([]);
    // allfound.forEach((element) {
    //   transactions.add(element);
    // });
    final result = await CRUDModel<TransactionModel>("transations").fetch([]);
    //if (result!) {
    result.forEach((dynamic transaction) {
      var model = jsonEncode(transaction);
      var decodedmodel = jsonDecode(model.toString());
      transactions.add(TransactionModel.fromJson(decodedmodel));
    });
    // }
    return transactions;
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

  // Future<List<Currency>> getCurrencies() async {
  //   var result =
  //       await getAsync('$baseUrl/api/services/app/currency/GetCurrencies');

  //   return result.result['items']
  //       .map<Currency>((currency) => Currency.fromJson(currency))
  //       .toList();
  // }

  Future<List<AccountType>> getAccountTypes() async {
    // var result = await getAsync<dynamic>(
    //     '$baseUrl/api/services/app/account/GetAccountTypes');
    var result = await CRUDModel("accounttypes").fetch([]);
    return await result
        .map<AccountType>((item) =>
            AccountType.fromJson(jsonDecode(jsonEncode(item.toString()))))
        .toList();
  }

  // Reports
  Future<List<CategoryWiseRecentMonthsReportItem>>
      getCategoryWiseTransactionSummaryHistory() async {
    List<CategoryWiseRecentMonthsReportItem> data = [];
    var result = await getAsync(
        '$baseUrl/api/services/app/Report/GetCategoryWiseTransactionSummaryHistory?numberOfIteration=3&periodOfIteration=month&typeOfTransaction=expense');

    if (result.success!) {
      result.result['items'].forEach((item) =>
          data.add(CategoryWiseRecentMonthsReportItem.fromJson(item)));
    }
    return data;
  }

  Future<List<CategoryReportListDto>> getCategoryReport(
      GetCategoryReportInput input) async {
    final List<CategoryReportListDto> data = [];
    final ApiResponse result = await getAsync<dynamic>(
        '$baseUrl/api/services/app/Report/GetCategoryReport?startDate=${input.startDate}&endDate=${input.endDate}');

    if (result.success!) {
      result.result['items']
          .forEach((item) => data.add(CategoryReportListDto.fromJson(item)));
    }
    return data;
  }

  // Transaction
  Future<void> deleteTransaction(String id) async {
    await CRUDModel("transaction").remove(id);
    // await deleteAsync<dynamic>(
    //     '$baseUrl/api/services/app/transaction/DeleteTransaction?id=$id');
  }

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
    // var result = await getAsync<dynamic>(
    //     '$baseUrl/api/services/app/transaction/GetTransactionComments?id=$id');
    var result = await CRUDModel("transactioncomments").fetch([]);

    result.forEach((element) {
      var value = jsonEncode(element);
      comments.add(TransactionComment.fromJson(
          jsonDecode(jsonEncode(value.toString()))));
    });
    // if (result.success!) {
    //   result.result['items'].forEach((comment) {
    //     comments.add(TransactionComment.fromJson(comment));
    //   });
    // }

    return comments;
  }

  // USER
  Future<UserSettings> getUserSettings() async {
    var result =
        await getAsync<dynamic>('$baseUrl/api/services/app/User/GetSettings');

    return UserSettings.fromJson(result.result);
  }

  Future<void> changeDefaultCurrency(String currencyCode) async {
    await postAsync<dynamic>(
        '$baseUrl/api/services/app/User/ChangeDefaultCurrency',
        {"currencyCode": currencyCode});
  }

// utils

  Future<ApiResponse<T?>> getAsync<T>(String resourcePath) async {
    final prefs = await SharedPreferences.getInstance();
    var token = prefs.getString(UIData.authToken);
    var tenantId = prefs.getInt(UIData.tenantId);
    var url = Uri.parse(resourcePath);

    var response = await this.httpClient.get(url, headers: {
      'Content-type': 'application/json',
      'Accept': 'application/json',
      'Authorization': 'Bearer $token',
      'Piggy-TenantId': tenantId.toString()
    });
    return processResponse<T>(response);
  }

  Future<ApiResponse<T?>> postAsync<T>(
      String resourcePath, dynamic data) async {
    final prefs = await SharedPreferences.getInstance();
    var token = prefs.getString(UIData.authToken);
    var tenantId = prefs.getInt(UIData.tenantId);

    var content = json.encoder.convert(data);
    Map<String, String> headers;

    if (token == null) {
      headers = {
        'Content-type': 'application/json',
        'Accept': 'application/json',
        'Piggy-TenantId': tenantId.toString()
      };
    } else {
      headers = {
        'Content-type': 'application/json',
        'Accept': 'application/json',
        'Authorization': 'Bearer $token',
        'Piggy-TenantId': tenantId.toString()
      };
    }

    var url = Uri.parse(resourcePath);

    var response = await http.post(url, body: content, headers: headers);
    return processResponse<T>(response);
  }

  Future<ApiResponse<T?>> deleteAsync<T>(String resourcePath) async {
    final prefs = await SharedPreferences.getInstance();
    var token = prefs.getString(UIData.authToken);
    var tenantId = prefs.getInt(UIData.tenantId);

    Map<String, String> headers;

    if (token == null) {
      // TODO: throw exception
      headers = {
        'Content-type': 'application/json',
        'Accept': 'application/json',
        'Piggy-TenantId': tenantId.toString()
      };
    } else {
      headers = {
        'Content-type': 'application/json',
        'Accept': 'application/json',
        'Authorization': 'Bearer $token',
        'Piggy-TenantId': tenantId.toString()
      };
    }

    var url = Uri.parse(resourcePath);
    var response = await http.delete(url, headers: headers);
    return processResponse<T>(response);
  }

  ApiResponse<T?> processResponse<T>(http.Response response) {
    try {
      // if (!((response.statusCode < 200) ||
      //     (response.statusCode >= 300) ||
      //     (response.body == null))) {
      var jsonResult = response.body;
      dynamic parsedJson = jsonDecode(jsonResult);

      // print(jsonResult);

      var output = ApiResponse<T?>(
        result: parsedJson["result"],
        success: parsedJson["success"],
        unAuthorizedRequest: parsedJson['unAuthorizedRequest'],
      );

      if (!output.success!) {
        output.error = parsedJson["error"]["message"];
      }
      return output;
    } catch (e) {
      return ApiResponse<T?>(
          result: null,
          success: false,
          unAuthorizedRequest: false,
          error: 'Something went wrong. Please try again');
    }
  }
}
