import 'package:flutter/material.dart';

import 'package:youtube_analyzer/features/main_page/view/content_channel/widgets/content_tab_controller.dart';
import 'package:youtube_analyzer/features/main_page/view/content_channel/widgets/view_empty_content.dart';

import 'package:youtube_analyzer/repositories/models/subscription_channel.dart';

class ContentChannelScreen extends StatelessWidget {
  const ContentChannelScreen({
    super.key,
    this.youtubersContent = const [],
    this.emptyContent =
        'This board is empty! \nSelect any youtuber to see his videos',
    required this.channelId,
    required this.contentAuthor,
    this.isLoading = false,
  });
  final List<VideoContent> youtubersContent;
  final String emptyContent;
  final String channelId;
  final String contentAuthor;
  final bool isLoading;

  @override
  Widget build(BuildContext context) {
    return channelId.isEmpty
        ? ViewEmptyContent(emptyContent: emptyContent, isLoading: isLoading)
        : ContentTabController(
            youtubersContent: youtubersContent,
            channelId: channelId,
            isLoading: isLoading,
            contentAuthor: contentAuthor,
          );
  }
}
