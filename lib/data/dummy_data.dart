import 'package:flutter/material.dart';
import 'package:youtube_analyzer/common/database.dart';
import 'package:youtube_analyzer/models/youtube.dart';

List<Youtuber> youtubers = [
  Youtuber(id: '1', name: 'Freezy code', logo: 'lib/assets/image1.jpg', username: 'link'),
  Youtuber(id: '2', name: 'Dushnila', logo: 'lib/assets/image1.jpg', username: 'link'),
  Youtuber(id: '1', name: 'GenTrade', logo: 'lib/assets/image1.jpg', username: 'link')
];

List<VideoContent> content = [
  // VideoContent(title: 'Dart is God language', id: 'Freezy code', color: Colors.green, channelId: ''),
  // VideoContent(title: 'C# is bullshit', id: 'Freezy code', color: Colors.blue,channelId: ''),
  // VideoContent(title: 'Lazy code', id: 'Dushnila',channelId: ''),
  // VideoContent(title: 'How to cook flutter', id: 'Dushnila',color:  Colors.blue,channelId: ''),
  // VideoContent(title: 'Short Bitcoin from \$98k', id: 'GenTrade',channelId: ''),
  // VideoContent(title: 'Short Solana from \$23', id: 'GenTrade',channelId: ''),
];


const String basicUrl = 'westeuv1-uiapi2387d-webpi-dev.azurewebsites.net';

String basicXtocen = Database.get(Database.personAuthTokenKey);
//'34e0d199aaf64abebfe9bde5c5b18730';