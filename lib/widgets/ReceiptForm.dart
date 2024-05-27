import 'package:flutter/material.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';
import 'package:gas_tracker/models/GasStation.dart';

import 'NumberField.dart';
import 'SelectField.dart';

class ReceiptForm extends StatefulWidget {
  final void Function(Map) onSubmit;
  final Map data;
  const ReceiptForm({super.key, required this.onSubmit, required this.data});

  @override
  State<ReceiptForm> createState() => _ReceiptFormState();
}

class _ReceiptFormState extends State<ReceiptForm> {
  final _formKey = GlobalKey<FormBuilderState>();

  @override
  Widget build(BuildContext context) {
    return FormBuilder(
      key: _formKey,
      child: Column(
        children: <Widget>[
          NumberField(name: 'total', defaultValue: widget.data['total'].toString(), label: 'Total',),
          NumberField(name: 'quantity', defaultValue: widget.data['quantity'].toString(), label: 'Fuel Quantity',),
          NumberField(name: 'price', defaultValue: widget.data['price'].toString(), label: 'Price/l',),
          SelectField(name: 'gasStation', label: "Gas station",
            initialValue: widget.data['gasStation'],
              options: [
            DropdownOption(text: "Rompetrol", value: GasStation.Rompetrol.index),
            DropdownOption(text: "Petrom", value: GasStation.Petrom.index)
          ],),
          FloatingActionButton(onPressed: () {
            _formKey.currentState?.saveAndValidate();
            widget.onSubmit(_formKey.currentState!.value);
            },
            child: Icon(Icons.check, color: Colors.white,),
            shape: CircleBorder(),
            backgroundColor: Color(0xFF2355D6),
          )
        ],
      )
    );
  }
}