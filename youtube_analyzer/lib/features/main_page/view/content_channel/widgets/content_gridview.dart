import 'dart:convert';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:http/http.dart' as http;

import 'package:flutter/material.dart';
import 'package:youtube_analyzer/data/dummy_data.dart';
import 'package:youtube_analyzer/repositories/subcription_channels/models/subscription_channel.dart';

import 'package:youtube_analyzer/widgetsOld/dialog_vid_content.dart';

class ContentGridItem extends StatelessWidget {
  const ContentGridItem({
    super.key,
    required this.content,
    required this.channelId,
    required this.channelExternalId
  });

  final VideoContent content;
  final String channelId;
  final String channelExternalId;

  @override
  Widget build(BuildContext context) {
    Future<void> showVideoDetailsDialog(
        String title, String originalText, String modifiedText) async {
      await showDialog(
        context: context,
        builder: (ctx) => Dialog(
          child: DialogVidContent(
            authorVid: content.videoId, //authorVid27
            titleVid: content.videoTitle, //titleVid27
            originalText: originalText,
            modifiedText: modifiedText,
          ),
        ),
      );
    }

    Future<void> getVideoDetails(String channelId, String videoId) async {
      // debugPrint('External Id of channel preview'+ channelExternalId);

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
        getVideoDetails(channelId, content.videoId);

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
        debugPrint(' content channel id: $channelId\n');
        debugPrint('content id ${content.videoId}');
        debugPrint('content title: ${content.videoTitle}');
        // debugPrint('modified text ${content.modifiedText}');
        // debugPrint('original text ${content.originalText}');
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
          // gradient: LinearGradient(
          //   colors: [
          //     content.color.withOpacity(0.55),
          //     content.color.withOpacity(0.9)
          //   ],
          //   begin: Alignment.topLeft,
          //   end: Alignment.bottomRight,
          // ),
        ),
        child: Text(content.videoTitle),
      ),
    );
  }
}
