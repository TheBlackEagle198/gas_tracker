import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:gas_tracker/models/MonthData.dart';

class MonthBasedBarGraph<T extends num> extends StatelessWidget {

  final List<MonthData> data;

  MonthBasedBarGraph({
    super.key,
    required this.data
  });

  @override
  Widget build(BuildContext context) {

    return BarChart(
        BarChartData(
            maxY: data.fold(0.0, (oldVal, monthData) =>
            oldVal! > monthData.data ? oldVal : monthData.data),
            minY: 0,
            gridData: FlGridData(show: false),
            borderData: FlBorderData(show: false),
            barTouchData: BarTouchData(touchTooltipData: BarTouchTooltipData(
                getTooltipItem: (group, groupIndex, rod, rodIndex) {
                  String text = '${data[groupIndex].longMonth}\n${data[groupIndex].data.toStringAsFixed(2)}';
                  return BarTooltipItem(
                      text,
                      TextStyle(color: Colors.white)
                  );
                }
            )),
            titlesData: FlTitlesData(
                show: true,
                topTitles: AxisTitles(sideTitles: SideTitles(showTitles: false)),
                leftTitles: AxisTitles(sideTitles: SideTitles(showTitles: false)),
                rightTitles: AxisTitles(sideTitles: SideTitles(showTitles: false)),
                bottomTitles: AxisTitles(
                    sideTitles: SideTitles(
                        showTitles: true,
                        getTitlesWidget: getBottomTitles
                    )
                )
            ),
            barGroups: List.generate(data.length, (index) => BarChartGroupData(
                x: index,
                barRods: [
                  BarChartRodData(
                      width: 15,
                      borderRadius: BorderRadius.vertical(top: Radius.circular(5), bottom: Radius.circular(10)),
                      toY: data[index].data
                  )
                ]
            )
            )
        )
    );
  }

  Widget getBottomTitles(double value, TitleMeta meta) {
    Widget text;
    text = Text(
      data[value.toInt()].shortMonth,
      style: TextStyle(fontWeight: FontWeight.bold, fontSize: 13),
    );
    return SideTitleWidget(child: text, axisSide: meta.axisSide);
  }
}