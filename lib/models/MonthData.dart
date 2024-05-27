import 'package:intl/intl.dart';

class MonthData {
  int month;
  double data;

  MonthData({required this.month, required this.data});

  String get longMonth {
    return DateFormat('MMMM').format(DateTime(0, month));
  }

  String get shortMonth {
    return DateFormat('MMMM').format(DateTime(0, month))[0];
  }

  @override
  String toString() => '$month: $data';
}