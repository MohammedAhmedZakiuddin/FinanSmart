import 'package:cloud_firestore/cloud_firestore.dart' as fs;
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:fluttericon/font_awesome5_icons.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';
import 'package:theme_provider/theme_provider.dart';
import 'package:uchiha_saving/models/person.dart';
import 'package:uchiha_saving/models/save.dart';
import 'package:uchiha_saving/models/transaction.dart';
import 'package:uchiha_saving/pages/savings_page/components/create_goal_card.dart';
import 'package:uchiha_saving/tools/custom_navigator.dart';
import 'package:uchiha_saving/uis/edit_goal_ui/edit_goal_ui.dart';

class SavingsPage extends StatefulWidget {
  final Person person;
  const SavingsPage({Key? key, required this.person}) : super(key: key);

  @override
  State<SavingsPage> createState() => _SavingsPageState();
}

class _SavingsPageState extends State<SavingsPage> {
  double _targetAmount = 0;
  double _usableBalance = 0;
  bool _first = true;
  Save? save;

  List<String> _selectedList = [];

  @override
  Widget build(BuildContext context) {
    final _size = MediaQuery.of(context).size;
    return Scaffold(
      body: CustomScrollView(
        physics: BouncingScrollPhysics(),
        slivers: [
          SliverAppBar(
            title: Text(
              "🎯 Goal",
              style: GoogleFonts.lato(),
            ),
            backgroundColor: Colors.transparent,
            pinned: true,
            foregroundColor:
                ThemeProvider.controllerOf(context).currentThemeId == "dark"
                    ? Colors.white
                    : Colors.black,
            actions: [
              IconButton(
                onPressed: () {
                  customNavigator(
                    context,
                    EditGoalUI(
                      person: widget.person,
                      key: widget.key,
                      save: save!,
                    ),
                  );
                },
                icon: Icon(FontAwesome5.edit),
              ),
            ],
          ),
          StreamBuilder<fs.DocumentSnapshot>(
              stream: fs.FirebaseFirestore.instance
                  .collection("Save")
                  .doc(widget.person.id)
                  .snapshots(),
              builder: (context, snapshot) {
                if (!snapshot.hasData) {
                  return SliverToBoxAdapter(
                    child: Center(
                      child: CircularProgressIndicator(),
                    ),
                  );
                } else if (!snapshot.data!.exists) {
                  return CreateGoalCard(person: widget.person);
                }

                save = Save.fromDynamic(snapshot.data!.data());
                _targetAmount = save!.amount;

                if (_first) {
                  _usableBalance = widget.person.balance * 0.25;
                  _first = false;
                }

                return SliverToBoxAdapter(
                  child: ListView(
                    padding: EdgeInsets.all(8.0),
                    shrinkWrap: true,
                    primary: false,
                    children: [
                      Card(
                        elevation: 15,
                        child: Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              SizedBox(height: 25),
                              Container(
                                alignment: Alignment.center,
                                child: Column(
                                  children: [
                                    Text(
                                      "🎯 Target Amount",
                                      style: GoogleFonts.lato(
                                        fontSize: _size.height * 0.027,
                                        fontWeight: FontWeight.w600,
                                      ),
                                    ),
                                    SizedBox(height: 10),
                                    Text(
                                      "\$${_targetAmount.toStringAsFixed(2)}",
                                      textAlign: TextAlign.center,
                                      style: GoogleFonts.lato(
                                        fontSize: _size.height * 0.04,
                                        color: _usableBalance > _targetAmount
                                            ? Colors.green
                                            : Colors.red,
                                        fontWeight: FontWeight.w900,
                                      ),
                                    ),
                                    SizedBox(height: 10),
                                    Text(
                                      save!.description,
                                      style: GoogleFonts.lato(
                                        fontSize: _size.height * 0.027,
                                        fontWeight: FontWeight.w500,
                                      ),
                                    ),
                                    SizedBox(height: 10),
                                    if ((_targetAmount - _usableBalance) > 0)
                                      Text(
                                        "Needed: \$ " +
                                            (_targetAmount - _usableBalance)
                                                .toStringAsFixed(2),
                                        style: GoogleFonts.lato(
                                          fontSize: _size.height * 0.023,
                                          color: Colors.red,
                                        ),
                                      ),
                                    if ((_targetAmount - _usableBalance) < 0)
                                      Text(
                                        "Surplus: \$ " +
                                            (_usableBalance - _targetAmount)
                                                .toStringAsFixed(2),
                                        style: GoogleFonts.lato(
                                          fontSize: _size.height * 0.023,
                                          color: Colors.green,
                                        ),
                                      ),
                                    SizedBox(height: 10),
                                    Text(
                                      "Usable Balance: \$ " +
                                          _usableBalance.toStringAsFixed(2),
                                      style: GoogleFonts.lato(
                                        fontSize: _size.height * 0.023,
                                      ),
                                    ),
                                    SizedBox(height: 10),
                                    Text(
                                      "Target Date: " +
                                          DateFormat("d MMM, yyyy")
                                              .format(save!.expiredAt.toDate()),
                                      style: GoogleFonts.lato(
                                        fontSize: _size.height * 0.023,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                      save!.amount > widget.person.balance * 0.25
                          ? StreamBuilder<fs.QuerySnapshot>(
                              stream: fs.FirebaseFirestore.instance
                                  .collection("Transactions")
                                  .doc(widget.person.id)
                                  .collection("Transactions")
                                  .where("priority", isLessThanOrEqualTo: 2)
                                  .where("transactionType",
                                      isEqualTo: "expense")
                                  .snapshots(),
                              builder: (context, snapshot) {
                                if (!snapshot.hasData) {
                                  return Center(
                                    child: CircularProgressIndicator(),
                                  );
                                }
                                List<Transaction> transactionList = snapshot
                                    .data!.docs
                                    .map((e) => Transaction.fromDynamic(e))
                                    .toList();

                                List<String> transactionIdList = snapshot
                                    .data!.docs
                                    .map((e) => e.id)
                                    .toList();

                                return Card(
                                  child: Column(
                                    children: [
                                      Padding(
                                        padding: const EdgeInsets.all(8.0),
                                        child: Text(
                                          "🟢 Be Economical",
                                          style: GoogleFonts.lato(
                                              fontSize: _size.height * 0.025),
                                        ),
                                      ),
                                      ListView.builder(
                                          shrinkWrap: true,
                                          primary: false,
                                          itemCount: transactionList.length,
                                          itemBuilder: (context, i) {
                                            bool _isSelected = _selectedList
                                                .contains(transactionIdList[i]);
                                            return ListTile(
                                              onTap: () {
                                                if (!_isSelected) {
                                                  _selectedList.add(
                                                      transactionIdList[i]);

                                                  _usableBalance +=
                                                      transactionList[i].amount;
                                                  setState(() {});
                                                } else {
                                                  _selectedList.remove(
                                                      transactionIdList[i]);
                                                  _usableBalance -=
                                                      transactionList[i].amount;
                                                  setState(() {});
                                                }

                                                if (_usableBalance >=
                                                    _targetAmount) {
                                                  showDialog(
                                                      builder: (ctx) {
                                                        return AlertDialog(
                                                          content: Text(
                                                              "You have meet you target!!!"),
                                                        );
                                                      },
                                                      context: context);
                                                }
                                              },
                                              leading: Icon(transactionList[i]
                                                  .category
                                                  .iconData),
                                              contentPadding:
                                                  EdgeInsets.all(8.0),
                                              title: Column(
                                                crossAxisAlignment:
                                                    CrossAxisAlignment.start,
                                                children: [
                                                  Text(
                                                    Intl()
                                                        .date('MMM dd', 'en_US')
                                                        .format(
                                                          transactionList[i]
                                                              .createdAt
                                                              .toDate(),
                                                        ),
                                                    style: GoogleFonts.lato(
                                                      fontWeight:
                                                          FontWeight.bold,
                                                      fontSize:
                                                          MediaQuery.of(context)
                                                                  .size
                                                                  .height *
                                                              0.016,
                                                      decoration: _isSelected
                                                          ? TextDecoration
                                                              .lineThrough
                                                          : TextDecoration.none,
                                                    ),
                                                  ),
                                                  Text(
                                                    transactionList[i].title,
                                                    style: GoogleFonts.lato(
                                                      fontWeight:
                                                          FontWeight.bold,
                                                      decoration: _isSelected
                                                          ? TextDecoration
                                                              .lineThrough
                                                          : TextDecoration.none,
                                                    ),
                                                  ),
                                                ],
                                              ),
                                              subtitle: Column(
                                                crossAxisAlignment:
                                                    CrossAxisAlignment.start,
                                                children: [
                                                  Text(
                                                    transactionList[i]
                                                        .category
                                                        .title,
                                                    style: GoogleFonts.lato(
                                                      fontWeight:
                                                          FontWeight.bold,
                                                      fontSize:
                                                          MediaQuery.of(context)
                                                                  .size
                                                                  .height *
                                                              0.020,
                                                      decoration: _isSelected
                                                          ? TextDecoration
                                                              .lineThrough
                                                          : TextDecoration.none,
                                                    ),
                                                  ),
                                                  Text(
                                                    transactionList[i]
                                                        .description,
                                                    style: GoogleFonts.lato(
                                                      fontWeight:
                                                          FontWeight.w600,
                                                      decoration: _isSelected
                                                          ? TextDecoration
                                                              .lineThrough
                                                          : TextDecoration.none,
                                                    ),
                                                    maxLines: 1,
                                                    overflow:
                                                        TextOverflow.ellipsis,
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
                                                  color: transactionList[i]
                                                              .transactionType ==
                                                          TransactionType
                                                              .expense
                                                      ? Colors.red
                                                      : Colors.green,
                                                  decoration: _isSelected
                                                      ? TextDecoration
                                                          .lineThrough
                                                      : TextDecoration.none,
                                                ),
                                              ),
                                            );
                                          }),
                                    ],
                                  ),
                                );
                              })
                          : Padding(
                              padding: EdgeInsets.only(top: _size.height * 0.1),
                              child: Text(
                                "You have enough usable balance to meet your goal\n ☺️☺️☺️",
                                textAlign: TextAlign.center,
                                style: GoogleFonts.lato(
                                  fontSize: _size.height * 0.028,
                                ),
                              ),
                            ),
                    ],
                  ),
                );
              }),
        ],
      ),
    );
  }
}
