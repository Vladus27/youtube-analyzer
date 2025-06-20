import 'package:flutter/material.dart';
import 'package:youtube_analyzer/features/main_page/view/content_channel/widgets/channel_grid_view_video.dart';
import 'package:youtube_analyzer/features/main_page/view/content_channel/widgets/view_empty_content.dart';
import 'package:youtube_analyzer/repositories/models/subscription_channel.dart';

class ContentTabController extends StatelessWidget {
  const ContentTabController({
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
    return DefaultTabController(
      length: 2,
      child: Scaffold(
        appBar: AppBar(
          title: const TabBar(
            tabs: [
              Tab(
                text: 'videos',
                icon: Icon(Icons.ondemand_video_rounded),
              ),
              Tab(
                text: 'scenarios',
                icon: Icon(Icons.video_settings_outlined),
              ),
            ],
          ),
        ),
        body: TabBarView(
          children: [
            // youtubersContent.isEmpty && // unnecessary condition In my oppiinion
            isLoading // condition to refreshing content
                ? const Center(child: CircularProgressIndicator())
                : youtubersContent.isEmpty
                    ? ViewEmptyContent(emptyContent: emptyContent)
                    : GridView(
                        padding: const EdgeInsets.all(24),
                        gridDelegate:
                            const SliverGridDelegateWithFixedCrossAxisCount(
                                crossAxisCount:
                                    4, //set amount of colums (horisontals) in table
                                childAspectRatio:
                                    3 / 2, //aspect ratio of elements
                                crossAxisSpacing:
                                    20, //spacing between the colums?? (horisontals)
                                mainAxisSpacing:
                                    15 //spacing between the rows (verticals)
                                ),
                        children: youtubersContent
                            .map((content) => ChannelGridViewVideo(
                                  content: content,
                                  channelId: channelId,
                                  channelExternalId: content.externalId,
                                  author: contentAuthor,
                                ))
                            .toList(),
                      ),

            Scaffold(
              floatingActionButton: FloatingActionButton(
                heroTag: 'scenarionFab',
                onPressed: () {},
                child: const Icon(Icons.add),
              ),
              body: const  Center(child: Text('second tab'),)
            )

            // const Center(child: Text('secocnd tab')),
          ],
        ),
      ),
    );
  }
}
