import 'package:flutter/material.dart';

class InputMultiLine extends StatelessWidget {
  const InputMultiLine({
    super.key,
    required this.textControler,
    this.hint = 'Enter description (optional)',
    this.label = 'Description',
  });
  final TextEditingController textControler;
  final String hint;
  final String label;

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
      controller: textControler,
      maxLines: 5,
      decoration: InputDecoration(
        hintText: hint,
        labelText: label,
        filled: true,
        fillColor: colorTheme.surfaceContainer,
        enabledBorder: _inputBorderOutline(colorTheme.primaryContainer),
        focusedBorder: _inputBorderOutline(colorTheme.primary),
      ),
    );
  }
}
