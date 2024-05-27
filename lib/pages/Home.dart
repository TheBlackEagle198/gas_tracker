import 'dart:developer';
import 'package:flutter/material.dart';
import 'package:gas_tracker/Models/LogEntry.dart';
import 'package:gas_tracker/pages/Statistics.dart';
import 'package:gas_tracker/services/log_entry_service.dart';
import 'package:gas_tracker/widgets/LogEntryCard.dart';
import 'package:gas_tracker/widgets/Summary.dart';
import 'package:intl/intl.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  late Future<List<LogEntry>?> _entries;

  double _totalSpent = 0;
  double _averageConsumption = 0;
  int _currentIndex = 0;
  int _currentYear = DateTime.now().year;

  void deleteEntry(LogEntry entry) async {
    LogEntryService.delete(entry);
    setState(() {
      _entries = LogEntryService.getAllByYear(_currentYear);
    });
  }

  @override
  void initState() {
    super.initState();
    _entries = LogEntryService.getAllByYear(_currentYear);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        bottomNavigationBar: BottomNavigationBar(
          currentIndex: _currentIndex,
          onTap: (newIndex) {
            setState(() {
              _currentIndex = newIndex;
            });
          },
          selectedItemColor: Color(0xFF2355D6),
          items: [
            BottomNavigationBarItem(icon: Icon(Icons.home), label: 'Home'),
            BottomNavigationBarItem(icon: Icon(Icons.auto_graph), label: 'Statistics'),
          ],
        ),
        floatingActionButton: FloatingActionButton(
          child: Icon(
            Icons.add,
            color: Colors.white,
          ),
          backgroundColor: Color(0xFF2355D6),
          shape: const CircleBorder(),
          onPressed: () async {
            try {
              LogEntry newEntry =
                  await Navigator.pushNamed(context, 'cameraPage') as LogEntry;
              log("Adding ${newEntry.toMap().toString()}");
              await LogEntryService.add(newEntry);
              log("Added ${newEntry.toMap().toString()}");
              setState(() {
                _entries = LogEntryService.getAllByYear(_currentYear);
              });
            } catch (e) {
              log(e.toString());
            }
          },
        ),
        body: SafeArea(
          child: FutureBuilder(
            future: _entries,
            builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.waiting) {
                return const CircularProgressIndicator();
              } else {
                if (snapshot.hasError) {
                  return Text(snapshot.error.toString());
                } else if (snapshot.hasData) {
                  if (snapshot.data != null) {
                    final items = snapshot.data!.reversed.toList();

                    if (_currentIndex == 1) {
                      return StatisticsPage(entries: items);
                    }

                    _totalSpent = items.fold(
                        0.0, (previousVal, item) => previousVal + item.total);
                    _averageConsumption = LogEntry.averageConsumption(items);

                    return Column(
                      children: [
                        Summary(
                          currYear: _currentYear,
                          spendings: _totalSpent,
                          averageConsumption: _averageConsumption,
                          onSwipeLeft: () {
                            setState(() {
                              _currentYear -= 1;
                              _entries = LogEntryService.getAllByYear(_currentYear);
                            });
                          },
                          onSwipeRight: () {
                            setState(() {
                              _currentYear += 1;
                              _entries = LogEntryService.getAllByYear(_currentYear);
                            });
                          }
                        ),
                        Expanded(
                          child: Padding(
                            padding: const EdgeInsets.all(35.0),
                            child: ListView.builder(
                              itemBuilder: (context, index) {
                                final consumption = items[index].fuelQuantity * 100 / items[index].mileage;
                                log(items[index].toMap().toString());

                                return LogEntryCard(
                                  onLongPress: () async {
                                    showDialog(
                                        context: context,
                                        builder: (context) {
                                          return AlertDialog(
                                            title: const Text("Are you sure you want to delete this entry?"),
                                            actionsAlignment: MainAxisAlignment.spaceAround,
                                            backgroundColor: Color(0xFFDDE7FF),
                                            actions: [
                                              ElevatedButton(
                                                  onPressed: () {
                                                    deleteEntry(items[index]);
                                                    Navigator.pop(context);
                                                  },
                                                  style: ButtonStyle(
                                                    backgroundColor: MaterialStateProperty.all<Color>(Color(0xFF2355D6)),
                                                    foregroundColor: MaterialStateProperty.all<Color>(Colors.white),
                                                  ),
                                                  child: Text("Yes")
                                              ),
                                              OutlinedButton (
                                                  onPressed: () {
                                                    Navigator.pop(context);
                                                  },
                                                  style: ButtonStyle (
                                                    foregroundColor: MaterialStateProperty.all<Color>(Color(0xFF2355D6)),
                                                    side: MaterialStateProperty.all<BorderSide>(BorderSide(color: Color(0xFF2355D6)))
                                                  ),
                                                  child: Text("No"))
                                            ],
                                          );
                                        }
                                    );
                                  },
                                  time: DateFormat('EEEE, d').format(
                                      DateTime.fromMillisecondsSinceEpoch(
                                          items[index].time * 1000)),
                                  quantity: items[index].fuelQuantity.toStringAsFixed(1),
                                  distanceTraveled: items[index].mileage.toString(),
                                  price: items[index].price.toStringAsFixed(2),
                                  consumption: consumption.toStringAsFixed(2),
                                );
                              },
                              itemCount: items.length,
                            ),
                          )
                        )
                      ],
                    );
                  }
                } else {
                  return Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Summary(
                          currYear: _currentYear,
                          spendings: 0,
                          averageConsumption: 0,
                          onSwipeLeft: () {
                            setState(() {
                              _currentYear -= 1;
                              _entries = LogEntryService.getAllByYear(_currentYear);
                            });
                          },
                          onSwipeRight: () {
                            setState(() {
                              _currentYear += 1;
                              _entries = LogEntryService.getAllByYear(_currentYear);
                            });
                          }
                      ),
                    ],
                  );
                }
              }
              return Center(child: const Icon(Icons.cancel_outlined, color: Colors.red,));
            },
          ),
        ));
  }
}
