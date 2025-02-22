import 'package:flutter/material.dart';
import 'package:youtube_analyzer/common/database.dart';

import 'package:youtube_analyzer/data/dummy_data.dart';

import 'package:youtube_analyzer/models/youtube.dart';
import 'package:youtube_analyzer/screensOld/subscreens/content.dart';
import 'package:youtube_analyzer/screensOld/subscreens/subscriptions.dart';

import 'package:http/http.dart' as http;
import 'dart:convert';

class MainPage extends StatefulWidget {
  const MainPage({super.key});

  @override
  State<MainPage> createState() => _MainPageState();
}

class _MainPageState extends State<MainPage> {
  List<VideoContent> selectedContent = [];

  String idChannel = '';

  void _selectedContent(String selectedYoutuber) {
    setState(
      () {
        selectedContent = [];
      },
    );
    _loadVideos(selectedYoutuber);
  }

  Future<void> _loadVideos(String channelId) async {
    final url = Uri.https(basicUrl,
        "/api/youtube/get-channel-videos/$channelId");
    final response = await http.get(
      url,
      headers: {
        'x-service-name': 'SocialMediaApi',
        'x-token': basicXtocen
      },
    );

    if (response.statusCode == 200) {
      final data = json.decode(response.body);
      final videos = (data['value']['items'] as List)
          .map((videoData) => VideoContent.fromJson(videoData))
          .toList();

      setState(() {
        idChannel = channelId;        
        debugPrint('data: $data ');
        selectedContent = videos;
      });
    } else {
      // Обробка помилок
      debugPrint('Failed to load videos');
    }
  }

  @override
  Widget build(BuildContext context) {
    debugPrint('user auth token: ${Database.get(Database.personAuthTokenKey)}');
    return Scaffold(
      appBar: AppBar(
        title: const Text('Analyzer'),
      ),
      body: Row(
        children: [
          Expanded(
              flex: 2,
              child: Subscriptions(
                onSelectedYoutuber: _selectedContent,
              )),
          Expanded(
            flex: 9,
            child: Content(
              youtubersContent: selectedContent,
              channelId: idChannel,
            ),
          ),
        ],
      ),
    );
  }
}
