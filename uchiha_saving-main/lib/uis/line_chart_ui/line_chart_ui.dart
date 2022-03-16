import 'dart:async';

import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:syncfusion_flutter_charts/charts.dart';
import 'package:theme_provider/theme_provider.dart';
import 'package:uchiha_saving/models/person.dart';
import 'package:month_picker_dialog/month_picker_dialog.dart';
import 'package:uchiha_saving/models/transaction.dart';
import 'package:cloud_firestore/cloud_firestore.dart' as fs;
import 'package:uchiha_saving/uis/line_chart_ui/line_chart_bloc.dart';
import 'package:uchiha_saving/uis/line_chart_ui/line_chart_repo.dart';

class LineChartUI extends StatefulWidget {
  final Person person;
  const LineChartUI({Key? key, required this.person}) : super(key: key);

  @override
  _LineChartUIState createState() => _LineChartUIState();
}

class _LineChartUIState extends State<LineChartUI> {
  TextEditingController _firstController = TextEditingController();

  LineChartBloc _bloc = LineChartBloc();

  DateTime _date = DateTime(DateTime.now().year, DateTime.now().month, 1);

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    setState(() {
      _firstController.text = DateFormat("MMMM, y").format(_date);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: StreamBuilder<DateTime>(
            initialData: _date,
            stream: _bloc.stream,
            builder: (context, snapshot) {
              return CustomScrollView(
                slivers: [
                  SliverAppBar(
                    pinned: true,
                    title: Text("Line Graph"),
                    backgroundColor: Colors.transparent,
                    foregroundColor:
                        ThemeProvider.controllerOf(context).currentThemeId ==
                                "dark"
                            ? Colors.white
                            : Colors.black,
                  ),
                  SliverToBoxAdapter(
                    child: Padding(
                      padding:
                          EdgeInsets.symmetric(horizontal: 8.0, vertical: 20),
                      child: Flexible(
                          child: TextFormField(
                        controller: _firstController,
                        readOnly: true,
                        style: TextStyle(fontSize: 13.0),
                        decoration: InputDecoration(
                          hintStyle: TextStyle(fontSize: 13.0),
                          hintText: 'Pick Month',
                          contentPadding:
                              EdgeInsets.symmetric(horizontal: 10.0),
                          border: OutlineInputBorder(),
                          suffixIcon: Icon(Icons.calendar_today),
                        ),
                        onTap: () {
                          showMonthPicker(
                            context: context,
                            firstDate: DateTime(2000),
                            lastDate: DateTime(
                                DateTime.now().year, DateTime.now().month),
                            initialDate: snapshot.data!,
                            locale: Locale("en"),
                          ).then((date) async {
                            _bloc.update(dateTime: date!);
                            setState(() {
                              _date = date;
                              _firstController.text =
                                  DateFormat("MMMM, y").format(date);
                            });
                          });
                        },
                      )),
                    ),
                  ),
                  SliverToBoxAdapter(
                    child: StreamBuilder<fs.QuerySnapshot>(
                        stream: fs.FirebaseFirestore.instance
                            .collection("Transactions")
                            .doc(widget.person.id)
                            .collection("Transactions")
                            .snapshots(),
                        builder: (context, snapshot) {
                          if (!snapshot.hasData) {
                            return Center();
                          }
                          List<Map<String, dynamic>> finalList = LineChartRepo()
                              .getList(
                                  _date,
                                  snapshot.data!.docs
                                      .map((e) => Transaction.fromDynamic(e))
                                      .toList());
                          return SfCartesianChart(
                            primaryXAxis: CategoryAxis(),
                            // Chart title
                            title: ChartTitle(
                                text: DateFormat("MMMM").format(_date)),
                            // Enable legend
                            legend: Legend(
                              isVisible: true,
                              position: LegendPosition.top,
                            ),
                            // Enable tooltip
                            tooltipBehavior: TooltipBehavior(enable: true),
                            series: <ChartSeries<Map<String, dynamic>, String>>[
                              LineSeries<Map<String, dynamic>, String>(
                                  dataSource: snapshot.data!.docs.isEmpty
                                      ? []
                                      : finalList,
                                  xValueMapper:
                                      (Map<String, dynamic> transaction, _) =>
                                          transaction["day"].toString(),
                                  yValueMapper:
                                      (Map<String, dynamic> transaction, _) =>
                                          transaction["amount"],
                                  name: "Amount in Dollars (\$)",
                                  // Enable data label
                                  dataLabelSettings:
                                      DataLabelSettings(isVisible: true)),
                            ],
                          );
                        }),
                  ),
                ],
              );
            }));
  }
}
