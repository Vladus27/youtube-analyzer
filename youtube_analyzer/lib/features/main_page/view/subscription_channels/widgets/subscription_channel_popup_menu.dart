import 'package:flutter/material.dart';
import 'package:youtube_analyzer/features/main_page/view/subscription_channels/prompt_channel/view/prompt_channel_modal_screen.dart';

class SubscriptionChannelPopupMenu extends StatelessWidget {
  const SubscriptionChannelPopupMenu({
    super.key,
    required this.channelID,
    required this.deleteChannel,
  });
  final String channelID;
  final void Function(String channelId) deleteChannel;

  @override
  Widget build(BuildContext context) {
    return PopupMenuButton(
      itemBuilder: (ctx) => [
        PopupMenuItem(
          value: 'Delete',
          onTap: () {
            deleteChannel(channelID);
          },
          child: const Text('Delete'),
        ),
        PopupMenuItem(
          value: 'Prompt',
          onTap: () {
            showDialog(
              context: context,
              builder: (ctx) => Dialog(
                child: ConstrainedBox(
                  constraints: const BoxConstraints(
                    maxWidth: 512,
                  ),
                  child: PromptChannelModalScreen(
                    channelId: channelID,
                  ),
                ),
              ),
            );
          },
          child: const Text('Prompt'),
        ),
      ],
    );
  }
}
