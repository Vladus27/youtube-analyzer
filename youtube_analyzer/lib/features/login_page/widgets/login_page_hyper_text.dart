import 'package:flutter/material.dart';

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

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

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
                  print('You pressed');
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
