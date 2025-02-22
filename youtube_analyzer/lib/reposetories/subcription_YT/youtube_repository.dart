import 'package:flutter/material.dart';
import 'dart:convert';
//import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:http/http.dart' as http;

import 'package:youtube_analyzer/common/database.dart';
import 'package:youtube_analyzer/reposetories/subcription_YT/models/environment.dart';
import 'package:youtube_analyzer/reposetories/subcription_YT/models/subscription_YT.dart';

class YoutubeRepository {
  // add here http request methods

  final String _basicUrl = Environment.apiUrl;

  Future<bool> checkPersonAuthTokenKey(String verifCode) async {
    bool isAuthorized = false;
    try {
      final url = Uri.https(_basicUrl, "api/user/log-in");
      final response = await http.get(
        url,
        headers: {
          'x-service-name': 'SocialMediaApi',
          'x-token': verifCode,
        },
      );
      if (response.statusCode == 200) {
        final responseData = jsonDecode(response.body);
        debugPrint('my response: $responseData');

        isAuthorized = responseData['isOk'] == true;
        debugPrint('authentication is: $isAuthorized');
      } else if (response.statusCode == 401) {
        debugPrint("User in unathorized, statusCode: ${response.statusCode}");
        return isAuthorized;
      }
    } catch (e) {
      debugPrint(' Виникла помилка: $e');
    }
    return isAuthorized;
  }

  Future<void> addChannel(String username) async {
    final url = Uri.https(_basicUrl, "/api/youtube/add-channel/$username");

    final response = await http.post(
      url,
      headers: {
        'x-service-name': 'SocialMediaApi',
        'x-token': Database.get(Database.personAuthTokenKey),
      },
    );
    debugPrint('Status code when adding Youtuber: ${response.statusCode}');

    //return response.statusCode == 200;
  }

  Future<List<SubscriptionYt>> getChannelList() async {
    final url = Uri.https(_basicUrl, "/api/youtube/get-channel-list");
    List<SubscriptionYt> subscrtiptionYT = [];

    try {
      final response = await http.get(
        url,
        headers: {
          'x-service-name': 'SocialMediaApi',
          'x-token': Database.get(Database.personAuthTokenKey),
        },
      );
      debugPrint(response.body);

      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        if (!data['isOk']) {
          debugPrint(' Помилка API: ${data['errors']}');
          return subscrtiptionYT;
        }

        final dataValue = data['value'];
        final dataItems = dataValue['items'];

        subscrtiptionYT = dataItems.map((e) {
          return SubscriptionYt.fromJson(e);
        }).toList;
      } else {
        debugPrint(' Помилка HTTP: ${response.statusCode}');
      }
    } catch (e) {
      debugPrint(' Виникла помилка: $e');
    }
    return subscrtiptionYT;
  }

  Future<List<VideoContent>> getChannelVideos(String channelId) async {
    List<VideoContent> videos = [];

    final url =
        Uri.https(_basicUrl, "/api/youtube/get-channel-videos/$channelId");
    final response = await http.get(
      url,
      headers: {
        'x-service-name': 'SocialMediaApi',
        'x-token': Database.get(Database.personAuthTokenKey)
      },
    );

    final data = json.decode(response.body);
    if (response.statusCode != 200) {
      debugPrint('Failed to load videos');
      return videos;
    }
    final dataValue = data['value'];
    final dataItems = dataValue['items'];
    videos = dataItems
        .map(
          (videoData) => VideoContent.fromJsomPreview(videoData),
        )
        .toList();
    return videos;
  }

  Future<bool> deleteChannel(String channelId) async {
    final url = Uri.https(_basicUrl, "/api/youtube/delete-channel/$channelId");
    final response = await http.get(
      url,
      headers: {
        'x-service-name': 'SocialMediaApi',
        'x-token': Database.get(Database.personAuthTokenKey),
      },
    );

    final responseData = jsonDecode(response.body);
    final isResponseOk = responseData['isOk'];

    return isResponseOk;
  }

  Future<void> setChannelPrompt(String channelId, String prompt) async {
    final url = Uri.https(_basicUrl, "/api/youtube/set-channel-prompt");

    try {
      final response = await http.post(
        url,
        headers: {
          'Content-Type': 'application/json',
          'x-service-name': 'SocialMediaApi',
          'x-token': Database.get(Database.personAuthTokenKey),
        },
        body: jsonEncode({
          'channelId': channelId,
          'prompt': prompt,
        }),
      );

      if (response.statusCode == 200) {
        final responseData = jsonDecode(response.body);
        if (responseData['isOk']) {
          debugPrint('✅ Промпт успішно встановлено!');
        } else {
          debugPrint('⚠️ Помилка: ${responseData['errors']}');
        }
      } else {
        debugPrint('❌ Запит завершився з помилкою: ${response.statusCode}');
      }
    } catch (error) {
      debugPrint('❗ Виникла помилка: $error');
    }
  }

  Future<void> getVideoDetails(String channelId, String videoId) async {
    final url = Uri.https(
      _basicUrl,
      "/api/youtube/get-video-details/$channelId/$videoId",
    );

    try {
      final response = await http.get(
        url,
        headers: {
          'x-service-name': 'SocialMediaApi',
          'x-token': Database.get(Database.personAuthTokenKey),
        },
      );

      if (response.statusCode == 200) {
        final responseData = jsonDecode(response.body);

        debugPrint('🔍 Debug API Response: ${responseData.toString()}');

        if (responseData['isOk']) {
          final videoDetails = responseData['value'];

          /*

        Я СОБІ ТАК ВВАЖАЮ, ЩО ТУТ ПОТРІБНО РЕАЛІЗУВАТИ СОРТУВАННЯ ПО АЙДІ ВІДОСА ДЛЯ СПИСКУ МОДЕЛЕЙ
        І ВІДПОВІДНО ПРИСВОЮВАТИ ЇМ ЗНАЧЕННЯ ОРИГІНАЛЬНОГО ТА МОДИФІКОВАНОГО ТЕКСТУ, ЩОБ НЕ СТВОРЮВАТИЄ
        ДОДАТКОВУ ЛИШНЮ МОДЕЛЬ!
*/
          debugPrint('✅ Деталі відео:');
          debugPrint('ID: ${videoDetails['id']}');
          debugPrint('Title: ${videoDetails['title']}');
          debugPrint('Original Text: ${videoDetails['originalText']}');
          debugPrint('Modified Text: ${videoDetails['modifiedText']}');

          // Можемо передати деталі у діалогове вікно
        } else {
          debugPrint('⚠️ Помилка: ${responseData['errors']}');
        }
      } else {
        debugPrint('❌ Запит завершився з помилкою: ${response.statusCode}');
      }
    } catch (error) {
      debugPrint('❗ Виникла помилка: $error');
    }
  }
}
