import 'package:piggy_flutter/models/transactionModel.dart';

class TransactionGroupItem {
  TransactionGroupItem({required this.title, required this.groupby});

  final String? title;
  final TransactionsGroupBy? groupby;
  List<TransactionModel> transactions = [];
  double totalInflow = 0.0, totalOutflow = 0.0;
}

enum TransactionsGroupBy { Date, Category }
