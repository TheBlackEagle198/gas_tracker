import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';

class Summary extends StatelessWidget {
  final double spendings;
  final double averageConsumption;
  final int currYear;
  final VoidCallback onSwipeLeft;
  final VoidCallback onSwipeRight;

  const Summary({
    super.key,
    required this.currYear,
    required this.spendings,
    required this.averageConsumption,
    required this.onSwipeLeft,
    required this.onSwipeRight
  });

  @override
  Widget build(BuildContext context) {
    return Dismissible (
      key: const ValueKey<int>(0),
      onDismissed: (a) {},
      confirmDismiss: (direction) async {
        if (direction == DismissDirection.startToEnd) {
          onSwipeLeft();
        } else {
          onSwipeRight();
        }
        return false;
      },
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Text(
            "Summary $currYear",
            style: TextStyle(
              fontSize: 30,
              fontWeight: FontWeight.bold
            ),
          ),
          SizedBox(height: 5,),
          SizedBox(
            width: 250,
            child: IntrinsicHeight(
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Expanded(
                    child: Column(
                      children: [
                        Text(
                          spendings.toStringAsFixed(2),
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 17
                          ),
                        ),
                        Text(
                          'COST',
                          style: TextStyle(
                            color: Colors.grey[500],
                            fontSize: 14
                          ),
                        )
                      ],
                    ),
                  ),
                  VerticalDivider(
                    color: Colors.grey[300],
                    thickness: 2,
                    width: 30,

                  ),
                  Expanded(
                    child: Column(
                      children: [
                        Text(
                          '${averageConsumption.toStringAsFixed(2)} l/100km',
                          style: TextStyle(
                              fontWeight: FontWeight.bold,
                              fontSize: 17
                          ),
                        ),
                        Text(
                          'CONSUMPTION',
                          style: TextStyle(
                              color: Colors.grey[500],
                              fontSize: 14
                          )
                        )
                      ],
                    ),
                  )
                ],
              ),
            ),
          )
        ]
      )
    );
  }
}
