import 'package:uchiha_saving/models/category.dart';

class TransactionPageModel {
  DateTime? startDate, endDate;
  Category? category;

  TransactionPageModel({
    this.startDate,
    this.endDate,
    this.category,
  });
}
