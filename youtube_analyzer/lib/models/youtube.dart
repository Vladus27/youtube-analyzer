import 'package:flutter/material.dart';

class Youtuber {
  Youtuber(
      {required this.id,
      required this.name,
      this.logo = 'lib/assets/image1.jpg',
      this.username ='',
      this.aiPrompt});

  final String id;
  final String name;
  final String logo;
  final String username;
  final String? aiPrompt;

  factory Youtuber.fromJson(Map<String, dynamic> json) {
    return Youtuber(
      id: json['id'] ?? '',
      name: json['title'] ?? 'No Title',
      aiPrompt: json['aiPrompt'],
    );
  }

  // Конструктор для конвертації JSON в об'єкт Youtuber
  // factory Youtuber.fromJson(Map<String, dynamic> json) {
  //   return Youtuber(
  //     name: json['name'],
  //     logo: json['logo'],
  //     link: json['link'],
  //   );
  // }
}

class VideoContent {
  VideoContent({
    required this.title,
    required this.id,
    this.color = Colors.amber,
    this.originalText,
    this.modifiedText,
    //required this.channelId
  });

  final String title;
  final String id;
  final Color color;
  final String? originalText; // Оригінальний текст (якщо API повертає)
  final String? modifiedText; // Модифікований текст (якщо API повертає)
 // final String channelId;


   // Фабричний конструктор для створення з JSON
  factory VideoContent.fromJson(Map<String, dynamic> json) {
    return VideoContent(
      id: json['id'] ?? '',
      //channelId: json['channelId'] ?? 'noChannelId', // Додано
      title: json['title'] ?? 'No Title',
      originalText: json['originalText'] ?? 'no original text ',
      modifiedText: json['modifiedText'] ?? 'no modified text',
    );
  }

  // Метод для конвертації у JSON (якщо потрібно для POST-запитів)
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'title': title,
      'originalText': originalText,
      'modifiedText': modifiedText,
    };
  }
}

// models for integration with APIs
class VideoContentApi {}

class ChannelApi {
  ChannelApi({required this.id, required this.title, required this.aiPrompt});
  final String id;
  final String title;
  final String? aiPrompt;

  factory ChannelApi.fromJson(Map<String, dynamic> json) => ChannelApi(
        id: json['id'],
        title: json['title'],
        aiPrompt: json['aiPrompt'],
      );

  static List<ChannelApi> fromList(List<dynamic> jsonList) {
    final List<ChannelApi> list = <ChannelApi>[];
    for (final elementJson in jsonList) {
      try {
        final obj = ChannelApi.fromJson(elementJson as Map<String, dynamic>);
        list.add(obj);
      } catch (e) {
        print('error $e parsing $elementJson');
      }
    }
    return list;
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'title': title,
      'aiPrompt': aiPrompt,
    };
  }
}

class ChannelApiSingle {
  ChannelApiSingle({required this.channel});
  final List<ChannelApi> channel;
  factory ChannelApiSingle.fromJson(Map<String, dynamic> json) =>
      ChannelApiSingle(
        channel: ChannelApi.fromList(
          json['channel'],
        ),
      );
}
