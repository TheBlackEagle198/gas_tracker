import 'package:flutter/material.dart';

class LogEntryCard extends StatelessWidget {
  final String time;
  final String quantity;
  final String distanceTraveled;
  final String price;
  final String consumption;

  const LogEntryCard(
      {super.key,
        required this.time,
        required this.quantity,
        required this.distanceTraveled,
        required this.price,
        required this.consumption});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 20, vertical: 10),
      margin: EdgeInsets.symmetric(horizontal: 0, vertical: 4),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(16.0),
        color: Color(0xFFDDE7FF),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Padding(
            padding: EdgeInsets.fromLTRB(0, 16, 16, 0),
            child: Icon(
              Icons.circle,
              color: Colors.red,
            ),
          ),
          Container(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  time,
                  style: TextStyle(fontSize: 25, fontWeight: FontWeight.bold),
                ),
                const Divider(
                  height: 5,
                  thickness: 2,
                  color: Colors.black,
                ),
                Row(
                  children: [
                    Icon(Icons.water_drop),
                    SizedBox(
                      width: 10,
                    ),
                    Text("$quantity l"),
                    SizedBox(
                      width: 5,
                    ),
                    Icon(Icons.arrow_right_alt),
                    SizedBox(
                      width: 5,
                    ),
                    Text("$price lei/l")
                  ],
                ),
                Row(children: [
                  Icon(Icons.gas_meter_outlined),
                  SizedBox(
                    width: 10,
                  ),
                  Text("$consumption l/100km")
                ]),
                Row(children: [
                  Icon(Icons.speed),
                  SizedBox(
                    width: 10,
                  ),
                  Text("$distanceTraveled")
                ])
              ],
            ),
          )
        ],
      ),
    );
  }
}