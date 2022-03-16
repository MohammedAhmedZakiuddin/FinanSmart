import 'package:cloud_firestore/cloud_firestore.dart' as fr;
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';
import 'package:uchiha_saving/models/category.dart';
import 'package:uchiha_saving/models/person.dart';
import 'package:uchiha_saving/models/transaction.dart';
import 'package:uchiha_saving/pages/transaction_page/edit_transaction_ui.dart';
import 'package:uchiha_saving/tools/custom_navigator.dart';

class TransactionBuilder extends StatelessWidget {
  final Person person;
  final List<Transaction> transactionList;
  final List<String> transactionIdList;
  const TransactionBuilder(
      {Key? key,
      required this.person,
      required this.transactionList,
      required this.transactionIdList})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SliverList(
      delegate: SliverChildBuilderDelegate(
        (context, i) {
          return Dismissible(
            key: ValueKey(transactionList[i]),
            secondaryBackground: Card(
              color: Colors.red,
              child: ListTile(
                trailing: Icon(Icons.delete, color: Colors.white),
              ),
            ),
            background: Card(
              color: Colors.blue,
              child: ListTile(
                leading: Icon(Icons.edit, color: Colors.white),
              ),
            ),
            onDismissed: (dir) {
              if (dir == DismissDirection.startToEnd) {
                customNavigator(
                    context,
                    EditTransactionsUI(
                      person: person,
                      key: key,
                      id: transactionIdList[i],
                      transaction: transactionList[i],
                    ));
              } else {
                fr.FirebaseFirestore.instance
                    .collection("Transactions")
                    .doc(person.id)
                    .collection("Transactions")
                    .doc(transactionIdList[i])
                    .delete()
                    .then((value) {
                  if (transactionList[i].transactionType ==
                      TransactionType.income) {
                    fr.FirebaseFirestore.instance
                        .collection("Users")
                        .doc(person.id)
                        .update({
                      "balance": person.balance - transactionList[i].amount,
                    });
                  } else {
                    fr.FirebaseFirestore.instance
                        .collection("Users")
                        .doc(person.id)
                        .update({
                      "balance": person.balance + transactionList[i].amount,
                    });
                  }
                });
              }
            },
            confirmDismiss: (dir) async {
              if (dir == DismissDirection.startToEnd) {
                List<Category> _items = [];
                customNavigator(
                    context,
                    EditTransactionsUI(
                      person: person,
                      key: key,
                      id: transactionIdList[i],
                      transaction: transactionList[i],
                    ));
              } else
                return showDialog(
                    context: context,
                    builder: (ctx) {
                      return AlertDialog(
                        title: Text("Are you sure want to remove?"),
                        content: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            IconButton(
                              onPressed: () {
                                Navigator.of(context).pop(true);
                              },
                              icon: Icon(Icons.check),
                            ),
                            IconButton(
                              onPressed: () {
                                Navigator.of(context).pop(false);
                              },
                              icon: Icon(Icons.clear),
                            ),
                          ],
                        ),
                      );
                    });
            },
            child: ListTile(
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(20),
              ),
              leading: Icon(transactionList[i].category.iconData),
              contentPadding: EdgeInsets.all(8.0),
              title: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    Intl().date('MMM dd', 'en_US').format(
                          transactionList[i].createdAt.toDate(),
                        ),
                    style: GoogleFonts.lato(
                      fontWeight: FontWeight.bold,
                      fontSize: MediaQuery.of(context).size.height * 0.016,
                    ),
                  ),
                  Text(
                    transactionList[i].title,
                    style: GoogleFonts.lato(
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ],
              ),
              subtitle: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    transactionList[i].category.title,
                    style: GoogleFonts.lato(
                      fontWeight: FontWeight.bold,
                      fontSize: MediaQuery.of(context).size.height * 0.020,
                    ),
                  ),
                  Text(
                    transactionList[i].description,
                    style: GoogleFonts.lato(
                      fontWeight: FontWeight.w600,
                    ),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                  Divider(
                    thickness: 2,
                  ),
                ],
              ),
              trailing: Text(
                "\$${transactionList[i].amount.toStringAsFixed(2)}",
                style: GoogleFonts.lato(
                  fontWeight: FontWeight.bold,
                  color: transactionList[i].transactionType ==
                          TransactionType.expense
                      ? Colors.red
                      : Colors.green,
                ),
              ),
            ),
          );
        },
        childCount: transactionList.length,
      ),
    );
  }
}
