import 'package:flutter/material.dart';
import 'package:youtube_analyzer/features/login_page/widgets/login_page_hyper_text.dart';

class LoginPageHeader extends StatelessWidget {
  const LoginPageHeader({
    super.key,
    required this.headerText,
    required this.startText,
    required this.hyperText,
    required this.endText,
  });
  final String headerText;
  final String startText;
  final String hyperText;
  final String endText;

  @override
  Widget build(BuildContext context) {
    final txtTheme = Theme.of(context).textTheme;
    return Center(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text(
            headerText,
            style: txtTheme.displaySmall,
          ),
          const SizedBox(height: 12),
          LoginPageHyperText(
            startText: startText,
            hyperText: hyperText,
            endText: endText,
          ),
          const SizedBox(height: 48),
        ],
      ),
    );
  }
}
