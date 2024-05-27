import 'package:gas_tracker/Models/GasStation.dart';

class LogEntry {
  int? id;
  int mileage = 0;
  double fuelQuantity = 0;
  GasStation gasStation = GasStation.UNKNOWN;
  double total = 0;
  double price = 0;
  late int time; // unix timestamp datetime representation

  LogEntry(
      {this.id,
      required this.mileage,
      required this.fuelQuantity,
      required this.gasStation,
      required this.total,
      required this.price,
      required this.time});

  LogEntry.fromMap(Map<String, dynamic> map) {
    id = map['id'];
    mileage = map['mileage'];
    fuelQuantity = map['fuelQuantity'];
    gasStation = GasStation.values[map['gasStation']];
    total = map['total'];
    price = map['price'];
    time = map['time'];
  }

  Map<String, Object?> toMap() {
    Map<String, Object?> res = {
      'mileage': mileage,
      'fuelQuantity': fuelQuantity,
      'gasStation': gasStation.index,
      'total': total,
      'price': price,
      'time': time
    };

    if (id != null) {
      res['id'] = id;
    }
    return res;
  }

  @override
  String toString() {
    return toMap().toString();
  }

  static Map<int, List<LogEntry>> splitByMonth(List<LogEntry> entries) {
    Map<int, List<LogEntry>> result = {};
    for (int month = 1; month < 13; month++) {
      result[month] = entries
          .where((entry) =>
      DateTime.fromMillisecondsSinceEpoch(entry.time * 1000).month ==
          month)
          .toList();
      if (result[month]!.length == 0) result.remove(month);
    }
    return result;
  }

  static double averageConsumption(List<LogEntry> interval) {
    int currDistance = 0;
    double consumptionSum = 0;
    for (int i = 0; i < interval.length - 1; i++) {
      currDistance = interval[i].mileage - interval[i + 1].mileage;
      consumptionSum += interval[i].fuelQuantity * 100 / currDistance;
    }
    return consumptionSum / (interval.length - 1);
  }
}
