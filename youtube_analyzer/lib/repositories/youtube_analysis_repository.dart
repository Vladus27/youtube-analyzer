import 'package:flutter/foundation.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:youtube_analyzer/common/database.dart';

import 'package:youtube_analyzer/repositories/models/environment.dart';
import 'package:youtube_analyzer/repositories/models/youtube_analysis.dart';

class YoutubeAnalysisRepository {
  void _printTextInDebugMode(String text) {
    if (!kReleaseMode) {
      debugPrint(text);
    }
  }

  final String _basicUrl = Environment.apiUrl;

  Future<CreateNewScenario?> postCreateNewScenario() async {
    final token = await Database.get(Database.personAuthTokenKey);
    final url =
        Uri.https(_basicUrl, "/api/YouTubeAnalysis/create-new-scenario");

    final response = await http.post(
      url,
      headers: {
        'x-service-name': 'SocialMediaApi',
        'x-token': token,
      },
    );

    final data = json.decode(response.body);

    if (data['IsOk']) {
      final dataValue = data['value'] as Map<String, dynamic>;
      final newScenario = CreateNewScenario.fromJson(dataValue);

      return newScenario;
    }
    return null;
  }

  Future<UpdateScenario?> putUpdateScenario() async {
    final token = await Database.get(Database.personAuthTokenKey);
    final url = Uri.https(_basicUrl, "/api/YouTubeAnalysis/update-scenario");

    final response = await http.put(
      url,
      headers: {
        'x-service-name': 'SocialMediaApi',
        'x-token': token,
      },
    );

    final data = json.decode(response.body);

    if (data['IsOk']) {
      final dataValue = data['value'] as Map<String, dynamic>;
      final updatedScenario = UpdateScenario.fromJson(dataValue);
      return updatedScenario;
    }
    return null;
  }

  Future<List<ScenarioList>> getScenariosList(String channelId) async {
    List<ScenarioList> scenarioList = [];
    final token = await Database.get(Database.personAuthTokenKey);
    final url =
        Uri.https(_basicUrl, "/api/YouTubeAnalysis/scenario-list/$channelId");

    final response = await http.get(
      url,
      headers: {
        'x-service-name': 'SocialMediaApi',
        'x-token': token,
      },
    );

    final data = json.decode(response.body);
    if (data['IsOk']) {
      final dataValue = data['value'] as Map<String, dynamic>;
      final dataItems = dataValue['items'] as List<dynamic>;
      scenarioList = dataItems
          .map((e) => ScenarioList.fromJson(e as Map<String, dynamic>))
          .toList();

      return scenarioList;
    }
    return scenarioList;
  }
}
