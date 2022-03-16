import 'package:date_time_picker/date_time_picker.dart';
import 'package:flutter/material.dart';
import 'package:uchiha_saving/models/person.dart';
import 'package:uchiha_saving/pages/transaction_page/bloc/transaction_page_bloc.dart';
import 'package:uchiha_saving/pages/transaction_page/bloc/transaction_page_model.dart';

class TransactionPageDatePicker extends StatelessWidget {
  final Person person;
  final TransactionPageModel transactionPageModel;
  final TransactionPageBloc bloc;
  const TransactionPageDatePicker(
      {Key? key,
      required this.person,
      required this.transactionPageModel,
      required this.bloc})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 8.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Flexible(
            child: DateTimePicker(
              type: DateTimePickerType.date,
              dateMask: 'd MMM, yyyy',
              initialValue: transactionPageModel.startDate.toString(),
              firstDate: DateTime(2000),
              lastDate: DateTime.now(),
              icon: Icon(Icons.event),
              decoration: InputDecoration(
                border: OutlineInputBorder(),
                label: Text("Start Date"),
              ),
              onChanged: (val) {
                bloc.update(
                  startDate: DateTime.parse(val),
                  endDate: transactionPageModel.endDate,
                  category: transactionPageModel.category,
                );
              },
              validator: (val) {
                return null;
              },
              onSaved: (val) {
                bloc.update(
                  startDate: DateTime.parse(val!),
                  endDate: transactionPageModel.endDate,
                  category: transactionPageModel.category,
                );
              },
            ),
          ),
          SizedBox(width: 20),
          Flexible(
            child: DateTimePicker(
              type: DateTimePickerType.date,
              dateMask: 'd MMM, yyyy',
              decoration: InputDecoration(
                border: OutlineInputBorder(),
                label: Text("End Date"),
              ),
              initialValue: transactionPageModel.endDate.toString(),
              firstDate: transactionPageModel.startDate,
              lastDate: DateTime.now(),
              icon: Icon(Icons.event),
              onChanged: (val) {
                bloc.update(
                  endDate: DateTime.parse(val),
                  startDate: transactionPageModel.startDate,
                  category: transactionPageModel.category,
                );
              },
              onSaved: (val) {
                bloc.update(
                  endDate: DateTime.parse(val!),
                  startDate: transactionPageModel.startDate,
                  category: transactionPageModel.category,
                );
              },
              validator: (val) {
                return null;
              },
            ),
          ),
        ],
      ),
    );
  }
}
