import 'package:flutter/material.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';

import 'NumberField.dart';

class MileageForm extends StatefulWidget {
  final void Function(Map) onSubmit;
  final Map data;
  const MileageForm({super.key, required this.onSubmit, required this.data});

  @override
  State<MileageForm> createState() => _MileageFormState();
}

class _MileageFormState extends State<MileageForm> {
  final _formKey = GlobalKey<FormBuilderState>();

  @override
  Widget build(BuildContext context) {
    return FormBuilder(
        key: _formKey,
        child: Column(
          children: <Widget>[
            NumberField(name: 'mileage', defaultValue: widget.data['mileage'].toString(), label: 'Mileage',),
            FloatingActionButton(
              onPressed: () {
                _formKey.currentState?.saveAndValidate();
                widget.onSubmit(_formKey.currentState!.value);
              },
              child: Icon(Icons.check, color: Colors.white,),
              shape: CircleBorder(),
              backgroundColor: Color(0xFF2355D6),)
          ],
        )
    );
  }
}