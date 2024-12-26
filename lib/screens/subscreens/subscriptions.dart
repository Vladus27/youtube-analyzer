import 'dart:convert';

import 'package:http/http.dart' as http;

import 'package:flutter/material.dart';

import 'package:youtube_analyzer/data/chanel_service.dart';

import 'package:youtube_analyzer/data/dummy_data.dart'; // import basic url and token

import 'package:youtube_analyzer/models/youtube.dart';
import 'package:youtube_analyzer/widgets/add_new_youtuber.dart';
import 'package:youtube_analyzer/widgets/dialog_prompt.dart';

class Subscriptions extends StatefulWidget {
  const Subscriptions({super.key, required this.onSelectedYoutuber});
  final void Function(String author) onSelectedYoutuber;

  @override
  State<Subscriptions> createState() => _SubscriptionsState();
}

class _SubscriptionsState extends State<Subscriptions> {
  

  

  List<Youtuber> subscrtiptionYT = [];

  void _loadItems() async {
    final url = Uri.https(basicUrl, "/api/youtube/get-channel-list");

    try {
      final response = await http.get(
        url,
        headers: {
          'x-service-name': 'SocialMediaApi',
          'x-token': basicXtocen,
        },
      );
      print(response.body);

      if (response.statusCode == 200) {
        final data = json.decode(response.body);

        if (data['isOk'] == true) {
          final List<dynamic> items = data['value']['items'];
          // Мапимо отримані дані у список Youtuber
          subscrtiptionYT = items.map((item) {
            return Youtuber.fromJson(item);
          }).toList();
          if (mounted) {
            setState(() {});
          }
        } else {
          print(' Помилка API: ${data['errors']}');
        }
      } else {
        print(' Помилка HTTP: ${response.statusCode}');
      }
    } catch (e) {
      print(' Виникла помилка: $e');
    }
  }

  Future<void> _deleteYoutuber(String channelId) async {
    final url = Uri.https(basicUrl, "/api/youtube/delete-channel/$channelId");
    final response = await http.get(
      url,
      headers: {
        'x-service-name': 'SocialMediaApi',
        'x-token': basicXtocen,
      },
    );

    if (response.statusCode == 200) {
      final data = json.decode(response.body);
      if (data['isOk']) {
        setState(() {
          // subscrtiptionYT.removeAt(index);
          subscrtiptionYT.removeWhere((youtuber) => youtuber.id == channelId);
        });
        print('Канал успішно видалено');
      } else {
        print('Помилка при видаленні каналу: ${data['errors']}');
      }
    } else {
      print('Не вдалося видалити канал. Статус код: ${response.statusCode}');
    }
  }




  @override
  void initState() {
    _loadItems();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    void addYotuber(Youtuber youtuber) {
      setState(
        () {
          subscrtiptionYT.add(youtuber);
        },
      );
    }

   

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
                  onAddYoutuber: addYotuber,
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
                    leading: CircleAvatar(
                      backgroundImage: AssetImage(
                        subscrtiptionYT[index].logo,
                      ),
                    ),
                    trailing: PopupMenuButton(
                      itemBuilder: (ctx) => [
                        PopupMenuItem(
                          value: 'Delete',
                          onTap: () {
                            print('chanell  ${subscrtiptionYT[index].name} Id: ${subscrtiptionYT[index].id}');
                            _deleteYoutuber(subscrtiptionYT[index].id);
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
                            showDialog(
                              context: context,
                              builder: (ctx) =>  Dialog(
                                child: DialogPrompt(channelId: subscrtiptionYT[index].id,),
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
