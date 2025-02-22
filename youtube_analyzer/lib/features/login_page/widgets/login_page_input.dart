import 'package:flutter/material.dart';

class LoginPageInput extends StatelessWidget {
  const LoginPageInput({
    super.key,
    required this.titleField,
    required this.verificationCode,
  });
  final TextEditingController verificationCode;
  final String titleField;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return TextField(
      controller: verificationCode,
      keyboardType: TextInputType.text,
      maxLength: 50,
      decoration: InputDecoration(
        label: Text(titleField),
        filled: true,
        fillColor: theme.colorScheme.surfaceContainer,
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(24),
          borderSide: BorderSide(color: theme.colorScheme.primaryContainer),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide(color: theme.colorScheme.primary),
        ),
      ),
    );
  }
}
