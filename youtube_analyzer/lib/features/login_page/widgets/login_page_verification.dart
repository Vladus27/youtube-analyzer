import 'package:flutter/material.dart';

import 'package:youtube_analyzer/common/database.dart';
import 'package:youtube_analyzer/features/login_page/widgets/login_page_input.dart';
import 'package:youtube_analyzer/features/main_page/view/main_page_screen.dart';
import 'package:youtube_analyzer/repositories/widgets/show_snack_bar.dart';
import 'package:youtube_analyzer/repositories/youtube_repository.dart';
// import 'package:youtube_analyzer/screensOld/main_page.dart';


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
    final colorTheme = Theme.of(context).colorScheme;

    void validationAuthToken(bool isUserLoad) {
      if (isUserLoad) {
        Database.set(Database.personAuthTokenKey, _verificationCode.text);

        setState(() => isLoading = false);
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (context) => const MainPage()),
          // MaterialPageRoute(builder: (context) => TempTestFile(verifCode: _verificationCode.text)),
        );
      } else {
        showSnackBar(
            context, 'This user unauthorized! Check your Verification code');
        setState(() => isLoading = false);
      }
    }

    Future<void> handleLogin() async {
      if (!mounted) return;
      setState(() => isLoading = true);

      if (_verificationCode.text.length != 32) {
        setState(() => isLoading = false);
        showSnackBar(context, 'Check your Verification code');
        return;
      }
      bool isLoadUser = await YoutubeRepository().checkPersonAuthTokenKey(_verificationCode.text);

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
                    color: colorTheme.primary,
                  ),
            label: isLoading
                ? CircularProgressIndicator(
                    valueColor: AlwaysStoppedAnimation<Color>(colorTheme.primary),
                  )
                : const Text('Log In'),
            style: FilledButton.styleFrom(
              backgroundColor: colorTheme.onPrimary,
              foregroundColor: Colors.white,
            ),
          ),
        ),
      ],
    );
  }
}


