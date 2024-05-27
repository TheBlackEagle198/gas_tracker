import 'dart:developer';
import 'dart:math' as math;

import 'package:flutter/material.dart';
import 'package:gas_tracker/Models/GasStation.dart';
import 'package:gas_tracker/Models/LogEntry.dart';
import 'package:gas_tracker/models/MonthData.dart';
import 'package:gas_tracker/models/Station.dart';
import 'package:gas_tracker/pages/subpages/Consumption.dart';
import 'package:gas_tracker/pages/subpages/Spendings.dart';
import 'package:gas_tracker/pages/subpages/GasStations.dart';

class StatisticsPage extends StatefulWidget {
  final List<LogEntry>? entries;

  const StatisticsPage({
    super.key,
    this.entries
  });

  @override
  State<StatisticsPage> createState() => _StatisticsPageState();
}

class _StatisticsPageState extends State<StatisticsPage> {
  int _subPageNum = 0;
  List<LogEntry>? entries;
  late List<SubPage> subPages;

  List<Station> _getStations() {
    Map<GasStation, int> distinctStations = {};
    for (LogEntry entry in entries!) {
      distinctStations[entry.gasStation] = (distinctStations[entry.gasStation] ?? 0) + 1;
    }

    return distinctStations.entries
        .map((entry) =>
          Station(title: getGasStationName(entry.key), color: getRandomColor(), count: entry.value))
        .toList();
  }

  Color getRandomColor() {
    List<Color> list = [
      Colors.yellow,
      Colors.red,
      Colors.green,
      Colors.blue,
      Colors.purple
    ];
    return list[math.Random().nextInt(list.length)];
  }

  String getGasStationName(GasStation station) {
    String res;
    switch (station) {
      case GasStation.Petrom:
        res = "Petrom";
        break;
      case GasStation.Rompetrol:
        res = "Rompetrol";
        break;
      default:
        res = "";
    }
    return res;
  }

  List<MonthData> _getSpendings() {
    return LogEntry.splitByMonth(entries!)
        .entries
        .map((mapEntry) => MonthData(
            month: mapEntry.key,
            data: mapEntry.value.fold(0.0,
                (previousValue, element) => previousValue + element.total)))
        .toList();
  }

  List<MonthData> _getConsumption() {
    return LogEntry.splitByMonth(entries!).entries
        .map((entry) =>
              MonthData(
                month: entry.key,
                data: double.parse(
                    LogEntry.averageConsumption(entry.value).toStringAsFixed(2)
                )
              )
        ).toList();
  }

  @override
  void initState() {
    super.initState();
    entries = widget.entries;
    if (entries == null) return;
    subPages = <SubPage>[
      SubPage(
          body: GasStationStatistics(stations: _getStations()),
          title: "Gas stations"),
      SubPage(
          body: SpendingsStatistics(
            graphData: _getSpendings(),
          ),
          title: "Spendings"),
      SubPage(body: ConsumptionStatistics(graphData: _getConsumption()), title: "Consumption")
    ];
  }

  @override
  Widget build(BuildContext context) {
    if (entries == null) {
      return const Center(child: Text("No data to show!"));
    }

    var tabs = subPages.map((e) => e.tab).toList();
    return DefaultTabController(
        length: tabs.length,
        initialIndex: 0,
        child: Scaffold(
            appBar: AppBar(
              title: Text("Statistics"),
              bottom: TabBar(
                tabs: tabs,
                indicatorColor: Color(0xFF2355D6),
                labelColor: Color(0xFF2355D6),
                onTap: (value) {
                  setState(() {
                    _subPageNum = value;
                  });
                },
              ),
            ),
            body: subPages[_subPageNum].body));
  }
}

class SubPage {
  final Widget body;
  final String title;
  late Tab tab;

  SubPage({required this.body, required this.title}) {
    tab = Tab(
      text: title,
    );
  }
}
