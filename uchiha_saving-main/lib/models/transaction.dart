import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:uchiha_saving/models/category.dart';
import 'package:uchiha_saving/tools/categories_list.dart';

enum TransactionType { income, expense }

class Transaction {
  final String title;
  final String description;
  final Timestamp createdAt;
  final double amount;
  final TransactionType transactionType;
  final Category category;
  final int priority; // high => 3, medium => 2, low => 1

  Transaction(
      {required this.title,
      required this.description,
      required this.createdAt,
      required this.amount,
      required this.transactionType,
      required this.category,
      required this.priority});

  Map<String, dynamic> get toMap => {
        "title": title,
        "description": description,
        "createdAt": createdAt,
        "amount": amount,
        "transactionType": transactionTypeToString(transactionType),
        "category": category.title,
        "priority": priority,
      };

  static String transactionTypeToString(TransactionType transactionType) =>
      transactionType == TransactionType.expense ? "expense" : "income";

  static TransactionType stringToTransactionType(String transactionType) =>
      transactionType == "expense"
          ? TransactionType.expense
          : TransactionType.income;

  factory Transaction.fromDynamic(dynamic data) {
    return Transaction(
      amount: data["amount"],
      category: categoryList
          .firstWhere((element) => element.title == data["category"]),
      createdAt: data["createdAt"],
      description: data["description"],
      priority: data["priority"],
      transactionType: stringToTransactionType(data["transactionType"]),
      title: data["title"],
    );
  }
}
