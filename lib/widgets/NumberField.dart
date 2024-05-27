import 'package:flutter/material.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';
import 'package:form_builder_validators/form_builder_validators.dart';

class NumberField extends StatelessWidget {
  final String defaultValue;
  final String label;
  final String name;

  const NumberField({super.key, required this.defaultValue, required this.label, required this.name});

  @override
  Widget build(BuildContext context) {
    return Padding(
        padding: const EdgeInsets.symmetric(vertical: 8.0, horizontal: 20.0),
        child: FormBuilderTextField (
          name: name,
          cursorColor: Color(0xFF2355D6),
          controller: TextEditingController(text: defaultValue),
          keyboardType: TextInputType.number,
          decoration: InputDecoration(
              border: const OutlineInputBorder(),
              labelText: label
          ),
          validator: FormBuilderValidators.compose([
            FormBuilderValidators.required(),
            FormBuilderValidators.numeric()
          ]),
        )
    );
  }
}