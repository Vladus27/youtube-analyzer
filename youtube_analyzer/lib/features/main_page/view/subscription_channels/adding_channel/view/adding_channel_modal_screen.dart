import 'package:flutter/material.dart';
import 'package:youtube_analyzer/features/main_page/widgets/form_buttons.dart';
import 'package:youtube_analyzer/features/main_page/view/subscription_channels/adding_channel/widgets/adding_channel_text_form_field.dart';
import 'package:youtube_analyzer/repositories/widgets/show_snack_bar.dart';

import 'package:youtube_analyzer/repositories/models/subscription_channel.dart';
import 'package:youtube_analyzer/repositories/widgets/handle_verified_auth_token.dart';
import 'package:youtube_analyzer/repositories/youtube_repository.dart';

class AddingChannelModalScreen extends StatefulWidget {
  const AddingChannelModalScreen({
    super.key,
    required this.onAddingChannel,
  });
  final void Function(SubscriptionChannel channel) onAddingChannel;

  @override
  State<AddingChannelModalScreen> createState() =>
      _AddingChannelModalScreenState();
}

class _AddingChannelModalScreenState extends State<AddingChannelModalScreen> {
  final _formKey = GlobalKey<FormState>();
  final _usernameChannelController = TextEditingController();

  bool isLoading = false;

  void _setDialogAlert() {
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        title: const Text("Invalid input"),
        content:
            const Text("Please make sure a valid channel username was entered"),
        actions: [
          TextButton(
            onPressed: () {
              Navigator.pop(ctx);
              setState(() {
                isLoading = false;
              });
            },
            child: const Text("Okay"),
          )
        ],
      ),
    );
  }

  void _submitNewChannel() async {
    String username = _usernameChannelController.text.trim();
    debugPrint('submit new channel has work. The username: $username');

    if (username.isEmpty) {
      _setDialogAlert();
      return;
    }
    if (_formKey.currentState!.validate()) {
      setState(() {
        isLoading = true;
      });
      await handleVerifiedAuthTokenAsync(ctx: context);

      final addedChannel = await YoutubeRepository().addChannel(username);
      if (addedChannel != null) {
        widget.onAddingChannel(addedChannel);
        setState(() {
          isLoading = false;
        });
        if(mounted){
          Navigator.pop(context);
          showSnackBar(context, 'Channel has been successfully added');
        }
      } else {
        _setDialogAlert();
      }
    }
  }

  @override
  void dispose() {
    _usernameChannelController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    final textThemeTitleL = Theme.of(context).textTheme.titleLarge!;
    final textThemeTitleM = Theme.of(context).textTheme.titleMedium!;

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 48),
      child: Form(
        key: _formKey,
        autovalidateMode: AutovalidateMode.onUserInteraction,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Text(
              'Enter Youtuber here',
              textAlign: TextAlign.center,
              style: textThemeTitleL.copyWith(color: colorScheme.primary),
            ),
            const SizedBox(height: 24),
             Text('Enter the channel username to subscribe and analyze videos',
            style: textThemeTitleM.copyWith(color: colorScheme.secondary),
            ),
            const SizedBox(height: 12),
            AddingChannelTextFormField(
              channelUsernameController: _usernameChannelController,
            ),
            const SizedBox(height: 12),
            FormButtons(
              func: _submitNewChannel,
              btnLabel: 'Subscribe',            
              btnIcon: Icons.add_alert_rounded,
              isLoading: isLoading,
            ),
          ],
        ),
      ),
    );
  }
}
