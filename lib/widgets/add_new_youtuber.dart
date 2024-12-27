import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:youtube_analyzer/common/database.dart';
import 'package:youtube_analyzer/data/chanel_service.dart';

import 'package:youtube_analyzer/data/dummy_data.dart'; // import basic url and token

import 'package:youtube_analyzer/models/youtube.dart';

class AddNewYoutuber extends StatefulWidget {
  const AddNewYoutuber({super.key, required this.onAddYoutuber});

  final void Function(Youtuber youtuber) onAddYoutuber;

  @override
  State<AddNewYoutuber> createState() {
    return _AddNewYoutuberState();
  }
}

class _AddNewYoutuberState extends State<AddNewYoutuber> {
  final _formKey = GlobalKey<FormState>();
  final _usernameChannelController = TextEditingController();

  bool _isLoading = false;

  void _circularLoad() {
    showDialog(
      context: context,
      builder: (ctx) => const Dialog(
        child: SizedBox(
          height: 200,
          width: 250,
          child: Center(
            child: CircularProgressIndicator(),
          ),
        ),
      ),
    );
  }

  void _isSucceedRequest(bool isSucceed) {
    showDialog(
      context: context,
      builder: (ctx) => Dialog(
        child: SizedBox(
          height: 200,
          width: 250,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(isSucceed
                  ? 'Youtuber is added succesfully'
                  : 'Something went wrong..'),
              const SizedBox(
                height: 24,
              ),
              ElevatedButton(
                onPressed: () {
                  
                  Navigator.of(context).pop();
                },
                child: const Text('Ok'),
              )
            ],
          ),
        ),
      ),
    );
  }

  void _setDialogAlert() {
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        title: const Text("Invalid input"),
        content:
            const Text("Please make sure a valid chanel username was entered"),
        actions: [
          TextButton(
            onPressed: () {
              Navigator.pop(ctx);
            },
            child: const Text("Okay"),
          )
        ],
      ),
    );
  }

  Future<bool> _validateChannel(String username) async {
    final url = Uri.https(basicUrl, "/api/youtube/add-channel/$username");

    final response = await http.post(
      url,
      headers: {
        'x-service-name': 'SocialMediaApi',
        'x-token': Database.get(Database.personAuthTokenKey),
      },
    );

    print('Status code when adding Youtuber: ${response.statusCode}');

    return response.statusCode == 200;
  }

  void _submitNewYotuber() async {
    print('object');
    String username = _usernameChannelController.text.trim();

    if (username.startsWith('@')) {
      username = username.substring(1); // Видаляємо перший символ
    }

    if (username.isEmpty) {
      _setDialogAlert();
      return;
    }
    if (_formKey.currentState!.validate()) {
      _isLoading = true;

      if (_isLoading) {
        _circularLoad();
      }

      bool isValidChannel = await _validateChannel(username);

      // if (isValidChannel) {
      //   widget.onAddYoutuber(
      //     Youtuber(
      //       id: '1', //temp id user
      //       name: _titleChannelController.text,
      //       username: _usernameChannelController.text,
      //       // sets controlers like String values
      //     ),
      //   );
      // } else {}

      if (!context.mounted) {
        return;
      }

      _isLoading = false;

      Navigator.of(context).pop();

      _isSucceedRequest(isValidChannel);
    }
  }

  @override
  void initState() {
    super.initState();
  }

  @override
  void dispose() {
    _usernameChannelController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 48),
      child: Form(
        key: _formKey,
        autovalidateMode: AutovalidateMode.onUserInteraction,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              'Enter Youtuber here',
              style: Theme.of(context)
                  .textTheme
                  .titleLarge!
                  .copyWith(color: Theme.of(context).colorScheme.primary),
            ),
            const SizedBox(
              height: 24,
            ),
            Expanded(
              child: TextFormField(
                validator: (value) {
                  if (value!.startsWith('@')) {
                    return "remove '@'";
                  }
                  return null;
                },
                controller: _usernameChannelController,
                maxLength: 50,
                keyboardType: TextInputType.text,
                decoration: InputDecoration(
                  label: const Text('Channel username'),
                  prefix: const Text("@"),
                  errorStyle:
                      TextStyle(color: Theme.of(context).colorScheme.error),
                ),
              ),
            ),
            const SizedBox(
              height: 12,
            ),
            Row(
              children: [
                ElevatedButton(
                  onPressed: () {
                    Navigator.pop(context);
                  },
                  child: const Text('Cancel'),
                ),
                const Spacer(),
                ElevatedButton(
                  onPressed: _submitNewYotuber,
                  child: const Text('Save'),
                ),
              ],
            )
          ],
        ),
      ),
    );
  }
}
