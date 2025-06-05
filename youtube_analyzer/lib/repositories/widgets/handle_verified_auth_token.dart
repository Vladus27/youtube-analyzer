import 'package:flutter/material.dart';
import 'package:youtube_analyzer/common/database.dart';
import 'package:youtube_analyzer/repositories/widgets/show_unauthorized_dialog.dart';
import 'package:youtube_analyzer/repositories/youtube_repository.dart';

Future<void> handleVerifiedAuthTokenAsync(
    {required BuildContext ctx, String title = 'Access denied'}) async {
  var authToken = Database.get(Database.personAuthTokenKey);
  debugPrint('handleVerifiedAuthTokenAsync, a ti pracuesh vzagali???');
  final message = 'Your verification code: \n$authToken is out of date. To continue, log in to the system';

  final isVerifiedToken = await YoutubeRepository().checkPersonAuthTokenKey(authToken);

  if (!ctx.mounted) return; 

  if (!isVerifiedToken) {
    Database.set(Database.personAuthTokenKey, 'empty');
    showDialog(
      context: ctx,
      barrierDismissible: false,
      builder: (context) => ShowUnauthorizedDialog(
        title: title,
        content: message,
      ),
    );
  }
}
