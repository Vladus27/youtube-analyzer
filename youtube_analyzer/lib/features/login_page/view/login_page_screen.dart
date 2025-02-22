import 'package:flutter/material.dart';
import 'package:youtube_analyzer/features/login_page/widgets/widgets.dart';

class LoginPageScreen extends StatelessWidget {
  const LoginPageScreen({super.key});
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).colorScheme.surface,
      body: const Row(
        children: [
          Expanded(
            flex: 5,
            child: LoginPageTitle(title: 'YouTube Analyzer'),
          ),
          Expanded(
            flex: 5,
            child: Center(
              child: SizedBox(
                height: 500,
                width: 450,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    LoginPageHeader(
                      headerText: 'Let`s Sing Up!',
                      startText: 'Hey. Enter verification code from  ',
                      hyperText: 'telegram bot',
                      endText: '  to get sign in to your account.',
                    ),                    
                    LoginPageVerification(titleField: 'Verification code')
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
