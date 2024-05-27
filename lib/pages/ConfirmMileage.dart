import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:gas_tracker/widgets/MileageForm.dart';
import 'package:gas_tracker/widgets/ReceiptForm.dart';

class ConfirmMileagePage extends StatelessWidget {
  const ConfirmMileagePage({super.key});

  Map _parseReceipt(String receiptData) {
    String mileageString = '${RegExp(r'\d+').firstMatch(receiptData)?.group(0) ?? 0}';
    int mileage = (int.tryParse(mileageString) ?? 1) ~/ 10; // get rid of the last number
    return {
      'mileage': mileage > 0 ? mileage : ''
    };
  }

  @override
  Widget build(BuildContext context) {
    Map data = _parseReceipt(ModalRoute.of(context)!.settings.arguments as String);

    return Scaffold(
      appBar: AppBar(title: Text("Confirm Mileage")),
      body: MileageForm(
          onSubmit: (formData) {
            Navigator.pop(context, {'mileage': int.parse(formData['mileage'])});
          },
          data: data
      ),
    );
  }
}
