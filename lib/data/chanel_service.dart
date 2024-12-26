import 'dart:convert';
import 'package:http/http.dart' as http;

import 'package:youtube_analyzer/data/dummy_data.dart'; // import basic url and token

class ChannelService {
  static const String _baseUrl = basicUrl;

  // Додавання нового каналу
  static Future<bool> addChannel(String channelUsername) async {
    final url =
        Uri.https(_baseUrl, '/api/youtube/add-channel/$channelUsername');

    final response = await http.post(url);

    if (response.statusCode == 200) {
      final data = jsonDecode(response.body);
      return data['isOk'] == true;
    }

    return false;
  }

  // Отримання списку каналів
  static Future<List<dynamic>> getChannels() async {
    final url = Uri.https(_baseUrl, '/api/youtube/get-channel-list');
    final response = await http.get(
      url,
      headers: {'x-service-name': 'SocialMediaApi', 'x-token': basicXtocen},
    );
    if (response.statusCode == 200) {
      final data = jsonDecode(response.body);
      if (data['isOk'] == true) {
        return data['value']['items'];
      }
    }
    return [];
  }
}
