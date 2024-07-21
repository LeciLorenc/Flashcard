import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flashcard/authentication/sign_in/sign_in_bloc.dart';
import 'package:flashcard/constants.dart';
import 'package:flashcard/custom_widgets/app_bar.dart';
import 'package:flashcard/input/button.dart';
import 'package:flashcard/input/text_input.dart';
import 'package:flashcard/generated/l10n.dart';

class SignInScreen extends StatelessWidget {
  SignInScreen({super.key});

  final TextEditingController email = TextEditingController();
  final TextEditingController password = TextEditingController();
  final SignInBloc signInBloc = SignInBloc();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: const KAppBar(),
      body: BlocProvider(
        create: (context) => signInBloc,
        child: BlocBuilder<SignInBloc, SignInState>(
          builder: (BuildContext context, SignInState state) {
            final isDarkMode = Theme.of(context).brightness == Brightness.dark;
            final logo = isDarkMode ? 'assets/iconDark.png' : 'assets/iconWhite.png';

            return LayoutBuilder(
              builder: (BuildContext context, BoxConstraints constraints) {
                return SingleChildScrollView(
                  child: Center(
                    child: SizedBox(
                      width: constraints.maxWidth < 600 ? 300 : 700,
                      child: Column(
                        children: [
                          SizedBox(
                            height: constraints.maxHeight * (constraints.maxWidth < 600 ? 0.4 : 0.35),
                            child: Column(
                              children: [
                                const Spacer(flex: 2),
                                Image.asset(
                                  logo,
                                  width: 150, // Increased the logo size
                                  height: 150, // Increased the logo size
                                ),
                                const SizedBox(height: 20),
                                FittedBox(
                                  fit: BoxFit.fitWidth,
                                  child: Text(
                                    S.of(context).signIn,
                                    style: TextStyle(
                                      color: Theme.of(context).textTheme.bodyLarge!.color,
                                      fontSize: constraints.maxWidth < 600 ? 80 : 70, // Reduced the font size
                                      fontFamily: 'Pacifico',
                                    ),
                                  ),
                                ),
                                const Spacer(),
                              ],
                            ),
                          ),
                          SizedBox(
                            height: constraints.maxHeight * (constraints.maxWidth < 600 ? 0.6 : 0.5),
                            child: Column(
                              children: [
                                if (state is GenericErrorState)
                                  Padding(
                                    padding: const EdgeInsets.all(8.0),
                                    child: Text(
                                      state.message,
                                      style: TextStyle(
                                        color: Theme.of(context).colorScheme.error,
                                        fontWeight: FontWeight.bold,
                                        fontSize: 20,
                                      ),
                                      textAlign: TextAlign.center,
                                    ),
                                  ),
                                const Spacer(),
                                TextInput.email(
                                  textEditingController: email,
                                  errorText: state is EmailOrPasswordErrorState
                                      ? S.of(context).emailOrPasswordError
                                      : null,
                                ),
                                const SizedBox(height: spaceBetweenWidgets),
                                TextInput.password(
                                  textEditingController: password,
                                  errorText: state is EmailOrPasswordErrorState
                                      ? S.of(context).emailOrPasswordError
                                      : null,
                                ),
                                const SizedBox(height: spaceBetweenWidgets),
                                Row(
                                  children: [
                                    Expanded(
                                      child: Button(
                                        key: const Key('sign_in_button'),
                                        onPressed: () => signInBloc.add(
                                          EmailPasswordSignInEvent(
                                            email: email.text,
                                            password: password.text,
                                          ),
                                        ),
                                        text: S.of(context).signIn,
                                      ),
                                    ),
                                    const SizedBox(width: 20),
                                    Expanded(
                                      child: Button(
                                        key: const Key('google_sign_in_button'),
                                        onPressed: () => signInBloc.add(GoogleSignInEvent()),
                                        text: S.of(context).signInWithGoogle,
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
            );
          },
        ),
      ),
    );
  }
}
