import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';

import 'package:youtube_analyzer/common/database.dart';
import 'package:youtube_analyzer/repositories/models/environment.dart';
import 'package:youtube_analyzer/youtube_analizer_app.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await dotenv.load(fileName: Environment.fileName);
  await Database.init();
  
  runApp(const YoutubeAnalizerApp());
}
