import 'package:flutter/material.dart';

import 'package:youtube_analyzer/features/main_page/view/subscription_channels/widgets/subscription_channel_popup_menu.dart';
import 'package:youtube_analyzer/features/main_page/view/subscription_channels/widgets/subscription_channels_avatar.dart';
import 'package:youtube_analyzer/repositories/models/subscription_channel.dart';

class SubscriptionChannelsList extends StatefulWidget {
  const SubscriptionChannelsList({
    super.key,
    required this.subscrtiptionYT,
    required this.onSelectedChannel,
    required this.onDeleteChannel,
  });
  final List<SubscriptionChannel> subscrtiptionYT;
  final void Function(String author, [String channelTitle]) onSelectedChannel;
  final void Function(String channelID) onDeleteChannel;

  @override
  State<SubscriptionChannelsList> createState() =>
      _SubscriptionChannelsListState();
}

class _SubscriptionChannelsListState extends State<SubscriptionChannelsList> {
  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      itemCount: widget.subscrtiptionYT.length,
      itemBuilder: (ctx, index) {
        final listIdx = widget.subscrtiptionYT[index];
        final String channelImageUrl = listIdx.channelImageUrl;
        final String channelId = listIdx.channelID;
        final String channelTitle = listIdx.channelTitle;


        return Card(
          child: ListTile(
            leading: SubscriptionChannelsAvatar(
              channelImageUrl: channelImageUrl,
            ),
            trailing: SubscriptionChannelPopupMenu(
              channelID: channelId,
              deleteChannel: widget.onDeleteChannel,
            ),
            title: Text(channelTitle),
            onTap: () {
              widget.onSelectedChannel(channelId, channelTitle);
            },
          ),
        );
      },
    );
  }
}
