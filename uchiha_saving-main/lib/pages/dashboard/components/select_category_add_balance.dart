import 'package:flutter/material.dart';
import 'package:uchiha_saving/models/person.dart';
import 'package:uchiha_saving/pages/dashboard/components/add_balance_ui.dart';
import 'package:uchiha_saving/tools/categories_list.dart';
import 'package:uchiha_saving/tools/custom_navigator.dart';

class SelectCategoryAddBalanceUI extends StatelessWidget {
  final Person person;
  const SelectCategoryAddBalanceUI({Key? key, required this.person})
      : super(key: key);

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
                        AddBalanceUI(
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
