import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';




class LoginPageHyperText extends StatelessWidget {
  const LoginPageHyperText({
    super.key,
    required this.startText,
    required this.hyperText,
    required this.endText,
  });
  final String startText;
  final String hyperText;
  final String endText;


void _printTextInDebugMode(String text){
  if (!kReleaseMode) {
    debugPrint(text);
  }  
}
  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    final Uri botUrl = Uri.parse('https://t.me/piescript_bot');
    Future<void> openTelegram() async {
      try {
        await launchUrl(botUrl, mode: LaunchMode.platformDefault);
      } catch (e) {
        _printTextInDebugMode('Could not launch $botUrl: $e');
      }
    }

    return RichText(
      text: TextSpan(
        text: startText,
        style: theme.textTheme.titleMedium,
        children: [
          WidgetSpan(
            child: MouseRegion(
              cursor: SystemMouseCursors.click,
              child: GestureDetector(
                onTap: () {
                  print('You pressed, respect');
                  openTelegram();
                },
                child: Container(
                  decoration: BoxDecoration(
                    border: Border(
                      bottom: BorderSide(
                        color: theme.colorScheme.primary,
                      ),
                    ),
                  ),
                  child: Text(
                    hyperText,
                    style: theme.textTheme.titleMedium!.copyWith(
                      color: theme.colorScheme.primary,
                    ),
                  ),
                ),
              ),
            ),
          ),
          // TextSpan(
          //   text: 'telegram bot',
          //   style:theme
          //       .textTheme
          //       .titleMedium!
          //       .copyWith(
          //           color:
          //               theme.colorScheme.primary,
          //           decoration: TextDecoration.underline,
          //           height: 3),
          //   recognizer: TapGestureRecognizer()
          //     ..onTap = () {
          //       // Action when link is clicked
          //       print('Link clicked!');
          //     },
          // ),
          TextSpan(
            text: endText,
          ),
        ],
      ),
    );
  }
}
