import 'package:flutter/material.dart';

class ApiResponse<T> {
  ApiResponse(
      {required this.success,
      required this.result,
      required this.unAuthorizedRequest,
      this.error});

  bool? success;
  T? result;
  bool? unAuthorizedRequest;
  String? error;

  ApiResponse.fromJson(Map<String, dynamic> json) {
    success = json['success'];
    result = json['result'];
    unAuthorizedRequest = json['unAuthorizedRequest'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['success'] = this.success;
    data['result'] = this.result;
    data['unAuthorizedRequest'] = this.unAuthorizedRequest;
    return data;
  }
}
