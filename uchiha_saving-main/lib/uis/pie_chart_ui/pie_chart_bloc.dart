import 'package:uchiha_saving/models/category.dart';
import 'package:uchiha_saving/models/transaction.dart';
import 'package:uchiha_saving/tools/categories_list.dart';

class PieChartBloc {
  List<Map<String, dynamic>> getListByCategory(List<Transaction> list) {
    List<Map<String, dynamic>> _list = [];
    List<Map<String, dynamic>> _finalList = [];

    for (Category u in categoryList) {
      double amount = 0.00;
      for (Transaction i in list) {
        if (u.title == i.category.title) {
          amount += i.amount;
        }
      }

      if (amount > 0.00) {
        double percentage = 100 * amount / getTotal(list);

        _list.add({
          "category": u.title,
          "percentage": percentage,
        });
      }
    }

    double sumPercent = 0.00;

    for (Map<String, dynamic> k in _list) {
      double percent = k["percentage"];

      if (percent < 10.00 && _list.length > 5) {
        sumPercent += percent;
      } else {
        _finalList.add({
          "category": k["category"],
          "percentage": percent.toStringAsFixed(2),
        });
      }
    }

    if (sumPercent > 0.00)
      _finalList.add({
        "category": "Others",
        "percentage": sumPercent.toStringAsFixed(2),
      });

    return _finalList;
  }

  List<Map<String, dynamic>> getListByPriority(List<Transaction> list) {
    List<Map<String, dynamic>> _list = [];

    for (int i = 1; i < 4; i++) {
      double amount = 0.00;
      for (Transaction u in list) {
        if (i == u.priority) {
          amount += u.amount;
        }
      }

      if (amount > 0.00) {
        double percentage = 100 * amount / getTotal(list);
        _list.add({
          "priority": i == 1
              ? "Low"
              : i == 2
                  ? "Medium"
                  : "High",
          "percentage": double.parse(percentage.toStringAsFixed(2)),
        });
      }
    }

    return _list;
  }

  getTotal(List<Transaction> list) {
    double total = 0.00;
    list.forEach((element) {
      total += element.amount;
    });

    return total;
  }
}
