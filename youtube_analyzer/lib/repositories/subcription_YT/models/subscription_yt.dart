class SubscriptionYt {
  //create a model with needed fields
  SubscriptionYt({
    required this.youtuberID,
    required this.youtuberTitle,
    required this.aiPrompt,
    required this.youtuberImageUrl,
  });
  final String youtuberID;
  final String youtuberTitle;
  final String? aiPrompt;
  final String youtuberImageUrl;

  factory SubscriptionYt.fromJson(Map<String, dynamic> json) {
    return SubscriptionYt(
      youtuberID: json['id'],
      youtuberTitle: json['title'],
      aiPrompt: json['aiPrompt'],
      youtuberImageUrl: json['imageUrl'],
    );
  }
}

class VideoContent {
  VideoContent({
    required this.videoId,
    required this.videoTitle,
    required this.recognitionState,
  });
  final String videoId;
  final String videoTitle;
  final int recognitionState;

  factory VideoContent.fromJsomPreview(Map<String, dynamic> json) {
    return VideoContent(
        videoId: json['id'],
        videoTitle: json['title'],
        recognitionState: json['recognitionState']);
  }
}

class VideoText {
  VideoText({
    this.originalText,
    this.modifiedText,
  });
  final String? originalText;
  final String? modifiedText;

  factory VideoText.fromJson(Map<String, dynamic> e) {
    return VideoText(
      originalText: e['originalText'],
      modifiedText: e['modifiedText'],
    );
  }
}
