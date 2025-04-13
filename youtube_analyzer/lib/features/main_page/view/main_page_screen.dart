import 'package:flutter/material.dart';
import 'package:youtube_analyzer/common/database.dart';
import 'package:youtube_analyzer/features/main_page/view/content_channel/widgets/content.dart';

import 'package:youtube_analyzer/repositories/subcription_channels/models/subscription_channel.dart'; //model
import 'package:youtube_analyzer/repositories/subcription_channels/youtube_repository.dart'; //rep

import 'package:youtube_analyzer/screensOld/subscreens/subscriptions.dart';

class MainPage extends StatefulWidget {
  const MainPage({super.key});

  @override
  State<MainPage> createState() => _MainPageState();
}

class _MainPageState extends State<MainPage> {
  List<VideoContent> selectedContent = [];

  String idChannel = '';

  void _selectedContent(String selectedYoutuber) {
    setState(() {
      selectedContent = [];
    });
    _loadVideos(selectedYoutuber);
  }

  Future<void> _loadVideos(String channelId) async {
    debugPrint('Успішно вивсітлились відоси, МАБОООЙ');
    List<VideoContent> videos =
        await YoutubeRepository().getChannelVideos(channelId);
    setState(() {
      idChannel = channelId;
      selectedContent = videos;
    });
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
