import 'package:flutter/material.dart';

class LoginPageTitle extends StatelessWidget {
  const LoginPageTitle({super.key, required this.title});
  final String title;

  @override
  Widget build(BuildContext context) {
    final ctxTheme = Theme.of(context);
    final txtTheme = ctxTheme.textTheme.displayLarge;
    final titleTheme = txtTheme!.copyWith(fontWeight: FontWeight.bold);
    return Container(
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [
            ctxTheme.colorScheme.onPrimary,
            ctxTheme.colorScheme.surface,
          ],
        ),
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Text(title, style: titleTheme),
        ],
      ),
    );
  }
}
