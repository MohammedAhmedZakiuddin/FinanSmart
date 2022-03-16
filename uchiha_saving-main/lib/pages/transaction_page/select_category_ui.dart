import 'package:flutter/material.dart';
import 'package:uchiha_saving/models/person.dart';
import 'package:uchiha_saving/pages/transaction_page/add_transaction_ui.dart';
import 'package:uchiha_saving/tools/categories_list.dart';
import 'package:uchiha_saving/tools/custom_navigator.dart';

class SelectCategoryUI extends StatelessWidget {
  final Person person;
  const SelectCategoryUI({Key? key, required this.person}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: CustomScrollView(
        slivers: [
          SliverAppBar(
            title: Text("Select Category"),
            pinned: true,
          ),
          SliverList(
            delegate: SliverChildBuilderDelegate(
              (context, i) {
                return ListTile(
                  leading: Icon(categoryList[i].iconData),
                  title: Text(categoryList[i].title),
                  onTap: () {
                    customNavigatorAndReplace(
                        context,
                        AddTransactionsUI(
                          person: person,
                          category: categoryList[i],
                        ));
                  },
                );
              },
              childCount: categoryList.length,
            ),
          ),
        ],
      ),
    );
  }
}
