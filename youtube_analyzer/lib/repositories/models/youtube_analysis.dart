import 'package:flutter/material.dart';

enum Properties { bool, string, decimal, object }

extension PropertiesExtension on Properties {
  String get name {
    switch (this) {
      case Properties.bool:
        return 'Bool';
      case Properties.string:
        return 'String';
      case Properties.decimal:
        return 'Decimal';
      case Properties.object:
        return 'Object';
    }
  }

  IconData get icon {
    switch (this) {
      case Properties.bool:
        return Icons.question_mark_rounded;
      case Properties.string:
        return Icons.text_fields;
      case Properties.decimal:
        return Icons.numbers_outlined;
      case Properties.object:
        return Icons.data_object_outlined;
    }
  }

  static Properties fromName(String name) {
    switch (name) {
      case 'Bool':
        return Properties.bool;
      case 'String':
        return Properties.string;
      case 'Decimal':
        return Properties.decimal;
      case 'Object':
        return Properties.object;
      default:
        throw ArgumentError('Unknown propertyType: $name');
    }
  }
}

class Property {
  final String key;
  final String prompt;
  final String description;
  final Properties propertyType;
  final bool isArray;

  Property({
    required this.key,
    required this.prompt,
    required this.description,
    required this.propertyType,
    required this.isArray,
  });

  factory Property.fromJson(Map<String, dynamic> json) => Property(
        key: json['key'],
        prompt: json['prompt'],
        description: json['description'],
        propertyType: PropertiesExtension.fromName(json['propertyType']),
        isArray: json['isArray'],
      );

  Map<String, dynamic> toJson() => {
        'key': key,
        'prompt': prompt,
        'description': description,
        'propertyType': propertyType.name,
        'isArray': isArray,
      };
}

class CreateNewScenario {
  CreateNewScenario({
    required this.channelId,
    required this.title,
    required this.description,
    required this.isLive,
    required this.properties,
  });
  final String channelId;
  final String title;
  final String description;
  final bool isLive;
  final List<Property> properties;

  factory CreateNewScenario.fromJson(Map<String, dynamic> json) {
    final propertiesJson = json['properties'] as List<dynamic>;
    final properties = propertiesJson
        .map((e) => Property.fromJson(e as Map<String, dynamic>))
        .toList();
    return CreateNewScenario(
      channelId: json['channelId'] as String,
      title: json['title'] as String,
      description: json['description'] as String,
      isLive: json['isLive'] as bool,
      properties: properties,
    );
  }
}

class ScenarioList {
  ScenarioList({
    required this.id,
    required this.channelId,
    required this.title,
    required this.description,
    required this.isLive,
  });
  final String id;
  final String channelId;
  final String title;
  final String description;
  final bool isLive;

  factory ScenarioList.fromJson(Map<String, dynamic> json) {
    return ScenarioList(
      id: json['id'] as String,
      channelId: json['channelId'] as String,
      title: json['title'] as String,
      description: json['description'] as String,
      isLive: json['isLive'] as bool,
    );
  }
}

class UpdateScenario {
  UpdateScenario({
    required this.id,
    required this.channelId,
    required this.title,
    required this.description,
    required this.isLive,
    required this.properties,
  });
  final String id;
  final String channelId;
  final String title;
  final String description;
  final bool isLive;
  final List<Property> properties;

  factory UpdateScenario.fromJson(Map<String, dynamic> json) {
    final propertiesJson = json['properties'] as List<dynamic>;
    final properties = propertiesJson
        .map((e) => Property.fromJson(e as Map<String, dynamic>))
        .toList();
    return UpdateScenario(
      id: json['id'] as String,
      channelId: json['channelId'] as String,
      title: json['title'] as String,
      description: json['description'] as String,
      isLive: json['isLive'] as bool,
      properties: properties,
    );
  }
}

class RunScenario {
  RunScenario({
    required this.scenarioId,
  });
  final String scenarioId;

  factory RunScenario.fromJson(Map<String, dynamic> json) {
    return RunScenario(
      scenarioId: json['scenarioId'] as String,
    );
  }
}

class ScenarioCryptoAssetValues {
  ScenarioCryptoAssetValues({
    required this.scenarioId,
    required this.cryptoAsset,
    required this.interval,
  });

  final String scenarioId;
  final String cryptoAsset;
  final int interval;

  factory ScenarioCryptoAssetValues.fromJson(Map<String, dynamic> json) {
    return ScenarioCryptoAssetValues(
      scenarioId: json['scenarioId'] as String,
      cryptoAsset: json['cryptoAsset'] as String,
      interval: json['interval'] as int,
    );
  }
}

class ScenarioValue {}

class AddScenarioProperty {
  AddScenarioProperty({
    required this.scenarioId,
    required this.key,
    required this.prompt,
    required this.description,
    required this.propertyType,
    required this.isArray,
  });
  final String scenarioId;
  final String key;
  final String prompt;
  final String description;
  final String propertyType;
  final bool isArray;

  factory AddScenarioProperty.fromJson(Map<String, dynamic> json) {
    return AddScenarioProperty(
      scenarioId: json['scenarioId'] as String,
      key: json['key'] as String,
      prompt: json['prompt'] as String,
      description: json['description'] as String,
      propertyType: json['propertyType'] as String,
      isArray: json['isArray'] as bool,
    );
  }
}

class UpdateScenarioProperty {
  UpdateScenarioProperty({
    required this.scenarioId,
    required this.key,
    required this.prompt,
    required this.description,
    required this.propertyType,
    required this.isArray,
    required this.recreateHistory,
  });
  final String scenarioId;
  final String key;
  final String prompt;
  final String description;
  final String propertyType;
  final bool isArray;
  final bool recreateHistory;

  factory UpdateScenarioProperty.fromJson(Map<String, dynamic> json) {
    return UpdateScenarioProperty(
      scenarioId: json['scenarioId'],
      key: json['key'],
      prompt: json['prompt'],
      description: json['description'],
      propertyType: json['propertyType'],
      isArray: json['isArray'],
      recreateHistory: json['recreateHistory'],
    );
  }
}

class RemoveScenarioProperty {
  RemoveScenarioProperty({
    required this.scenarioId,
    required this.key,
  });
  final String scenarioId;
  final String key;

  factory RemoveScenarioProperty.fromJson(Map<String, dynamic> json) {
    return RemoveScenarioProperty(
      scenarioId: json['scenarioId'],
      key: json['key'],
    );
  }
}

class ScenarioPropertyList {
  ScenarioPropertyList({
    required this.id,
    required this.name,
    required this.description,
    required this.prompt,
    required this.language,
    required this.propertyType,
    required this.isArray,
  });

  final String id;
  final String name;
  final String description;
  final String prompt;
  final String language;
  final String propertyType;
  final bool isArray;

  factory ScenarioPropertyList.fromJson(Map<String, dynamic> json) {
    return ScenarioPropertyList(
      id: json['id'],
      name: json['name'],
      description: json['description'],
      prompt: json['prompt'],
      language: json['language'],
      propertyType: json['propertyType'],
      isArray: json['isArray'],
    );
  }
}
