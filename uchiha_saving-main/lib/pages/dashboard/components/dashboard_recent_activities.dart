import 'package:cloud_firestore/cloud_firestore.dart' as fr;
import 'package:flutter/material.dart';
import 'package:fluttericon/font_awesome_icons.dart';
import 'package:fluttericon/iconic_icons.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';
import 'package:uchiha_saving/models/category.dart';
import 'package:uchiha_saving/models/person.dart';
import 'package:uchiha_saving/models/transaction.dart';
import 'package:uchiha_saving/pages/transaction_page/transaction_page.dart';
import 'package:uchiha_saving/tools/custom_navigator.dart';
import 'package:uchiha_saving/tools/get_random_color.dart';

class DashboardRecentActivity extends StatefulWidget {
  final Person person;
  DashboardRecentActivity({Key? key, required this.person}) : super(key: key);

  @override
  State<DashboardRecentActivity> createState() =>
      _DashboardRecentActivityState();
}

class _DashboardRecentActivityState extends State<DashboardRecentActivity> {
  // List<Transaction> _list = [
  //   Transaction(
  //     title: "Walmart",
  //     description: "Bought groceries",
  //     createdAt: fr.Timestamp.now(),
  //     amount: 67.65,
  //     transactionType: TransactionType.expense,
  //     category: Category(iconData: Icons.shopping_bag, title: "Grocery"),
  //     priority: 3,
  //   ),
  //   Transaction(
  //     title: "Gas Station",
  //     description: "Filled gas at Racetrac",
  //     createdAt: fr.Timestamp.now(),
  //     amount: 35.00,
  //     transactionType: TransactionType.expense,
  //     category: Category(
  //       iconData: Icons.emoji_transportation,
  //       title: "Transportation",
  //     ),
  //     priority: 3,
  //   ),
  //   Transaction(
  //     title: "Netflix",
  //     description: "Netflix Subscription",
  //     createdAt: fr.Timestamp.now(),
  //     amount: 20.00,
  //     transactionType: TransactionType.expense,
  //     category: Category(
  //       iconData: Iconic.video,
  //       title: "Entertainment",
  //     ),
  //     priority: 1,
  //   ),
  //   Transaction(
  //     title: "College Tuition",
  //     description: "First Installment",
  //     createdAt: fr.Timestamp.now(),
  //     amount: 2000.00,
  //     transactionType: TransactionType.expense,
  //     category: Category(
  //       iconData: Icons.school,
  //       title: "School",
  //     ),
  //     priority: 3,
  //   ),
  // ];

  bool _isColorful = false;

  toggle() {
    setState(() {
      _isColorful = !_isColorful;
    });
  }

  @override
  Widget build(BuildContext context) {
    final _size = MediaQuery.of(context).size;

    return StreamBuilder<fr.QuerySnapshot>(
        stream: fr.FirebaseFirestore.instance
            .collection("Transactions")
            .doc(widget.person.id)
            .collection("Transactions")
            .orderBy("createdAt", descending: true)
            .limit(5)
            .snapshots(),
        builder: (context, snapshot) {
          if (!snapshot.hasData) {
            return SliverToBoxAdapter();
          }
          List<Transaction> _list = snapshot.data!.docs
              .map((e) => Transaction.fromDynamic(e))
              .toList();
          if (_list.isEmpty) {
            return SliverToBoxAdapter();
          }
          return SliverToBoxAdapter(
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: Card(
                elevation: 15,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(20),
                ),
                child: Column(
                  children: [
                    ListTile(
                      title: Text(
                        "Recent Activities",
                        style: GoogleFonts.lato(
                          fontSize: _size.height * 0.025,
                        ),
                      ),
                      // trailing: GestureDetector(
                      //   onTap: toggle,
                      //   child: Container(
                      //     decoration: BoxDecoration(
                      //       color: _isColorful ? Colors.black : Colors.red,
                      //       shape: BoxShape.circle,
                      //     ),
                      //     height: 20,
                      //     width: 20,
                      //     child: Card(),
                      //   ),
                      // ),
                    ),
                    ListView.builder(
                        primary: false,
                        padding: EdgeInsets.all(8.0),
                        shrinkWrap: true,
                        itemCount: _list.length,
                        physics: BouncingScrollPhysics(),
                        itemBuilder: (context, i) {
                          return Container(
                            margin: EdgeInsets.only(bottom: 10),
                            child: ListTile(
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(20),
                              ),
                              leading: Icon(_list[i].category.iconData),
                              contentPadding: EdgeInsets.all(8.0),
                              title: Text(
                                _list[i].title,
                                style: GoogleFonts.lato(
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              subtitle: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    Intl().date('MMM dd', 'en_US').format(
                                          _list[i].createdAt.toDate(),
                                        ),
                                    style: GoogleFonts.lato(
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                  Text(
                                    _list[i].description,
                                    style: GoogleFonts.lato(
                                      fontWeight: FontWeight.w500,
                                    ),
                                    maxLines: 1,
                                    overflow: TextOverflow.ellipsis,
                                  ),
                                ],
                              ),
                              trailing: Text(
                                "\$${_list[i].amount.toStringAsFixed(2)}",
                                style: GoogleFonts.lato(
                                  fontWeight: FontWeight.bold,
                                  color: _list[i].transactionType ==
                                          TransactionType.expense
                                      ? Colors.red
                                      : Colors.green,
                                ),
                              ),
                            ),
                          );
                        }),
                    Divider(
                      thickness: 2,
                    ),
                    ListTile(
                      onTap: () {
                        customNavigator(
                          context,
                          TransactionPage(
                            person: widget.person,
                            key: widget.key,
                          ),
                        );
                      },
                      contentPadding: EdgeInsets.all(8.0),
                      leading: Icon(FontAwesome.list_bullet),
                      title: Text(
                        "View all activity",
                        style: GoogleFonts.lato(),
                      ),
                      trailing: Icon(Icons.arrow_forward_ios),
                    )
                  ],
                ),
              ),
            ),
          );
        });
  }
}
