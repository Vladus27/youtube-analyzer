import 'dart:convert';
import 'package:http/http.dart' as http;

import 'package:flutter/material.dart';
import 'package:youtube_analyzer/data/dummy_data.dart';
import 'package:youtube_analyzer/models/youtube.dart';
import 'package:youtube_analyzer/widgetsOld/dialog_vid_content.dart';

class ContentGridItem extends StatelessWidget {
  const ContentGridItem(
      {super.key, required this.content, required this.channelId});

  final VideoContent content;
  final String channelId;

  @override
  Widget build(BuildContext context) {

    Future<void> showVideoDetailsDialog(
        String title, String originalText, String modifiedText) async {
      await showDialog(
        context: context,
        builder: (ctx) => Dialog(
          child: DialogVidContent(
            authorVid: content.id, //authorVid27
            titleVid: content.title, //titleVid27
            originalText: originalText,
            modifiedText: modifiedText,
          ),
        ),
      );
    }

    Future<void> getVideoDetails(String channelId, String videoId) async {
      final url = Uri.https(
        basicUrl,
        "/api/youtube/get-video-details/$channelId/$videoId",
      );

      try {
        final response = await http.get(
          url,
          headers: {
            'x-service-name': 'SocialMediaApi',
            'x-token': basicXtocen,
          },
        );

        if (response.statusCode == 200) {
          final responseData = jsonDecode(response.body);

          print('🔍 Debug API Response: ${responseData.toString()}');


          

          if (responseData['isOk']) {
            final videoDetails = responseData['value'];
            showVideoDetailsDialog(
              videoDetails['title'],
              videoDetails['originalText'],
              videoDetails['modifiedText'],
            );
            print('✅ Деталі відео:');
            print('ID: ${videoDetails['id']}');
            print('Title: ${videoDetails['title']}');
            print('Original Text: ${videoDetails['originalText']}');
            print('Modified Text: ${videoDetails['modifiedText']}');

            // Можемо передати деталі у діалогове вікно

          } else {
            print('⚠️ Помилка: ${responseData['errors']}');
          }
        } else {
          print('❌ Запит завершився з помилкою: ${response.statusCode}');
        }
      } catch (error) {
        print('❗ Виникла помилка: $error');
      }
    }

    return InkWell(
      onTap: () {
        getVideoDetails(channelId, content.id);

        // showDialog(
        //   context: context,
        //   builder: (ctx) => Dialog(
        //     child: DialogVidContent(
        //       authorVid: content.id, //authorVid27
        //       titleVid: content.title, //titleVid27
        //       originalText: originalText27,
        //       modifiedText: modifiedText27,
        //     ),
        //   ),
        // );
        print(' content channel id: $channelId\n');
        print('content id ${content.id}');
        print('content title: ${content.title}');
        print('modified text ${content.modifiedText}');
        print('original text ${content.originalText}');
      },
      splashColor: Theme.of(context).primaryColor,
      borderRadius: BorderRadius.circular(16),
      child: Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(16),
          gradient: LinearGradient(
            colors: [
              content.color.withOpacity(0.55),
              content.color.withOpacity(0.9)
            ],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
        ),
        child: Text(content.title),
      ),
    );
  }
}
