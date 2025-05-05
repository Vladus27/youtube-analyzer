import 'package:flutter/material.dart';
import 'package:youtube_analyzer/features/login_page/widgets/login_page_header.dart';
import 'package:youtube_analyzer/features/login_page/widgets/login_page_verification.dart';

class LoginPageGroupItems extends StatelessWidget {
  const LoginPageGroupItems({super.key});

  @override
  Widget build(BuildContext context) {
    return const Center(
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
    );
  }
}
