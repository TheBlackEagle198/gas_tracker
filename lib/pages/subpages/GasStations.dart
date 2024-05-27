import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:gas_tracker/models/Station.dart';
import 'package:gas_tracker/widgets/Indicator.dart';

class GasStationStatistics extends StatefulWidget {
  final List<Station> stations;

  const GasStationStatistics({
    super.key,
    required this.stations
  });

  @override
  State<StatefulWidget> createState() => _GasStationStatisticsState();
}

class _GasStationStatisticsState extends State<GasStationStatistics> {
  int touchedIndex = -1;
  late List<Station> stations;

  @override
  void initState() {
    super.initState();
    stations = widget.stations;
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: <Widget>[
        const SizedBox(
          height: 18,
        ),
        Expanded(
          child: Center(
            child: AspectRatio(
              aspectRatio: 1,
              child: PieChart(
                PieChartData(
                  pieTouchData: PieTouchData(
                    touchCallback: (FlTouchEvent event, pieTouchResponse) {
                      setState(() {
                        if (!event.isInterestedForInteractions ||
                            pieTouchResponse == null ||
                            pieTouchResponse.touchedSection == null) {
                          touchedIndex = -1;
                          return;
                        }
                        touchedIndex = pieTouchResponse
                            .touchedSection!.touchedSectionIndex;
                      });
                    },
                  ),
                  borderData: FlBorderData(
                    show: false,
                  ),
                  sectionsSpace: 0,
                  centerSpaceRadius: 40,
                  sections: showingSections(),
                ),
              ),
            ),
          ),
        ),
        Expanded(
          child: Padding (
            padding: EdgeInsets.symmetric(vertical: 10, horizontal: 50),
            child: Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.end,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  Expanded (
                    child: ListView.builder(
                      itemCount: stations.length,
                      itemBuilder: (context, index) => Indicator (
                        count: stations[index].count,
                        color: stations[index].color,
                        text: stations[index].title,
                        isSquare: false,
                      )
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
        const SizedBox(
          width: 28,
        ),
      ],
    );
  }

  List<PieChartSectionData> showingSections() {
    return List.generate(stations.length, (i) {
      final isTouched = i == touchedIndex;
      final fontSize = isTouched ? 25.0 : 16.0;
      final radius = isTouched ? 60.0 : 50.0;
      const shadows = [Shadow(color: Colors.black, blurRadius: 1)];
      Station currStation = stations[i];
      return PieChartSectionData(
        color: currStation.color,
        value: currStation.count.toDouble(),
        title: currStation.count.toString(),
        radius: radius,
        titleStyle: TextStyle(
          fontSize: fontSize,
          fontWeight: FontWeight.bold,
          color: Colors.white,
          shadows: shadows
        )

      );
    });
  }
}