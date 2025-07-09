import 'package:flutter/foundation.dart';

import 'dart:convert';
//import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:http/http.dart' as http;

import 'package:youtube_analyzer/common/database.dart';
import 'package:youtube_analyzer/repositories/models/environment.dart';
import 'package:youtube_analyzer/repositories/models/subscription_channel.dart';



class YoutubeRepository {

void _printTextInDebugMode(String text){
  if (!kReleaseMode) {
    debugPrint(text);
  }  
}
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
        _printTextInDebugMode('my response: $responseData');

        isAuthorized = responseData['isOk'] == true;
        _printTextInDebugMode('authentication is: $isAuthorized');
      } else if (response.statusCode == 401) {
        _printTextInDebugMode(
            " checkPersonAuth User in unathorized, statusCode: ${response.statusCode}");

        return isAuthorized;
      }
    } catch (e) {
      _printTextInDebugMode(' Виникла помилка: $e');
    }
    return isAuthorized;
  }

  Future addChannel(String username) async {
    final token = await Database.get(Database.personAuthTokenKey);
    final url = Uri.https(_basicUrl, "/api/youtube/add-channel/$username");

    final response = await http.post(
      url,
      headers: {
        'x-service-name': 'SocialMediaApi',
        'x-token': token,
      },
    );
    if (response.statusCode == 401) {
      _printTextInDebugMode('this piece of code is excecute');
    }
    
    _printTextInDebugMode('Status code when adding Youtuber: ${response.statusCode}');
    final data = json.decode(response.body);

    if (data['isOk']) {
      final dataValue = data['value'] as Map<String, dynamic>;
      final SubscriptionChannel addedChannel =
          SubscriptionChannel.fromJson(dataValue);
      return addedChannel;
    } else {
      return null;
    }
  }

  // return isAdded;

  Future<List<SubscriptionChannel>> getChannelList() async {
    final token = await Database.get(Database.personAuthTokenKey);
    final url = Uri.https(_basicUrl, "/api/youtube/get-channel-list");
    List<SubscriptionChannel> subscrtiptionYT = [];

    try {
      final response = await http.get(
        url,
        headers: {
          'x-service-name': 'SocialMediaApi',
          'x-token': token,
        },
      );
      _printTextInDebugMode(response.body);

      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        if (!data['isOk']) {
          _printTextInDebugMode(' Помилка API: ${data['errors']}');
          return subscrtiptionYT;
        }

        final dataValue = data['value'];
        final dataItems = dataValue['items'];

        subscrtiptionYT = dataItems
            .map<SubscriptionChannel>((e) => SubscriptionChannel.fromJson(e))
            .toList();
      } else {
        _printTextInDebugMode(' Помилка HTTP: ${response.statusCode}');
      }
    } catch (e) {
      _printTextInDebugMode(' Виникла помилка: $e');
    }
    return subscrtiptionYT;
  }

  Future<List<VideoContent>> getChannelVideos(String channelId) async {
    final token = await Database.get(Database.personAuthTokenKey);
    List<VideoContent> videos = [];

    final url =
        Uri.https(_basicUrl, "/api/youtube/get-channel-videos/$channelId");
    final response = await http.get(
      url,
      headers: {'x-service-name': 'SocialMediaApi', 'x-token': token},
    );

    final data = json.decode(response.body);
    _printTextInDebugMode('апішка працює корректно!');
    if (response.statusCode != 200) {
      _printTextInDebugMode('Failed to load videos');
      return videos;
    }
    _printTextInDebugMode('апішка працює корректно!');
    final dataValue = data['value'];
    final dataItems = dataValue['items'];
    videos = (dataItems as List)
        .map(
          (videoData) => VideoContent.fromJsonPreview(videoData),
        )
        .toList();
    return videos;
  }

  Future<bool> deleteChannel(String channelId) async {
    final token = await Database.get(Database.personAuthTokenKey);
    final url = Uri.https(_basicUrl, "/api/youtube/delete-channel/$channelId");
    final response = await http.get(
      url,
      headers: {
        'x-service-name': 'SocialMediaApi',
        'x-token': token,
      },
    );

    final responseData = jsonDecode(response.body);
    final isResponseOk = responseData['isOk'];

    return isResponseOk;
  }

  Future<void> setChannelPrompt(String channelId, String prompt) async {
    final token = await Database.get(Database.personAuthTokenKey);
    final url = Uri.https(_basicUrl, "/api/youtube/set-channel-prompt");

    try {
      final response = await http.post(
        url,
        headers: {
          'Content-Type': 'application/json',
          'x-service-name': 'SocialMediaApi',
          'x-token': token,
        },
        body: jsonEncode({
          'channelId': channelId,
          'prompt': prompt,
        }),
      );

      if (response.statusCode == 200) {
        final responseData = jsonDecode(response.body);
        if (responseData['isOk']) {
          _printTextInDebugMode('✅ Промпт успішно встановлено!');
        } else {
          _printTextInDebugMode('⚠️ Помилка: ${responseData['errors']}');
        }
      } else {
        _printTextInDebugMode('❌ Запит завершився з помилкою: ${response.statusCode}');
      }
    } catch (error) {
      _printTextInDebugMode('❗ Виникла помилка: $error');
    }
  }

  Future<void> getVideoDetails(String channelId, String videoId) async {
    final token = await Database.get(Database.personAuthTokenKey);
    final url = Uri.https(
      _basicUrl,
      "/api/youtube/get-video-details/$channelId/$videoId",
    );

    try {
      final response = await http.get(
        url,
        headers: {
          'x-service-name': 'SocialMediaApi',
          'x-token': token,
        },
      );

      if (response.statusCode == 200) {
        final responseData = jsonDecode(response.body);

        _printTextInDebugMode('🔍 Debug API Response: ${responseData.toString()}');

        if (responseData['isOk']) {
          final videoDetails = responseData['value'];

          /*

        Я СОБІ ТАК ВВАЖАЮ, ЩО ТУТ ПОТРІБНО РЕАЛІЗУВАТИ СОРТУВАННЯ ПО АЙДІ ВІДОСА ДЛЯ СПИСКУ МОДЕЛЕЙ
        І ВІДПОВІДНО ПРИСВОЮВАТИ ЇМ ЗНАЧЕННЯ ОРИГІНАЛЬНОГО ТА МОДИФІКОВАНОГО ТЕКСТУ, ЩОБ НЕ СТВОРЮВАТИЄ
        ДОДАТКОВУ ЛИШНЮ МОДЕЛЬ!
*/
          _printTextInDebugMode('✅ Деталі відео:');
          _printTextInDebugMode('ID: ${videoDetails['id']}');
          _printTextInDebugMode('Title: ${videoDetails['title']}');
          _printTextInDebugMode('Original Text: ${videoDetails['originalText']}');
          _printTextInDebugMode('Modified Text: ${videoDetails['modifiedText']}');

          // Можемо передати деталі у діалогове вікно
        } else {
          _printTextInDebugMode('⚠️ Помилка: ${responseData['errors']}');
        }
      } else {
        _printTextInDebugMode('❌ Запит завершився з помилкою: ${response.statusCode}');
      }
    } catch (error) {
      _printTextInDebugMode('❗ Виникла помилка: $error');
    }
  }
}
