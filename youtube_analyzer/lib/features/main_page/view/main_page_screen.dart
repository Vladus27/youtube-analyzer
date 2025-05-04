import 'package:flutter/material.dart';
import 'package:youtube_analyzer/common/database.dart';


import 'package:youtube_analyzer/features/main_page/view/content_channel/view/content_channel_grid_view_screen.dart';
import 'package:youtube_analyzer/features/main_page/view/subscription_channels/view/subscription_channels_screen.dart';

import 'package:youtube_analyzer/repositories/models/subscription_channel.dart'; //model
import 'package:youtube_analyzer/repositories/widgets/handle_verified_auth_token.dart';
import 'package:youtube_analyzer/repositories/youtube_repository.dart';

class MainPage extends StatefulWidget {
  const MainPage({super.key});

  @override
  State<MainPage> createState() => _MainPageState();
}

class _MainPageState extends State<MainPage> {
  List<VideoContent> selectedContent = [];
  bool isLoading = false;
  String idChannel = '';
  String contentAuthor = '';

  void _selectedContent(String selectedYoutuber,[String channelName = '']) {
    setState(() {
      selectedContent = [];
      isLoading = true;
    });
    _loadVideos(selectedYoutuber, channelName);
  }

  Future<void> _loadVideos(String channelId, String channelName) async {
    await handleVerifiedAuthTokenAsync(ctx: context);
    List<VideoContent> videos =
        await YoutubeRepository().getChannelVideos(channelId);
    setState(() {
      idChannel = channelId;
      selectedContent = videos;
      isLoading = false;
      contentAuthor = channelName;
    });
  }

  handleVerifCode() async {
    await handleVerifiedAuthTokenAsync(ctx: context);
  }

  @override
  void initState() {
    super.initState();
    handleVerifCode();
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
              child: SubscriptionsChannelsScreen(
                onSelectedChannelsContent: _selectedContent,
              )),
          Expanded(
            flex: 9,
            child: ContentChannelGridViewScreen(
              youtubersContent: selectedContent,
              channelId: idChannel,
              isLoading: isLoading,
              contentAuthor: contentAuthor,
            ),
          ),
        ],
      ),
    );
  }
}
