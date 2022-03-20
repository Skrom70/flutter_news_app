import 'package:flutter/material.dart';

typedef validatorCallback = String? Function(String?);

class SimpleTextFormField extends StatelessWidget {
  const SimpleTextFormField(
      {Key? key,
      required this.labelTextValue,
      required this.valueSetter,
      required this.fieldValidator,
      this.initialValue = null,
      this.obscureText = false})
      : super(key: key);
  final String labelTextValue;
  final Function(String) valueSetter;
  final validatorCallback? fieldValidator;
  final String? initialValue;
  final bool obscureText;

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      obscureText: obscureText,
      initialValue: initialValue,
      onChanged: (value) {
        if (value.isNotEmpty) {
          valueSetter(value);
        }
      },
      onSaved: (value) {
        if (value != null && value.isNotEmpty) {
          valueSetter(value);
        }
      },
      validator: fieldValidator,
      decoration: InputDecoration(
        labelText: labelTextValue,
        contentPadding: EdgeInsets.symmetric(vertical: 22.0, horizontal: 10.0),
        border: OutlineInputBorder(borderRadius: BorderRadius.circular(5.0)),
      ),
    );
  }
}
