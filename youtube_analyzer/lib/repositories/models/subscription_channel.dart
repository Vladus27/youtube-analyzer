import 'package:flutter/material.dart';

class SubscriptionChannel {
  //create a model with needed fields
  SubscriptionChannel({
    required this.channelID,
    required this.channelTitle,
    required this.username,
    required this.aiPrompt,
    required this.promptProperties,
    required this.channelImageUrl,
  });
  final String channelID;
  final String channelTitle;
  final String username;
  final String? aiPrompt;
  final List promptProperties;
  final String channelImageUrl;

  factory SubscriptionChannel.fromJson(Map<String, dynamic> json) {
    return SubscriptionChannel(
      channelID: json['id'],
      channelTitle: json['title'],
      username: json['username'],
      aiPrompt: json['aiPrompt'],
      promptProperties: ['promptProperties'],
      channelImageUrl: json['imageUrl'],
    );
  }
}

class VideoContent {
  VideoContent({
    required this.videoId,
    required this.videoTitle,
    required this.recognitionState,
    required this.externalId,
    this.color = Colors.amber,
  });
  final String videoId;
  final String videoTitle;
  final int recognitionState;
  final String externalId;
  final Color color;

  factory VideoContent.fromJsonPreview(Map<String, dynamic> json) {
    return VideoContent(
        videoId: json['id'],
        videoTitle: json['title'],
        externalId: json['externalId'],
        recognitionState: json['recognitionState']);
  }
}

class VideoText {
  VideoText({
    required this.channelId,
    this.originalText,
    this.modifiedText,
  });
  final String channelId;
  final String? originalText;
  final String? modifiedText;

  factory VideoText.fromJson(Map<String, dynamic> json) {
    return VideoText(
      channelId: json['id'],
      originalText: json['originalText'],
      modifiedText: json['modifiedText'],
    );
  }
}
