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
    final isDarkMode = Theme.of(context).brightness == Brightness.dark;

    final primaryColor = isDarkMode ? darkPrimaryColor : lightPrimaryColor;
    final secondaryColor = isDarkMode ? darkSecondaryColor : lightSecondaryColor;
    final backgroundColor = isDarkMode ? darkBackgroundColor : lightBackgroundColor;
    final surfaceColor = isDarkMode ? darkSurfaceColor : lightSurfaceColor;
    final onPrimaryColor = isDarkMode ? darkOnPrimaryColor : lightOnPrimaryColor;
    final onSecondaryColor = isDarkMode ? darkOnSecondaryColor : lightOnSecondaryColor;
    final onBackgroundColor = isDarkMode ? darkOnBackgroundColor : lightOnBackgroundColor;
    final onSurfaceColor = isDarkMode ? darkOnSurfaceColor : lightOnSurfaceColor;

    return Scaffold(
      body: Theme(
        data: Theme.of(context).copyWith(
          primaryColor: primaryColor,
          hintColor: secondaryColor,
          scaffoldBackgroundColor: backgroundColor,
          buttonTheme: ButtonThemeData(
            buttonColor: primaryColor,
            textTheme: ButtonTextTheme.primary,
          ),
          colorScheme: ColorScheme(
            primary: primaryColor,
            secondary: secondaryColor,
            background: backgroundColor,
            surface: surfaceColor,
            error: errorColor,
            onPrimary: onPrimaryColor,
            onSecondary: onSecondaryColor,
            onBackground: onBackgroundColor,
            onSurface: onSurfaceColor,
            onError: Colors.white,
            brightness: isDarkMode ? Brightness.dark : Brightness.light,
          ).copyWith(background: backgroundColor),
        ),
        child: Center(
          child: SizedBox(
            width: 300,
            child: Column(
              children: [
                Expanded(
                  child: Column(
                    children: [
                      const Spacer(
                        flex: 2,
                      ),
                      // Add logo here
                      Image.asset(
                        isDarkMode ? 'assets/iconDark.png' : 'assets/iconWhite.png',
                        width: 192,
                        height: 192,
                      ),
                      // Center(
                      //   child: FittedBox(
                      //     fit: BoxFit.fitWidth,
                      //     child: Text(
                      //       S.of(context).FlashCard,
                      //       style: TextStyle(
                      //         color: onBackgroundColor,
                      //         fontSize: 140,
                      //         fontFamily: 'Pacifico',
                      //       ),
                      //     ),
                      //   ),
                      // ),
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
                        primary: false,
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
