import 'package:flutter/material.dart';

import 'package:youtube_analyzer/common/database.dart';
import 'package:youtube_analyzer/features/login_page/widgets/login_page_input.dart';
import 'package:youtube_analyzer/reposetories/subcription_YT/youtube_repository.dart';
import 'package:youtube_analyzer/screensOld/main_page.dart';

class LoginPageVerification extends StatefulWidget {
  const LoginPageVerification({super.key, required this.titleField});
  final String titleField;

  @override
  State<LoginPageVerification> createState() => _LoginPageVerificationState();
}

class _LoginPageVerificationState extends State<LoginPageVerification> {
  final _verificationCode = TextEditingController();
  bool isLoading = false;

  @override
  void dispose() {
    _verificationCode.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final clrTheme = Theme.of(context).colorScheme;

    void validationAuthToken(bool isUserLoad) {
      if (isUserLoad) {
        Database.set(Database.personAuthTokenKey, _verificationCode.text);

        setState(() => isLoading = false);
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (context) => const MainPage()),
        );
      } else {
        _showSnackBar(
            context, 'This user unauthorized! Check your Verification code');
        setState(() => isLoading = false);
      }
    }

    Future<void> handleLogin() async {
      if (!mounted) return;
      setState(() => isLoading = true);

      if (_verificationCode.text.length != 32) {
        setState(() => isLoading = false);
        _showSnackBar(context, 'Check your Verification code');
        return;
      }
      bool isLoadUser = await YoutubeRepository()
          .checkPersonAuthTokenKey(_verificationCode.text);

      validationAuthToken(isLoadUser);
    }

    return Column(
      children: [
        LoginPageInput(
          titleField: widget.titleField,
          verificationCode: _verificationCode,
        ),
        const SizedBox(
          height: 8,
        ),
        SizedBox(
          height: 46,
          width: double.infinity,
          child: FilledButton.icon(
            onPressed: isLoading ? null :  handleLogin,            
            icon: isLoading
                ? null
                : Icon(
                    Icons.person,
                    color: clrTheme.primary,
                  ),
            label: isLoading
                ? CircularProgressIndicator(
                    valueColor: AlwaysStoppedAnimation<Color>(clrTheme.primary),
                  )
                : const Text('Log In'),
            style: FilledButton.styleFrom(
              backgroundColor: clrTheme.onPrimary,
              foregroundColor: Colors.white,
            ),
          ),
        ),
      ],
    );
  }
}

void _showSnackBar(BuildContext context, String message) {
  ScaffoldMessenger.of(context).showSnackBar(
    SnackBar(
      content: Text(message),
      action: SnackBarAction(
        label: 'ok',
        onPressed: () {
          debugPrint('Vladus is the best');
          // Code to execute.
        },
      ),
    ),
  );
}
