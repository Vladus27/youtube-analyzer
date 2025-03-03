import 'package:youtube_analyzer/common/database.dart';
import 'package:youtube_analyzer/models/youtube.dart';
import 'package:youtube_analyzer/repositories/subcription_YT/models/environment.dart';

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


 String basicUrl = Environment.apiUrl;

String basicXtocen = Database.get(Database.personAuthTokenKey);
