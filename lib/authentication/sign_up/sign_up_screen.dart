import 'package:flashcard/authentication/sign_up/sign_up_bloc.dart';
import 'package:flashcard/constants.dart';
import 'package:flashcard/custom_widgets/app_bar.dart';
import 'package:flashcard/custom_widgets/scroll_expandable.dart';
import 'package:flashcard/generated/l10n.dart';
import 'package:flashcard/input/text_input.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class SignUpScreen extends StatelessWidget {
  SignUpScreen({super.key});

  final TextEditingController email = TextEditingController();
  final TextEditingController password = TextEditingController();
  final SignUpBloc signUpBloc = SignUpBloc();

  @override
  Widget build(BuildContext context) {
    final isDarkMode = Theme.of(context).brightness == Brightness.dark;
    final textColor = isDarkMode ? darkTextColor : lightTextColor;

    return Scaffold(
      appBar: const KAppBar(),
      body: BlocBuilder<SignUpBloc, SignUpState>(
        bloc: signUpBloc,
        builder: (BuildContext context, SignUpState state) {
          return ScrollExpandable(
            child: Center(
              child: SizedBox(
                width: 380,
                child: Column(
                  children: [
                    Expanded(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          const Spacer(flex: 1),
                          // Add logo here
                          Image.asset(
                            isDarkMode ? 'assets/iconDark.png' : 'assets/iconWhite.png',
                            width: 100,
                            height: 100,
                          ),
                          const SizedBox(height: 20),
                          Center(
                            child: FittedBox(
                              fit: BoxFit.fitWidth,
                              child: Text(
                                S.of(context).signUp,
                                style: TextStyle(
                                  color: textColor,
                                  fontSize: 40,
                                  fontFamily: 'Pacifico',
                                  fontWeight: FontWeight.bold,
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
                          if (state is GenericErrorState)
                            Text(
                              S.of(context).genericError,
                              style: TextStyle(
                                color: Theme.of(context).colorScheme.error,
                                fontWeight: FontWeight.bold,
                                fontSize: 20,
                              ),
                            ),
                          const Spacer(),
                          TextInput.email(
                            textEditingController: email,
                            errorText: state is UserAlreadyExistsState
                                ? S.of(context).emailAlreadyRegistered
                                : null,
                          ),
                          const SizedBox(height: 15),
                          TextInput.password(
                            textEditingController: password,
                            errorText: state is WeekPasswordState
                                ? S.of(context).passwordTooWeak
                                : null,
                          ),
                          const SizedBox(height: spaceBetweenWidgets),
                          Row(
                            children: [
                              Expanded(
                                child: ElevatedButton(
                                  style: ElevatedButton.styleFrom(
                                    backgroundColor: primaryColor, // Use the correct color property
                                  ),
                                  onPressed: () => signUpBloc.add(EmailPasswordSignUpEvent(email: email.text, password: password.text)),
                                  child: Text(
                                    S.of(context).signUp,
                                    style: TextStyle(color: isDarkMode ? lightTextColor : darkTextColor),
                                  ),
                                ),
                              ),
                            ],
                          ),
                          const Spacer(),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}
