import 'dart:developer';

import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';

import '../Models/LogEntry.dart';

class LogEntryService {
  static const int _version = 1;
  static const String _dbName = "gas_tracker.db";
  static const String _table = "LOG_ENTRY";

  static Future<Database> _getDb() async {
    // time will be stored as ISO8601 text
    return openDatabase(
      join(await getDatabasesPath(), _dbName),
      onCreate: (db, version) async {
        await db.execute("CREATE TABLE $_table (id INTEGER PRIMARY KEY AUTOINCREMENT, mileage INTEGER, fuelQuantity REAL, total REAL, price REAL, gasStation INTEGER, time INTEGER)");
        await db.execute("INSERT INTO $_table (mileage, fuelQuantity, total, price, gasStation, time) VALUES (223, 11.64, 77.47, 6.65, 1, 1682542800)");
        await db.execute("INSERT INTO $_table (mileage, fuelQuantity, total, price, gasStation, time) VALUES (213, 10.72, 70.22, 6.55, 1, 1683061200)");
        await db.execute("INSERT INTO $_table (mileage, fuelQuantity, total, price, gasStation, time) VALUES (206, 10.76, 68.82, 6.39, 1, 1683838800)");
        await db.execute("INSERT INTO $_table (mileage, fuelQuantity, total, price, gasStation, time) VALUES (217, 10.13, 64.53, 6.37, 2, 1684270800)");
        await db.execute("INSERT INTO $_table (mileage, fuelQuantity, total, price, gasStation, time) VALUES (222, 9.97, 63.81, 6.4, 2, 1684875600)");
        await db.execute("INSERT INTO $_table (mileage, fuelQuantity, total, price, gasStation, time) VALUES (225, 12.19, 79.24, 6.5, 2, 1685653200)");
        await db.execute("INSERT INTO $_table (mileage, fuelQuantity, total, price, gasStation, time) VALUES (238, 9.53, 62.33, 6.54, 1, 1686171600)");
        await db.execute("INSERT INTO $_table (mileage, fuelQuantity, total, price, gasStation, time) VALUES (216, 9.16, 62.08, 6.77, 1, 1686949200)");
        await db.execute("INSERT INTO $_table (mileage, fuelQuantity, total, price, gasStation, time) VALUES (228, 9.76, 64.49, 6.71, 1, 1687640400)");
        await db.execute("INSERT INTO $_table (mileage, fuelQuantity, total, price, gasStation, time) VALUES (225, 9.61, 65.03, 6.76, 2, 1688331600)");
        await db.execute("INSERT INTO $_table (mileage, fuelQuantity, total, price, gasStation, time) VALUES (203, 9.59, 65.66, 6.84, 1, 1690491600)");
        await db.execute("INSERT INTO $_table (mileage, fuelQuantity, total, price, gasStation, time) VALUES (128, 11.42, 79.1, 6.92, 1, 1691442000)");
        await db.execute("INSERT INTO $_table (mileage, fuelQuantity, total, price, gasStation, time) VALUES (207, 10.21, 73.58, 7.2, 1, 1691787600)");
        await db.execute("INSERT INTO $_table (mileage, fuelQuantity, total, price, gasStation, time) VALUES (197, 9.14, 66.54, 7.28, 2, 1692997200)");
        await db.execute("INSERT INTO $_table (mileage, fuelQuantity, total, price, gasStation, time) VALUES (214, 9.52, 69.85, 7.33, 1, 1694552400)");
      },
      version: _version
    );
  }

  static Future<int> add(LogEntry entry) async {
    final db = await _getDb();
    return await db.insert(_table, entry.toMap());
  }

  static Future<List<LogEntry>?> getAll() async {
    final db = await _getDb();
    final result = await db.query(_table);

    if (result.isEmpty) {
      return null;
    }
    return result.map((e) => LogEntry.fromMap(e)).toList();
  }

  static Future<List<LogEntry>?> getAllByYear(int year) async {
    final db = await _getDb();
    final yearSeconds = DateTime(year).millisecondsSinceEpoch ~/ 1000;
    final prevYearSeconds = DateTime(year - 1).millisecondsSinceEpoch ~/ 1000;
    final results = await db.query(
      _table,
      where: 'time < ? AND time > ?',
      whereArgs: [yearSeconds, prevYearSeconds]
    );

    if (results.isEmpty) {
      return null;
    }

    return results.map((e) => LogEntry.fromMap(e)).toList();
  }

  static void reset() async {
    deleteDatabase(join(await getDatabasesPath(), _dbName));
  }
}
