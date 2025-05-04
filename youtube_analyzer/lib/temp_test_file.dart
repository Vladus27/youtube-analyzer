import 'package:flutter/material.dart';

class TempTestFile extends StatelessWidget {
  const TempTestFile({super.key, required this.verifCode});
  final String verifCode;

  @override
  Widget build(BuildContext context) {
    final colorTheme = Theme.of(context).colorScheme;
    void showLoginRequiredDialog(
        String title, String content, String buttonLabel) {
      showDialog(
        context: context,
        barrierDismissible: false, // Забороняє закриття кліком поза діалогом
        builder: (BuildContext context) {
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
                      // Navigator.pushReplacement(
                      //   context,
                      //   MaterialPageRoute(
                      //       builder: (context) => const LoginPageScreen()),
                      // );
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
        },
      );
    }

    return Scaffold(
      backgroundColor: Colors.black,
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          const String title = 'Access denied';
          String message =
              'Your verification code: \n$verifCode \n is out of date. To continue, log in to the system';
          const String label = 'Log in';
          showLoginRequiredDialog(title, message, label);
        },
        child: const Icon(Icons.add),
      ),
    );
  }
}
