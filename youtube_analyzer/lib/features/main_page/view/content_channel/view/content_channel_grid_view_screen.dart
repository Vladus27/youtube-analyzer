import 'package:flutter/material.dart';
import 'package:youtube_analyzer/features/main_page/view/content_channel/widgets/channel_grid_view_video.dart';

import 'package:youtube_analyzer/repositories/models/subscription_channel.dart';

class ContentChannelGridViewScreen extends StatelessWidget {
  const ContentChannelGridViewScreen({
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
    final colorTheme = Theme.of(context).colorScheme;
    return youtubersContent.isEmpty
        ? Center(
            child: isLoading
                ? CircularProgressIndicator(
                    valueColor:
                        AlwaysStoppedAnimation<Color>(colorTheme.primary),
                  )
                : Text(
                    emptyContent,
                    style: Theme.of(context)
                        .textTheme
                        .displayLarge!
                        .copyWith(color: colorTheme.primary),                    
                  ),
          )
        : GridView(
            padding: const EdgeInsets.all(24),
            gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 4, //set amount of colums (horisontals) in table
                childAspectRatio: 3 / 2, //aspect ratio of elements
                crossAxisSpacing:
                    20, //spacing between the colums?? (horisontals)
                mainAxisSpacing: 15 //spacing between the rows (verticals)
                ),
            children: youtubersContent
                .map((content) => ChannelGridViewVideo(
                      content: content,
                      channelId: channelId,
                      channelExternalId: content.externalId,
                      author: contentAuthor,
                    ))
                .toList(),
          );
  }
}
