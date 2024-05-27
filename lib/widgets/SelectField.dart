import 'package:flutter/material.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';

class SelectField extends StatelessWidget {
  final DropdownOption defaultOption;
  final String name;
  final List<DropdownOption> options;

  const SelectField({
    super.key,
    required this.defaultOption,
    required this.name,
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
            items: options.map((option) => DropdownMenuItem(
              child: Text(option.text),
              value: option.value,
            )).toList(),
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
