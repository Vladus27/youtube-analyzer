import 'package:flutter/material.dart';

import 'package:youtube_analyzer/models/youtube.dart';
import 'package:youtube_analyzer/widgets/content_grid_item.dart';

class Content extends StatelessWidget {
  const Content({
    super.key,
    this.youtubersContent = const [],
    this.emptyContent = 'This board is empty! \nSelect any youtuber to see his videos',
    required this.channelId
  });
  final List<VideoContent> youtubersContent;
  final String emptyContent;
  final String channelId;


  @override
  Widget build(BuildContext context) {
    return youtubersContent.isEmpty
        ? Center(
            child: Text(
              emptyContent,
              style: Theme.of(context)
                  .textTheme
                  .displayLarge!
                  .copyWith(color: Theme.of(context).colorScheme.primary),
                  //textAlign: TextAlign.center,
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
                .map((content) => ContentGridItem(content: content, channelId: channelId,))
                .toList(),
          );
  }
}
