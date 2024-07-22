import 'package:flashcard/authentication/sign_up/sign_up_bloc.dart';
import 'package:flashcard/constants.dart';
import 'package:flashcard/custom_widgets/app_bar.dart';
import 'package:flashcard/generated/l10n.dart';
import 'package:flashcard/input/text_input.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flashcard/constants.dart';
import 'package:flashcard/input/button.dart'; // Import the custom button

class SignUpScreen extends StatelessWidget {
  SignUpScreen({super.key});

  final TextEditingController email = TextEditingController();
  final TextEditingController password = TextEditingController();
  final SignUpBloc signUpBloc = SignUpBloc();

  @override
  Widget build(BuildContext context) {
    final isDarkMode = Theme.of(context).brightness == Brightness.dark;
    final isKeyboardOpen = MediaQuery.of(context).viewInsets.bottom != 0;

    return Scaffold(
      appBar: const KAppBar(),
      resizeToAvoidBottomInset: true,
      body: BlocProvider(
        create: (context) => signUpBloc,
        child: BlocBuilder<SignUpBloc, SignUpState>(
          builder: (BuildContext context, SignUpState state) {
            return LayoutBuilder(
              builder: (BuildContext context, BoxConstraints constraints) {
                return SingleChildScrollView(
                  padding: EdgeInsets.only(
                    bottom: MediaQuery.of(context).viewInsets.bottom,
                  ),
                  child: Center(
                    child: Padding(
                      padding: const EdgeInsets.all(10.0), // Add padding around the screen
                      child: ConstrainedBox(
                        constraints: BoxConstraints(
                          minHeight: constraints.maxHeight,
                        ),
                        child: IntrinsicHeight(
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              if (!isKeyboardOpen) ...[
                                Image.asset(
                                  isDarkMode ? 'assets/iconDark.png' : 'assets/iconWhite.png',
                                  width: 150,
                                  height: 150,
                                ),
                                const SizedBox(height: 20),
                                Text(
                                  S.of(context).signUp,
                                  style: TextStyle(
                                    color: Theme.of(context).textTheme.bodyLarge!.color,
                                    fontSize: constraints.maxWidth < 600 ? 40 : 35,
                                    fontFamily: 'Pacifico',
                                  ),
                                ),
                                const SizedBox(height: 20),
                              ],
                              if (state is UserAlreadyExistsState)
                                Padding(
                                  padding: const EdgeInsets.all(8.0),
                                  child: Text(
                                    S.of(context).emailAlreadyRegistered,
                                    style: TextStyle(
                                      color: Theme.of(context).colorScheme.error,
                                      fontWeight: FontWeight.bold,
                                      fontSize: 20,
                                    ),
                                    textAlign: TextAlign.center,
                                  ),
                                ),
                              if (state is WeekPasswordState)
                                Padding(
                                  padding: const EdgeInsets.all(8.0),
                                  child: Text(
                                    S.of(context).passwordTooWeak,
                                    style: TextStyle(
                                      color: Theme.of(context).colorScheme.error,
                                      fontWeight: FontWeight.bold,
                                      fontSize: 20,
                                    ),
                                    textAlign: TextAlign.center,
                                  ),
                                ),
                              if (state is GenericErrorState)
                                Padding(
                                  padding: const EdgeInsets.all(8.0),
                                  child: Text(
                                    S.of(context).genericError,
                                    style: TextStyle(
                                      color: Theme.of(context).colorScheme.error,
                                      fontWeight: FontWeight.bold,
                                      fontSize: 20,
                                    ),
                                    textAlign: TextAlign.center,
                                  ),
                                ),
                              TextInput.email(
                                textEditingController: email,
                                errorText: state is UserAlreadyExistsState
                                    ? S.of(context).emailAlreadyRegistered
                                    : null,
                              ),
                              const SizedBox(height: spaceBetweenWidgets),
                              TextInput.password(
                                textEditingController: password,
                                errorText: state is WeekPasswordState
                                    ? S.of(context).passwordTooWeak
                                    : null,
                              ),
                              const SizedBox(height: spaceBetweenWidgets),
                              SizedBox(
                                width: double.infinity,
                                child: CustomButton(
                                  key: const Key('sign_up_button'),
                                  onPressed: () => signUpBloc.add(
                                    EmailPasswordSignUpEvent(
                                      email: email.text,
                                      password: password.text,
                                    ),
                                  ),
                                  text: S.of(context).signUp,
                                ),
                              ),
                              const SizedBox(height: 20),
                            ],
                          ),
                        ),
                      ),
                    ),
                  ),
                );
              },
            );
          },
        ),
      ),
    );
  }
}
