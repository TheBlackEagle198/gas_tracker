import 'package:intl/intl.dart';

class MonthData {
  int month;
  double data;

  MonthData({required this.month, required this.data});

  String getLongMonth() {
    return DateFormat('MMMM').format(DateTime(0, month));
  }

  String getShortMonth() {
    return DateFormat('MMMM').format(DateTime(0, month))[0];
  }

  @override
  String toString() => '$month: $data';
}