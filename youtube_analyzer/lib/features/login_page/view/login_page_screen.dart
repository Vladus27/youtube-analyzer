import 'package:flutter/material.dart';
import 'package:youtube_analyzer/features/login_page/platform_features/view/platform_features_screen.dart';
import 'package:youtube_analyzer/features/login_page/widgets/login_page_group_items.dart';
import 'package:youtube_analyzer/features/login_page/widgets/widgets.dart';

class LoginPageScreen extends StatelessWidget {
  const LoginPageScreen({super.key});
  @override
  Widget build(BuildContext context) {
    final screen = MediaQuery.of(context).size;
    return Scaffold(
      backgroundColor: Theme.of(context).colorScheme.surface,      
      body: SingleChildScrollView(
        child: Column(
          children: [
            SizedBox(
              height: screen.height,
              width: screen.width,
              child: const Row(
                children: [
                  Expanded(
                    flex: 5,
                    child: LoginPageTitle(title: 'YouTube Analyzer'),
                  ),
                  Expanded(
                    flex: 5,
                    child: LoginPageGroupItems(),
                  ),
                ],
              ),
            ),
            const PlatformFeaturesScreen(),
          ],
        ),
      ),
    );
  }
}
