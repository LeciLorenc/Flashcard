import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flashcard/authentication/sign_in/sign_in_bloc.dart';
import 'package:flashcard/constants.dart';
import 'package:flashcard/custom_widgets/app_bar.dart';
import 'package:flashcard/input/text_input.dart';
import 'package:flashcard/generated/l10n.dart';
import 'package:flashcard/input/button.dart'; // Import the CustomButton

class SignInScreen extends StatelessWidget {
  SignInScreen({super.key});

  final TextEditingController email = TextEditingController();
  final TextEditingController password = TextEditingController();
  final SignInBloc signInBloc = SignInBloc();

  @override
  Widget build(BuildContext context) {
    final isKeyboardOpen = MediaQuery.of(context).viewInsets.bottom != 0;

    return Scaffold(
      appBar: const KAppBar(),
      resizeToAvoidBottomInset: true,
      body: BlocProvider(
        create: (context) => signInBloc,
        child: BlocBuilder<SignInBloc, SignInState>(
          builder: (BuildContext context, SignInState state) {
            final isDarkMode = Theme.of(context).brightness == Brightness.dark;
            final logo = isDarkMode ? 'assets/iconDark.png' : 'assets/iconWhite.png';

            return LayoutBuilder(
              builder: (BuildContext context, BoxConstraints constraints) {
                return SingleChildScrollView(
                  padding: EdgeInsets.only(
                    bottom: MediaQuery.of(context).viewInsets.bottom,
                  ),
                  child: Center(
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
                                logo,
                                width: 150,
                                height: 150,
                              ),
                              const SizedBox(height: 20),
                              Text(
                                S.of(context).signIn,
                                style: TextStyle(
                                  color: Theme.of(context).textTheme.bodyLarge!.color,
                                  fontSize: constraints.maxWidth < 600 ? 40 : 35,
                                  fontFamily: 'Pacifico',
                                ),
                              ),
                              const SizedBox(height: 20),
                            ],
                            if (state is EmailOrPasswordErrorState)
                              Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: Text(
                                  S.of(context).emailOrPasswordError,
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
                                  state.toString(),  // Adjusted to use a default error message
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
                            SizedBox(
                              width: double.infinity,
                              child: CustomButton(
                                key: const Key('sign_in_button'),
                                onPressed: () => signInBloc.add(
                                  EmailPasswordSignInEvent(
                                    email: email.text,
                                    password: password.text,
                                  ),
                                ),
                                text: S.of(context).signIn,
                                icon: Icons.login, // Add icon here
                              ),
                            ),
                            const SizedBox(height: spaceBetweenWidgets),
                            SizedBox(
                              width: double.infinity,
                              child: CustomButton(
                                key: const Key('google_sign_in_button'),
                                onPressed: () => signInBloc.add(GoogleSignInEvent()),
                                text: S.of(context).signInWithGoogle,
                                icon: Icons.login, // Add icon here
                              ),
                            ),
                            const SizedBox(height: 20),
                          ],
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
