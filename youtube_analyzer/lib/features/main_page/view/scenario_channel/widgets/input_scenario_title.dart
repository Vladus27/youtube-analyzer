import 'package:flutter/material.dart';

class InputSingleLine extends StatelessWidget {
  const InputSingleLine(
      {super.key,
      required this.textControler,
      this.title = 'Scenario title',
      this.label = 'Title',});
  final String title;
  final String label;
  final TextEditingController textControler;

  OutlineInputBorder _inputBorderOutline(Color color) {
    return OutlineInputBorder(
      borderRadius: BorderRadius.circular(12),
      borderSide: BorderSide(color: color),
    );
  }

  @override
  Widget build(BuildContext context) {
    final colorTheme = Theme.of(context).colorScheme;
    return TextFormField(
      autovalidateMode: AutovalidateMode.onUserInteraction,
      validator: (value) {
        if (value == null || value.isEmpty) {
          return '$title cannot be empty';
        }
        if (value.length < 3) {
          return '$title must be at least 3 characters long';
        }
        return null;
      },
      maxLength: 50,
      controller: textControler,
      decoration: InputDecoration(
        labelText: label,
        hintText: 'Enter $title',
        filled: true,
        fillColor: colorTheme.surfaceContainer,
        enabledBorder: _inputBorderOutline(colorTheme.primaryContainer),
        focusedBorder: _inputBorderOutline(colorTheme.primary),
        errorBorder: _inputBorderOutline(colorTheme.error),
        focusedErrorBorder: _inputBorderOutline(colorTheme.error),
      ),
    );
  }
}
