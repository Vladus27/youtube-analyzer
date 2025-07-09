import 'package:flutter/material.dart';
import 'package:youtube_analyzer/common/database.dart';
import 'package:youtube_analyzer/features/main_page/view/main_page_screen.dart';
import 'package:youtube_analyzer/features/main_page/view/scenario_channel/view/add_screnarios_screen.dart' show AddScrenariosScreen;
import 'features/login_page/view/login_page_screen.dart';
import 'theme/theme.dart';

import 'package:flutter/foundation.dart';

// import 'package:youtube_analyzer/w_dummy_test/temp_test_file.dart';




class YoutubeAnalizerApp extends StatelessWidget {
  const YoutubeAnalizerApp({super.key});

  void _printTextInDebugMode(String text){
  if (!kReleaseMode) {
    debugPrint(text);
  }  
}

  @override
  Widget build(BuildContext context) {
    // int? timerSeconds = Database.get(Database.timerSeconds);
    // if (!kReleaseMode) {
    //   _printTextInDebugMode('timerSeconds from Database: $timerSeconds');
    // }
    // bool isTimerSecondsEmpty = timerSeconds == null;
    // if (isTimerSecondsEmpty) {
    //   Database.set(Database.timerSeconds, 1200);
    // }

    // var authToken = Database.get(Database.personAuthTokenKey);
    // bool checkAuthToken = authToken == null || authToken == 'empty';
    // _printTextInDebugMode('auth token: $authToken');

    return MaterialApp(
      title: 'Youtube Analyzer',
      debugShowCheckedModeBanner: false,
      theme: theme,
       home: const AddScrenariosScreen(),
      //home: checkAuthToken ? const LoginPageScreen() : const MainPage(),
    );
  }
}
