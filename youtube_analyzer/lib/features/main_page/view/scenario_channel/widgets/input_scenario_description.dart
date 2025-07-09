import 'package:flutter/material.dart';

class InputScenarioDescription extends StatelessWidget {
  const InputScenarioDescription({
    super.key,
    required this.descriptionTextControler,
  });
  final TextEditingController descriptionTextControler;

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
      controller: descriptionTextControler,
      maxLines: 5,
      decoration: InputDecoration(
        hintText: 'Enter description (optional)',
        labelText: 'Description',
        filled: true,
        fillColor: colorTheme.surfaceContainer,
        enabledBorder: _inputBorderOutline(colorTheme.primaryContainer),
        focusedBorder: _inputBorderOutline(colorTheme.primary),
      ),
    );
  }
}
