import 'package:flutter/material.dart';


void showSnackBar(BuildContext context, String message) {
  ScaffoldMessenger.of(context).clearSnackBars();
  ScaffoldMessenger.of(context).showSnackBar(
    SnackBar(
      content: Text(message),
      action: SnackBarAction(
        label: 'ok',
        onPressed: () {
          debugPrint('Vladus is the best');
          // Code to execute.
        },
      ),
    ),
  );
}
