import 'package:flutter/material.dart';
import 'package:uchiha_saving/models/category.dart';
import 'package:uchiha_saving/models/person.dart';
import 'package:uchiha_saving/pages/transaction_page/bloc/transaction_page_bloc.dart';
import 'package:uchiha_saving/pages/transaction_page/bloc/transaction_page_model.dart';
import 'package:uchiha_saving/tools/categories_list.dart';

class TransactionPageCategoriesPicker extends StatelessWidget {
  final Person person;
  final TransactionPageModel transactionPageModel;
  final TransactionPageBloc bloc;
  TransactionPageCategoriesPicker(
      {Key? key,
      required this.person,
      required this.transactionPageModel,
      required this.bloc})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SliverToBoxAdapter(
      child: Padding(
        padding: EdgeInsets.symmetric(horizontal: 8.0),
        child: Row(
          children: [
            Expanded(
              child: DropdownButton<Category>(
                isExpanded: true,
                underline: Center(),
                value: transactionPageModel.category,
                hint: Text(" Category"),
                items: categoryList.map((Category value) {
                  return DropdownMenuItem<Category>(
                    value: value,
                    child: Row(
                      children: [
                        Icon(value.iconData),
                        Text(" " + value.title),
                      ],
                    ),
                  );
                }).toList(),
                onChanged: (value) {
                  bloc.update(
                    startDate: transactionPageModel.startDate,
                    endDate: transactionPageModel.endDate,
                    category: categoryList
                        .firstWhere((element) => element.title == value!.title),
                  );
                },
              ),
            ),
            transactionPageModel.category == null
                ? Container()
                : IconButton(
                    onPressed: () {
                      bloc.update(
                        startDate: transactionPageModel.startDate,
                        endDate: transactionPageModel.endDate,
                        category: null,
                      );
                    },
                    icon: Icon(Icons.clear),
                  ),
          ],
        ),
      ),
    );
  }
}

// SelectFormField(
//           type: SelectFormFieldType.dropdown,
//           decoration: InputDecoration(
//             label: Text("  Category"),
//             suffixIcon: Icon(Icons.arrow_drop_down),
//             suffix: IconButton(
//               onPressed: () {
//                 bloc.update(
//                   startDate: transactionPageModel.startDate,
//                   endDate: transactionPageModel.endDate,
//                   category: Category(iconData: Icons.ac_unit, title: ""),
//                 );
//               },
//               icon: Icon(
//                 Icons.clear,
//               ),
//             ),
//             contentPadding: EdgeInsets.symmetric(horizontal: 8, vertical: 4),
//             // isDense: true,
//             isCollapsed: true,
//             border: OutlineInputBorder(),
//           ),
//           items: categoryList
//               .map((e) => <String, dynamic>{
//                     "value": e.title,
//                     "label": e.title,
//                     "icon": Icon(e.iconData),
//                   })
//               .toList(),
//           onChanged: (val) {
//             bloc.update(
//               startDate: transactionPageModel.startDate,
//               endDate: transactionPageModel.endDate,
//               category:
//                   categoryList.firstWhere((element) => element.title == val),
//             );
//           },
//           onSaved: (val) {
//             bloc.update(
//               startDate: transactionPageModel.startDate,
//               endDate: transactionPageModel.endDate,
//               category:
//                   categoryList.firstWhere((element) => element.title == val),
//             );
//           },
//         ),
