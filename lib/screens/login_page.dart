
import 'package:flutter/material.dart';

import 'package:youtube_analyzer/common/database.dart';
import 'package:youtube_analyzer/screens/main_page.dart';



class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  bool isLoading = false;
  final _verificationCode = TextEditingController();

  @override
  void dispose() {
    _verificationCode.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).colorScheme.surface,
      body: Row(
        children: [
          Expanded(
              flex: 5,
              child: Container(
                color: Theme.of(context).colorScheme.onPrimary,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Text(
                      'YouTube Analyzer',
                      style: Theme.of(context)
                          .textTheme
                          .displayLarge!
                          .copyWith(fontWeight: FontWeight.bold),
                    ),
                  ],
                ),
              )),
          Expanded(
            flex: 5,
            child: Center(
              child: Container(
                height: 500,
                width: 450,
                //color: Theme.of(context).colorScheme.surfaceContainer,

                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      'Let`s Sing Up!',
                      style: Theme.of(context).textTheme.displaySmall,
                    ),
                    const SizedBox(height: 12),
                    RichText(
                      text: TextSpan(
                        text: 'Hey. Enter verification code from  ',
                        style: Theme.of(context).textTheme.titleMedium,
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
                                        color: Theme.of(context)
                                            .colorScheme
                                            .primary,
                                      ),
                                    ),
                                  ),
                                  child: Text(
                                    'telegram bot',
                                    style: Theme.of(context)
                                        .textTheme
                                        .titleMedium!
                                        .copyWith(
                                          color: Theme.of(context)
                                              .colorScheme
                                              .primary,
                                        ),
                                  ),
                                ),
                              ),
                            ),
                          ),
                          // TextSpan(
                          //   text: 'telegram bot',
                          //   style: Theme.of(context)
                          //       .textTheme
                          //       .titleMedium!
                          //       .copyWith(
                          //           color:
                          //               Theme.of(context).colorScheme.primary,
                          //           decoration: TextDecoration.underline,
                          //           height: 3),
                          //   recognizer: TapGestureRecognizer()
                          //     ..onTap = () {
                          //       // Action when link is clicked
                          //       print('Link clicked!');
                          //     },
                          // ),
                          const TextSpan(
                            text: '  to get sign in to your account.',
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 48),
                    TextField(
                      controller: _verificationCode,
                      keyboardType: TextInputType.text,
                      maxLength: 50,
                      decoration: InputDecoration(
                        label: const Text('Verification code'),
                        filled: true,
                        fillColor:
                            Theme.of(context).colorScheme.surfaceContainer,
                        enabledBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(24),
                            borderSide: BorderSide(
                                color: Theme.of(context)
                                    .colorScheme
                                    .primaryContainer)),
                        focusedBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(12),
                            borderSide: BorderSide(
                                color: Theme.of(context).colorScheme.primary)),
                      ),
                    ),
                    const SizedBox(
                      height: 8,
                    ),
                    SizedBox(
                      height: 46,
                      width: double.infinity,
                      child: FilledButton.icon(
                        onPressed: isLoading
                            ? null
                            : () {
                                setState(() {
                                  isLoading = true;
                                });
                      
                                Future.delayed(Duration(seconds: 2), () { // for testing circular indicator
                                  setState(() {
                                    isLoading = false;
                                  });
                                });
                      
                                if (_verificationCode.text.length != 32) {
                                  setState(() {
                                    isLoading = false;
                                  });
                                  return; //fail show some snicker bar
                                } else {
                                  setState(() {
                                    isLoading = false;
                                  });
                                  Database.set(Database.personAuthTokenKey,
                                      _verificationCode.text);
                      
                                  Navigator.pushReplacement(
                                    context,
                                    MaterialPageRoute(
                                        builder: (context) => const MainPage()),
                                  );
                                }
                              },
                        icon: isLoading ? null : const Icon(Icons.person),
                        label: isLoading
                            ? CircularProgressIndicator(
                                valueColor: AlwaysStoppedAnimation<Color>(
                                    Theme.of(context).colorScheme.primary),
                              )
                            : const Text('Log In'),
                        style: FilledButton.styleFrom(
                          backgroundColor:
                              Theme.of(context).colorScheme.primaryContainer,
                          foregroundColor: Colors.white,
                          
                        ),
                      ),
                    ),
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
