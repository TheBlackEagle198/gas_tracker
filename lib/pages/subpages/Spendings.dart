import 'package:flutter/material.dart';
import 'package:gas_tracker/models/MonthData.dart';
import 'package:gas_tracker/widgets/MonthBasedBarGraph.dart';

class SpendingsStatistics extends StatelessWidget {
  final List<MonthData> graphData;
  const SpendingsStatistics({
    super.key,
    required this.graphData
  });

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(crossAxisAlignment: CrossAxisAlignment.center, children: [
        const SizedBox(
          height: 80,
        ),
        SizedBox(
            height: 300, width: 300, child: MonthBasedBarGraph(data: graphData))
      ])
    );
  }
}
