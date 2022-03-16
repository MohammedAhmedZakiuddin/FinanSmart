import 'package:cloud_firestore/cloud_firestore.dart' as fs;
import 'package:date_time_picker/date_time_picker.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:theme_provider/theme_provider.dart';
import 'package:uchiha_saving/models/person.dart';
import 'package:uchiha_saving/models/transaction.dart';
import 'package:uchiha_saving/uis/pie_chart_ui/pie_chart_bloc.dart';
import 'package:uchiha_saving/uis/pie_chart_ui/pie_chart_by_category.dart';
import 'package:uchiha_saving/uis/pie_chart_ui/pie_chart_by_priority.dart';

class PieChartUI extends StatefulWidget {
  final Person person;
  const PieChartUI({Key? key, required this.person}) : super(key: key);

  @override
  _PieChartUIState createState() => _PieChartUIState();
}

class _PieChartUIState extends State<PieChartUI> {
  int _index = 0;

  DateTime start = DateTime(DateTime.now().year, DateTime.now().month);
  DateTime end = DateTime.now();

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      initialIndex: _index,
      length: 2,
      child: Scaffold(
        body: CustomScrollView(
          slivers: [
            SliverAppBar(
              pinned: true,
              title: Text("Pie Chart"),
              backgroundColor: Colors.transparent,
              foregroundColor:
                  ThemeProvider.controllerOf(context).currentThemeId == "dark"
                      ? Colors.white
                      : Colors.black,
              bottom: TabBar(
                  onTap: (index) {
                    setState(() {
                      _index = index;
                    });
                  },
                  tabs: [
                    Tab(
                      child: Text(
                        "Category",
                        style: GoogleFonts.lato(
                          color: ThemeProvider.controllerOf(context)
                                      .currentThemeId ==
                                  "dark"
                              ? Colors.white
                              : Colors.black,
                        ),
                      ),
                      icon: Icon(
                        Icons.category,
                        color: ThemeProvider.controllerOf(context)
                                    .currentThemeId ==
                                "dark"
                            ? Colors.white
                            : Colors.black,
                      ),
                      iconMargin:
                          EdgeInsets.only(bottom: 10.0), // default margin
                    ),
                    Tab(
                      child: Text(
                        "Priority",
                        style: GoogleFonts.lato(
                          color: ThemeProvider.controllerOf(context)
                                      .currentThemeId ==
                                  "dark"
                              ? Colors.white
                              : Colors.black,
                        ),
                      ),
                      icon: Icon(
                        Icons.format_list_numbered,
                        color: ThemeProvider.controllerOf(context)
                                    .currentThemeId ==
                                "dark"
                            ? Colors.white
                            : Colors.black,
                      ),
                      iconMargin:
                          EdgeInsets.only(bottom: 10.0), // default margin
                    ),
                  ]),
            ),
            SliverToBoxAdapter(
              child: Padding(
                padding: EdgeInsets.symmetric(horizontal: 8.0, vertical: 20),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Flexible(
                      child: DateTimePicker(
                        type: DateTimePickerType.date,
                        dateMask: 'd MMM, yyyy',
                        initialValue:
                            DateTime(DateTime.now().year, DateTime.now().month)
                                .toString(),
                        firstDate: DateTime(2000),
                        lastDate: DateTime.now(),
                        icon: Icon(Icons.event),
                        decoration: InputDecoration(
                          border: OutlineInputBorder(),
                          label: Text("Start Date"),
                        ),
                        onChanged: (val) {
                          setState(() {
                            start = DateTime.tryParse(val)!;
                          });
                        },
                        validator: (val) {
                          return null;
                        },
                        onSaved: (val) {
                          setState(() {
                            start = DateTime.tryParse(val!)!;
                          });
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
                        initialValue: DateTime.now().toString(),
                        firstDate: DateTime(2000),
                        lastDate: DateTime.now(),
                        icon: Icon(Icons.event),
                        onChanged: (val) {
                          setState(() {
                            end = DateTime.tryParse(val)!;
                          });
                        },
                        onSaved: (val) {
                          setState(() {
                            end = DateTime.tryParse(val!)!;
                          });
                        },
                        validator: (val) {
                          return null;
                        },
                      ),
                    ),
                  ],
                ),
              ),
            ),
            StreamBuilder<fs.QuerySnapshot>(
                stream: fs.FirebaseFirestore.instance
                    .collection("Transactions")
                    .doc(widget.person.id)
                    .collection("Transactions")
                    .where("createdAt",
                        isGreaterThanOrEqualTo: fs.Timestamp.fromDate(start))
                    .where("createdAt",
                        isLessThanOrEqualTo: fs.Timestamp.fromDate(
                            DateTime(end.year, end.month, end.day + 1)))
                    .snapshots(),
                builder: (context, snapshot) {
                  if (!snapshot.hasData) {
                    return SliverToBoxAdapter();
                  } else {
                    List<Transaction> _list = snapshot.data!.docs
                        .map((e) => Transaction.fromDynamic(e.data()))
                        .toList();
                    _list = _list
                        .where(
                            (e) => e.transactionType == TransactionType.expense)
                        .toList();
                    return SliverToBoxAdapter(
                        child: _index == 0
                            ? PieChartByCategory(
                                list: PieChartBloc().getListByCategory(_list),
                                key: widget.key,
                              )
                            : PieChartByPriority(
                                list: PieChartBloc().getListByPriority(_list)));
                  }
                })
          ],
        ),
      ),
    );
  }
}
