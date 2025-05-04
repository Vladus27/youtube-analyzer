import 'package:flutter/material.dart';
import 'package:youtube_analyzer/common/database.dart';
import 'package:youtube_analyzer/features/main_page/view/main_page_screen.dart';
import 'features/login_page/view/login_page_screen.dart';
import 'theme/theme.dart';

class YoutubeAnalizerApp extends StatelessWidget {
  const YoutubeAnalizerApp({super.key});

  @override
  Widget build(BuildContext context) {
    var authToken = Database.get(Database.personAuthTokenKey);
    debugPrint('auth token: $authToken');

    return MaterialApp(
      title: 'Youtube Analyzer',
      debugShowCheckedModeBanner: false,
      theme: theme,
      home: authToken == null ? const LoginPageScreen() : const MainPage(),
    );
  }
}
