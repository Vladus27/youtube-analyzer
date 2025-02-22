import 'dart:convert';
import 'package:http/http.dart' as http;

import 'package:flutter/material.dart';

import 'package:youtube_analyzer/data/dummy_data.dart';




class DialogPrompt extends StatefulWidget {
  const DialogPrompt({super.key, required this.channelId});

  final String channelId;

  @override
  State<DialogPrompt> createState() => _DialogPromptState();
}

class _DialogPromptState extends State<DialogPrompt> {
  final _promptControler = TextEditingController();



    Future<void> setChannelPrompt(String channelId, String prompt) async {
  final url = Uri.https(basicUrl, "/api/youtube/set-channel-prompt");
  
  try {
    final response = await http.post(
      url,
      headers: {
        'Content-Type': 'application/json',
        'x-service-name': 'SocialMediaApi',
        'x-token': basicXtocen,
      },
      body: jsonEncode({
        'channelId': channelId,
        'prompt': prompt,
      }),
    );

    if (response.statusCode == 200) {
      final responseData = jsonDecode(response.body);
      if (responseData['isOk']) {
        print('✅ Промпт успішно встановлено!');
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

  @override
  void dispose() {
    _promptControler.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: 550,
      height: 300,
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 48),
        child: Column(
          children: <Widget>[
            TextField(            
              controller: _promptControler,
              keyboardType: TextInputType.text,              
              maxLength: 500,
              maxLines: 4,
              decoration:  InputDecoration(
                hintText: "Enter your text here",  
                filled: true,
                fillColor: Theme.of(context).colorScheme.surfaceContainer,
                                              
              ),
            ),
            const Spacer(),
            Row(
              children: [
                ElevatedButton(
                  onPressed: () {
                    Navigator.pop(context);
                  },
                  child: const Text('Cancle'),
                ),
                const Spacer(),
                ElevatedButton(
                  onPressed: () {
                    setChannelPrompt(widget.channelId, _promptControler.text);


                    Navigator.pop(context);
                  },
                  child: const Text('Send'),
                ),
              ],
            )
          ],
        ),
      ),
    );
  }
}
