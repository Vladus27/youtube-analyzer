import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

import 'package:youtube_analyzer/screens/main_page.dart';



final theme = ThemeData(
  colorScheme: ColorScheme.fromSeed(
    brightness: Brightness.dark,
    seedColor: const Color.fromARGB(255, 118, 0, 131),
  ),
  textTheme: GoogleFonts.latoTextTheme(
    const TextTheme(
      bodyLarge: TextStyle(color: Colors.white),
      bodyMedium: TextStyle(color: Colors.white),
    ),
  ),
  
  scaffoldBackgroundColor: Colors.black,
  appBarTheme: const AppBarTheme(backgroundColor: Colors.black),
  inputDecorationTheme: const InputDecorationTheme(
    focusedBorder: OutlineInputBorder(
      borderSide: BorderSide(color: Colors.purple),
    ),
    enabledBorder: OutlineInputBorder(
      borderSide: BorderSide(color: Colors.grey),
    ),
  ),
);

void main() {
  runApp(const MainApp());
}

class MainApp extends StatelessWidget {
  const MainApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Youtube Analyzer',
      debugShowCheckedModeBanner: false,
      theme: theme,
      home: const MainPage(),
    );
  }
}
