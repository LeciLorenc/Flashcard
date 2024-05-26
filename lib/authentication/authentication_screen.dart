import 'package:flashcard/authentication/sign_up/sign_up_screen.dart';
import 'package:flashcard/generated/l10n.dart';
import 'package:flashcard/input/button.dart';
import 'package:flutter/material.dart';

import '../constants.dart';
import 'sign_in/sign_in_screen.dart';

class AuthenticationScreen extends StatelessWidget {
  const AuthenticationScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Theme(

        data: Theme.of(context).copyWith(
                colorScheme: const ColorScheme.light(
                  primary: primaryColor,
                  background: backGroundColor// Set the color for the selected date
                ),),
        child: Center(
          child: SizedBox(
            width: 300,
            child: Column(
              children: [
                Expanded(
                  child: Column(
                    children:  [
                      const Spacer(
                        flex: 2,
                      ),
                      Center(
                        child: FittedBox(
                          fit: BoxFit.fitWidth,
                          child: Text(
                            S.of(context).FlashCard,
                            style: const TextStyle(
                              color: Colors.black,
                              fontSize: 140,
                              fontFamily: 'Pacifico',
                            ),
                          ),
                        ),
                      ),
                      const Spacer(),
                    ],
                  ),
                ),
                Expanded(
                  child: Column(
                    children: [
                      const Spacer(),
                      Button(
                        key: const Key('sign_in_button'),
                        onPressed: () => Navigator.push(
                          context,
                          MaterialPageRoute(builder: (context) => SignInScreen()),
                        ),
                        text: S.of(context).signIn,
                      ),
                      const SizedBox(
                        height: 50,
                      ),
                      Button(
                        key: const Key('sign_up_button'),
                        onPressed: () => Navigator.push(
                          context,
                          MaterialPageRoute(builder: (context) => SignUpScreen()),
                        ),
                        text: S.of(context).signUp,
                        primary: false,
                      ),

                      const Spacer(),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
