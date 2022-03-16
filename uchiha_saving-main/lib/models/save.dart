import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:uchiha_saving/models/category.dart';
import 'package:uchiha_saving/tools/categories_list.dart';

class Save {
  final String title;
  final String description;
  final Timestamp createdAt;
  final Timestamp expiredAt;
  final double amount;
  final Category category;

  Save({
    required this.title,
    required this.description,
    required this.createdAt,
    required this.expiredAt,
    required this.amount,
    required this.category,
  });

  Map<String, dynamic> get toMap => {
        "title": title,
        "description": description,
        "createdAt": createdAt,
        "expiredAt": expiredAt,
        "amount": amount,
        "category": category.title,
      };

  factory Save.fromDynamic(dynamic data) {
    return Save(
      title: data["title"],
      description: data["description"],
      createdAt: data["createdAt"],
      expiredAt: data["expiredAt"],
      amount: data["amount"],
      category: categoryList
          .firstWhere((element) => element.title == data["category"]),
    );
  }
}
