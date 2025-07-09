import 'package:flutter/material.dart';

class InputScenarioTitle extends StatelessWidget {
  const InputScenarioTitle({super.key, required this.titleTextControler});
  final TextEditingController titleTextControler;

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
          return 'Title cannot be empty';
        }
        if (value.length < 3) {
          return 'Title must be at least 3 characters long';
        }
        return null;
      },
      maxLength: 50,
      controller: titleTextControler,
      decoration: InputDecoration(
        labelText: 'Title',
        hintText: 'Enter scenario title',
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
