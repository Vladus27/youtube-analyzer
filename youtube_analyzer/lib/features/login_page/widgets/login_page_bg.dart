import 'package:flutter/material.dart';

class LoginPageBG extends StatelessWidget {
  const LoginPageBG({super.key});

  @override
  Widget build(BuildContext context) {
    return DecoratedBox(
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [
            Theme.of(context).colorScheme.onPrimary,
            Theme.of(context).colorScheme.surface,
          ],
        ),
      ),
    );
  }
}
