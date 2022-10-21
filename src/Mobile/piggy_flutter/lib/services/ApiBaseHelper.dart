import 'dart:convert';

import 'package:http/http.dart' as http;

class ApiBaseHelper {
  final String baseUrl = "";
  Future<dynamic> get(String url) async {
    print('Api Get, url $url');
    var responsejson;
    try {
      Uri value = Uri.parse(baseUrl + url);
      final response = await http.get(value);
      responsejson = returnResponse(response);
    } catch (e) {
      print('No Network');
    }
    print('Api get received');
    return responsejson;
  }

  Future<dynamic> post(String url, Map<String, dynamic> body) async {
    print('Api Post, url $url');
    var responsejson;
    try {
      Uri value = Uri.parse(baseUrl + url);
      final response = await http.post(value, body: body);
      responsejson = returnResponse(response);
    } catch (e) {
      print('No Network');
    }
    print('Api post received');
    return responsejson;
  }

  dynamic returnResponse(http.Response response) {
    switch (response.statusCode) {
      case 200:
        var responseJson = json.decode(response.body.toString());
        print(responseJson);
        return responseJson;
      case 400:
        throw BadRequestException(response.body.toString());
      case 401:
      case 403:
        throw UnauthorisedException(response.body.toString());

      default:
        throw FetchDataException(
            'Error while communicating with server with status code : ${response.statusCode}');
    }
  }
}

class AppException implements Exception {
  final _message;
  final _prefix;
  AppException([this._message, this._prefix]);
  String toString() {
    return "$_prefix$_message";
  }
}

class FetchDataException extends AppException {
  FetchDataException([String? message])
      : super(message, "Error During Communication: ");
}

class BadRequestException extends AppException {
  BadRequestException([message]) : super(message, "Invalid Request: ");
}

class UnauthorisedException extends AppException {
  UnauthorisedException([message]) : super(message, "Unauthorised: ");
}

class InvalidInputException extends AppException {
  InvalidInputException([String? message]) : super(message, "Invalid Input: ");
}
