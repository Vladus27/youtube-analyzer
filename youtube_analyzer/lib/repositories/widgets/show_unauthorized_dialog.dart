import 'package:flutter/material.dart';
import 'package:youtube_analyzer/features/login_page/view/login_page_screen.dart';

class ShowUnauthorizedDialog extends StatelessWidget {
  const ShowUnauthorizedDialog(
      {super.key, required this.content, required this.title});
  final String title;
  final String content;

  @override
  Widget build(BuildContext context) {
    final colorTheme = Theme.of(context).colorScheme;
    return PopScope(
      canPop: false, // Забороняє закриття кнопкою "назад"
      child: AlertDialog(
        title: Text(title),
        content: SizedBox(width: 255, child: Text(content)),
        actions: [
          SizedBox(
            height: 46,
            width: double.infinity,
            child: FilledButton.icon(
              onPressed: () {
                Navigator.of(context).pop(); // Закриває діалог
                Navigator.pushReplacement(
                  context,
                  MaterialPageRoute(
                      builder: (context) => const LoginPageScreen()),
                );
              },
              icon: const Icon(Icons.login),
              label: const Text("Log In"),
              style: FilledButton.styleFrom(
                backgroundColor: colorTheme.error,
              ),
            ),
          ),
        ],
      ),
    );
  }
}

