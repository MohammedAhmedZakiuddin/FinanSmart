import 'package:syncfusion_flutter_charts/charts.dart';
import 'package:flutter/material.dart';

class PieChartByCategory extends StatefulWidget {
  final List<Map<String, dynamic>> list;
  const PieChartByCategory({Key? key, required this.list}) : super(key: key);

  @override
  State<PieChartByCategory> createState() => _PieChartByCategoryState();
}

class _PieChartByCategoryState extends State<PieChartByCategory> {
  String text = "";
  @override
  Widget build(BuildContext context) {
    return SfCircularChart(
      title: ChartTitle(text: 'Category Pie Chart'),
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
          dataLabelMapper: (Map<String, dynamic> newlist, index) =>
              widget.list[index]["category"] +
              "\n" +
              "${widget.list[index]["percentage"]}" +
              " %",
          onPointTap: (val) {
            setState(() {
              text = widget.list[val.pointIndex!]["category"];
            });
          },
          xValueMapper: (Map<String, dynamic> newlist, _) =>
              newlist["category"],
          yValueMapper: (Map<String, dynamic> newlist, _) =>
              double.parse(newlist["percentage"]),
          animationDuration: 500.0,
          animationDelay: 500.0,
          dataLabelSettings: DataLabelSettings(
            isVisible: true,
            textStyle: TextStyle(
              fontSize: MediaQuery.of(context).size.height * 0.018,
            ),
          ),
        ),
      ],
    );
  }
}
