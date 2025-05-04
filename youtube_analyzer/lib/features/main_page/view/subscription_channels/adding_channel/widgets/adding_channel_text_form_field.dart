import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class AddingChannelTextFormField extends StatelessWidget {
  const AddingChannelTextFormField(
      {super.key, required this.channelUsernameController});
  final TextEditingController channelUsernameController;

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      controller: channelUsernameController,
      maxLength: 50,
      keyboardType: TextInputType.text,
      inputFormatters: [
        FilteringTextInputFormatter.allow(
          RegExp(r'[a-zA-Z0-9_]'), // only Latin letters, numbers and "_"
        ),
      ],
      decoration: InputDecoration(
        label: const Text('Channel username'),
        prefix: const Text("@"),
        errorStyle: TextStyle(color: Theme.of(context).colorScheme.error),
      ),
    );
  }
}
