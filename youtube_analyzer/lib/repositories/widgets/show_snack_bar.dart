import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';


void _printTextInDebugMode(String text){
  if (!kReleaseMode) {
    debugPrint(text);
  }  
}

void showSnackBar(BuildContext context, String message) {
  ScaffoldMessenger.of(context).clearSnackBars();
  ScaffoldMessenger.of(context).showSnackBar(
    SnackBar(
      content: Text(message),
      action: SnackBarAction(
        label: 'ok',
        onPressed: () {
          _printTextInDebugMode('Vladus is the best');
          // Code to execute.
        },
      ),
    ),
  );
}
