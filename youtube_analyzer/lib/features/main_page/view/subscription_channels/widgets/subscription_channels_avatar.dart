import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';

class SubscriptionChannelsAvatar extends StatelessWidget {
  const SubscriptionChannelsAvatar({super.key, required this.channelImageUrl});
  final String channelImageUrl;

  @override
  Widget build(BuildContext context) {
    return CachedNetworkImage(
      imageUrl: channelImageUrl,
      imageBuilder: (context, imageProvider) => CircleAvatar(
        backgroundImage: imageProvider,
      ),
      placeholder: (context, url) => const CircleAvatar(
        child: CircularProgressIndicator(strokeWidth: 2),
      ),
      errorWidget: (context, url, error) => const CircleAvatar(
        backgroundImage: AssetImage('lib/assets/image1.jpg'),
      ),
    );
  }
}
