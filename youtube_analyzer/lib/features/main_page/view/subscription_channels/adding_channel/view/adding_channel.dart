import 'package:flutter/material.dart';

import 'package:youtube_analyzer/repositories/subcription_channels/models/subscription_channel.dart';
import 'package:youtube_analyzer/repositories/subcription_channels/youtube_repository.dart';

class AddingChannel extends StatefulWidget {
  const AddingChannel({super.key, required this.onAddingChannel});
  final void Function(String username) onAddingChannel;

  @override
  State<AddingChannel> createState() => _AddingChannelState();
}

class _AddingChannelState extends State<AddingChannel> {
  final _formKey = GlobalKey<FormState>();
  final _usernameChannelController = TextEditingController();

  bool isLoading = false;

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
              Text(
                  isSucceed
                      ? 'Youtuber is added succesfully! \n please refresh the page, because the hobby developer messed up '
                      : 'Something went wrong..',
                  textAlign: TextAlign.center),
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

  void _submitNewYotuber() async {
    debugPrint('object');
    String username = _usernameChannelController.text.trim();

    if (username.startsWith('@')) {
      username = username.substring(1); // Видаляємо перший символ
    }

    if (username.isEmpty) {
      _setDialogAlert();
      return;
    }
    if (_formKey.currentState!.validate()) {
      isLoading = true;

      bool isValidChannel = await YoutubeRepository().addChannel(username);

      if (isValidChannel) {
        widget.onAddingChannel(username);
      }

      // if (isValidChannel) {
      //   widget.onAdd Youtuber(
      //     Youtuber(
      //       id: '1', //temp id user
      //       name: _titleChannelController.text,
      //       username: _usernameChannelController.text,
      //       // sets controlers like String values
      //     ),
      //   );
      // } else {}
    }
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
