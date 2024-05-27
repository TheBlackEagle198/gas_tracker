import 'package:flutter/material.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';
import 'package:form_builder_validators/form_builder_validators.dart';

class SelectField extends StatelessWidget {
  final String name;
  final String label;
  final List<DropdownOption> options;


  const SelectField({
    super.key,
    required this.name,
    required this.label,
    required this.options
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
        padding: const EdgeInsets.symmetric(vertical: 8.0, horizontal: 20.0),
        child: DropdownButtonHideUnderline (
          child: FormBuilderDropdown(
            name: name,
            isExpanded: true,
            decoration: InputDecoration(
              labelText: label
            ),
            items: options.map((option) => DropdownMenuItem(
              child: Text(option.text),
              value: option.value,
            )).toList(),
            validator: FormBuilderValidators.compose([
              FormBuilderValidators.required()
            ]),
          ),
        )
    );
  }
}

class DropdownOption {
  String text;
  int value;

  DropdownOption({
    required this.text,
    required this.value,
  });
}
