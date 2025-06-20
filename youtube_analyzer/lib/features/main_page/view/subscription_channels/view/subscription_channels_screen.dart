import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

import 'package:youtube_analyzer/features/main_page/view/subscription_channels/adding_channel/view/adding_channel_modal_screen.dart';
import 'package:youtube_analyzer/features/main_page/view/subscription_channels/widgets/subscription_channels_list.dart';
import 'package:youtube_analyzer/repositories/widgets/show_snack_bar.dart';

import 'package:youtube_analyzer/repositories/models/subscription_channel.dart';
import 'package:youtube_analyzer/repositories/widgets/handle_verified_auth_token.dart';
import 'package:youtube_analyzer/repositories/youtube_repository.dart';

class SubscriptionsChannelsScreen extends StatefulWidget {
  const SubscriptionsChannelsScreen({
    super.key,
    required this.onSelectedChannelsContent,
    required this.onChannelDeleted,
  });
  final void Function(String channelId, [String channelName])onSelectedChannelsContent;
  final void Function(String channelId) onChannelDeleted;

  @override
  State<SubscriptionsChannelsScreen> createState() =>
      _SubscriptionsChannelsScreenState();
}

class _SubscriptionsChannelsScreenState
    extends State<SubscriptionsChannelsScreen> {
  List<SubscriptionChannel> subscrtiptionYT = [];

  void _printTextInDebugMode(String text) {
    if (!kReleaseMode) {
      debugPrint(text);
    }
  }

  void _deleteChannel(String channelId) async {
    await handleVerifiedAuthTokenAsync(ctx: context);
    final bool isDeleted = await YoutubeRepository().deleteChannel(channelId);
    if (isDeleted) {
      setState(() {
        subscrtiptionYT
            .removeWhere((channel) => channel.channelID == channelId);
      });
      if (mounted) {
        showSnackBar(context, 'Channel has been successfully deleted');
      }
      _printTextInDebugMode("Youtuber is deleted Succsessfully");
      setState(() {});
      widget.onChannelDeleted(channelId);
    } else {
      _printTextInDebugMode("something went wrong");
    }
  }

  void _addChannel(SubscriptionChannel youtuber) {
    setState(
      () {
        subscrtiptionYT.add(youtuber);
      },
    );
  }

  void _loadChannels() async {
    subscrtiptionYT = await YoutubeRepository().getChannelList();
    setState(() {});
  }

  @override
  void initState() {
    super.initState();
    _loadChannels();
  }

  @override
  Widget build(BuildContext context) {
    final themeColor = Theme.of(context).colorScheme;
    final themeText = Theme.of(context).textTheme;
    return Scaffold(
      backgroundColor: themeColor.surface,
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          showDialog(
            context: context,
            builder: (ctx) => Dialog(
              child: ConstrainedBox(
                constraints: const BoxConstraints(
                  maxWidth: 512,
                ),
                child: AddingChannelModalScreen(
                  onAddingChannel: _addChannel,
                  channelsList: subscrtiptionYT,
                ),
              ),
            ),
          );
        },
        tooltip: 'Add new youtuber',
        child: const Icon(Icons.add),
      ),
      body: subscrtiptionYT.isEmpty
          ? Center(
              child: Text(
                'Add any Youtuber to see their content',
                style: themeText.titleLarge!.copyWith(
                  color: themeColor.secondary,
                ),
                textAlign: TextAlign.center,
              ),
            )
          : SubscriptionChannelsList(
              subscrtiptionYT: subscrtiptionYT,
              onSelectedChannel: widget.onSelectedChannelsContent,
              onDeleteChannel: _deleteChannel,
            ),
    );
  }
}
