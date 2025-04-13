import 'package:flutter/material.dart';
// import 'dart:convert';
// import 'package:http/http.dart' as http;
import 'package:cached_network_image/cached_network_image.dart';

// import 'package:youtube_analyzer/data/dummy_data.dart'; // import basic url and token
import 'package:youtube_analyzer/modelsOld/youtube.dart';
import 'package:youtube_analyzer/repositories/subcription_channels/youtube_repository.dart';
import 'package:youtube_analyzer/widgetsOld/add_new_youtuber.dart';
import 'package:youtube_analyzer/widgetsOld/dialog_prompt.dart';

class SubscriptionsYtScreen extends StatefulWidget {
  const SubscriptionsYtScreen({super.key, required this.onSelectedYoutuber});
  final void Function(String author) onSelectedYoutuber;

  @override
  State<SubscriptionsYtScreen> createState() => _SubscriptionsYtScreenState();
}

class _SubscriptionsYtScreenState extends State<SubscriptionsYtScreen> {
  List<Youtuber> subscrtiptionYT = [];

  void _deleteYoutuber(String youtuberId) async {
    final bool isDeleted = await YoutubeRepository().deleteChannel(youtuberId);

    if (isDeleted) {
      debugPrint("Youtuber is deleted Succsessfully");
      setState(() {});
    } else {
      debugPrint("something went wrong");
    }
  }

  void _addYoutuber(Youtuber youtuber) {
    setState(
      () {
        subscrtiptionYT.add(youtuber);
      },
    );
  }

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).colorScheme.surface,
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          showDialog(
            context: context,
            builder: (ctx) => Dialog(
              child: SizedBox(
                width: 550,
                height: 250,
                child: AddNewYoutuber(
                  onAddYoutuber: _addYoutuber,
                ),
              ),
            ),
          );
        },
        tooltip: 'Add new youtuber',
        child: const Icon(Icons.add),
      ),
      body: subscrtiptionYT.isEmpty
          ? Center(
              child: Text(
                'Add any Youtuber to see their content',
                style: Theme.of(context)
                    .textTheme
                    .titleLarge!
                    .copyWith(color: Theme.of(context).colorScheme.secondary),
                textAlign: TextAlign.center,
              ),
            )
          : ListView.builder(
              itemCount: subscrtiptionYT.length,
              itemBuilder: (ctx, index) {
                return Card(
                  child: ListTile(
                    leading: CachedNetworkImage(
                      imageUrl: subscrtiptionYT[index].logo,
                      imageBuilder: (context, imageProvider) => CircleAvatar(
                        backgroundImage: imageProvider,
                      ),
                      placeholder: (context, url) => const CircleAvatar(
                        child: CircularProgressIndicator(strokeWidth: 2),
                      ),
                      errorWidget: (context, url, error) => const CircleAvatar(
                        backgroundImage: AssetImage('lib/assets/image1.jpg'),
                      ),
                    ),
                    trailing: PopupMenuButton(
                      itemBuilder: (ctx) => [
                        PopupMenuItem(
                          value: 'Delete',
                          onTap: () {
                            debugPrint(
                                "channel  ${subscrtiptionYT[index].name} \n Id: ${subscrtiptionYT[index].id}\n imageURL:  ${subscrtiptionYT[index].logo}");
                            _deleteYoutuber(subscrtiptionYT[index].id);
                            debugPrint(subscrtiptionYT[index].logo);
                            //removeYouTuber(index);
                            setState(() {
                              //widget.onSelectedYoutuber('');
                            });
                          },
                          child: const Text('Delete'),
                        ),
                        PopupMenuItem(
                          value: 'Prompt',
                          onTap: () {
                            debugPrint(
                                'channel  ${subscrtiptionYT[index].name} \n Id: ${subscrtiptionYT[index].id}\n imageURL:  ${subscrtiptionYT[index].logo}');
                            showDialog(
                              context: context,
                              builder: (ctx) => Dialog(
                                child: DialogPrompt(
                                  channelId: subscrtiptionYT[index].id,
                                ),
                              ),
                            );
                          },
                          child: const Text('Prompt'),
                        ),
                      ],
                    ),
                    title: Text(subscrtiptionYT[index].name),
                    onTap: () {
                      setState(() {
                        widget.onSelectedYoutuber(subscrtiptionYT[index].id);
                      });
                    },
                  ),
                );
              },
            ),
    );
  }
}
