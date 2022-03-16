import 'package:flutter/material.dart';
import 'package:syncfusion_flutter_charts/charts.dart';
import 'package:month_picker_dialog/month_picker_dialog.dart';

class PieChartByPriority extends StatefulWidget {
  final List<Map<String, dynamic>> list;

  const PieChartByPriority({Key? key, required this.list}) : super(key: key);

  @override
  _PieChartByPriorityState createState() => _PieChartByPriorityState();
}

class _PieChartByPriorityState extends State<PieChartByPriority> {
  @override
  Widget build(BuildContext context) {
    return SfCircularChart(
      title: ChartTitle(text: 'Priority Pie Chart'),
      legend: Legend(
        isVisible: true,
        overflowMode: LegendItemOverflowMode.wrap,
        position: LegendPosition.top,
        isResponsive: true,
      ),
      series: <CircularSeries>[
        PieSeries<Map<String, dynamic>, String>(
          dataSource: widget.list,
          enableTooltip: true,
          xValueMapper: (Map<String, dynamic> data, _) => data["priority"],
          yValueMapper: (Map<String, dynamic> data, _) => data["percentage"],
          dataLabelMapper: (Map<String, dynamic> newlist, index) =>
              widget.list[index]["priority"] +
              "\n" +
              "${widget.list[index]["percentage"]}" +
              " %",
          animationDuration: 500.0,
          animationDelay: 500.0,
          dataLabelSettings: DataLabelSettings(
            isVisible: true,
            textStyle: TextStyle(
              fontSize: MediaQuery.of(context).size.height * 0.0185,
            ),
          ),
        ),
      ],
    );
  }
}
