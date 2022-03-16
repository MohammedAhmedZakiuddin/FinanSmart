import 'package:cloud_firestore/cloud_firestore.dart' as fs;
import 'package:flutter/material.dart';
import 'package:uchiha_saving/models/person.dart';
import 'package:uchiha_saving/models/transaction.dart';

class LineChartRepo {
  List<int> listOfDays(DateTime date) {
    List<int> _list = [];
    int lastDay = DateUtils.getDaysInMonth(date.year, date.month);

    for (int i = 1; i < lastDay; i++) {
      _list.add(i);
    }

    return _list;
  }

  List<Map<String, dynamic>> getList(DateTime date, List<Transaction> list) {
    List<Map<String, dynamic>> _list = [];
    int lastDay = DateUtils.getDaysInMonth(date.year, date.month);

    for (int u in listOfDays(date)) {
      double amount = 0.00;

      for (Transaction i in list) {
        if (u == i.createdAt.toDate().day) {
          amount += i.amount;
        }
      }
      if (amount != 0)
        _list.add({
          "day": u,
          "amount": amount,
        });
    }

    print(_list);

    return _list;
  }
}
