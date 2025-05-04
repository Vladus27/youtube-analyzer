import 'package:flutter/material.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:youtube_analyzer/features/main_page/view/content_channel/channel_video_details/view/dialog_video_details_modal_screen.dart';

import 'package:youtube_analyzer/features/main_page/view/content_channel/widgets/dummy_text.dart';
import 'package:youtube_analyzer/repositories/models/subscription_channel.dart';

class ChannelGridViewVideo extends StatelessWidget {
  const ChannelGridViewVideo(
      {super.key,
      required this.content,
      required this.channelId,
      required this.channelExternalId,
      required this.author});

  final VideoContent content;
  final String channelId;
  final String channelExternalId;
  final String author;

  @override
  Widget build(BuildContext context) {
    String dummyOriginal = DummyText().dummyOriginal;
    String dummyModified = DummyText().dummyModified;

    void showVideoDetailsDialog()  {
       showDialog(
        context: context,
        builder: (ctx) => Dialog(
          child: DialogVideoDetailsModalScreen(
            authorVid: author, 
            titleVid: content.videoTitle, 
            originalText: dummyOriginal,
            modifiedText: dummyModified,
          ),
        ),
      );
    }

    return InkWell(
      onTap: () {
        showVideoDetailsDialog();
      },
      splashColor: Theme.of(context).primaryColor,
      borderRadius: BorderRadius.circular(16),
      child: Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(16),
          image: DecorationImage(
            image: CachedNetworkImageProvider(
                'https://img.youtube.com/vi/$channelExternalId/0.jpg'),
          ),
        ),
        child: Text(content.videoTitle),
      ),
    );
  }
}
