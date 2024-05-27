import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:gas_tracker/Models/GasStation.dart';
import 'package:gas_tracker/widgets/ReceiptForm.dart';

class ConfirmReceiptPage extends StatelessWidget {
  const ConfirmReceiptPage({super.key});

  Map _parseReceipt(String receiptData) {
    log(receiptData);

    final gasPriceExpression = RegExp(r'(\d*) *[.,] *(\d*) *A');
    final quantityPrice1 = RegExp(r'(\d*) *[.,] *(\d*) *[xX] *(\d*) *[.,] *(\d*) *[Ll]');
    final quantityPrice2 = RegExp(r'(\d*) *[.,] *(\d*) *[Ll] *[xX] *(\d*) *[.,] *(\d*)');

    final totalMatch = gasPriceExpression.firstMatch(receiptData);
    double? total = double.tryParse('${totalMatch?.group(1)}.${totalMatch?.group(2)}');

    double? quantity;
    double? price;

    RegExpMatch? match = quantityPrice1.firstMatch(receiptData);
    if (match != null) {
      quantity = double.tryParse('${match.group(3)}.${match.group(4)}');
      price = double.tryParse('${match.group(1)}.${match.group(2)}');
    } else {
      RegExpMatch? match = quantityPrice2.firstMatch(receiptData);
      quantity = double.tryParse('${match?.group(1)}.${match?.group(2)}');
      price = double.tryParse('${match?.group(3)}.${match?.group(4)}');
    }

    GasStation? station;
    String normalizedReceiptData = receiptData.toLowerCase();
    if (normalizedReceiptData.toLowerCase().contains('petrom')) {
      station = GasStation.Petrom;
    } else if (normalizedReceiptData.toLowerCase().contains('rompetrol')) {
      station = GasStation.Rompetrol;
    }
    return {
      'total': total ?? '',
      'quantity': quantity ?? '',
      'price': price ?? '',
      'gasStation': station?.index
    };
  }

  @override
  Widget build(BuildContext context) {
    Map data = _parseReceipt(ModalRoute.of(context)!.settings.arguments as String);

    return Scaffold(
      appBar: AppBar(title: Text("Confirm Receipt")),
      body: ReceiptForm(
        onSubmit: (formData) {
          Navigator.pop(context, {
            'total': double.parse(formData['total']),
            'quantity': double.parse(formData['quantity']),
            'price': double.parse(formData['price']),
            'station': formData['gasStation']
          });
        },
        data: data
      ),
    );
  }
}
