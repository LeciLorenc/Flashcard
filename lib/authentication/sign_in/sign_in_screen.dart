import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flashcard/authentication/sign_in/sign_in_bloc.dart';
import 'package:flashcard/constants.dart';
import 'package:flashcard/custom_widgets/app_bar.dart';
import 'package:flashcard/input/button.dart';
import 'package:flashcard/input/text_input.dart';
import 'package:flashcard/generated/l10n.dart';

import '../../main.dart';

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
            return LayoutBuilder(
              builder: (BuildContext context, BoxConstraints constraints) {


                if (constraints.maxWidth < 600) {
                  // Portrait mode or narrow width
                  return SingleChildScrollView(
                    child: Center(
                      child: SizedBox(
                        width: 300,
                        child: Column(
                          children: [
                            SizedBox(
                              height: MediaQuery.of(context).size.height * 0.4,
                              child: Column(
                                children: [
                                  const Spacer(flex: 2),
                                  FittedBox(
                                    fit: BoxFit.fitWidth,
                                    child: Text(
                                      S.of(context).signIn,
                                      style: const TextStyle(
                                        color: Colors.black,
                                        fontSize: 110,
                                        fontFamily: 'Pacifico',
                                      ),
                                    ),
                                  ),
                                  const Spacer(),
                                ],
                              ),
                            ),
                            SizedBox(
                              height: MediaQuery.of(context).size.height * 0.6,
                              child: Column(
                                children: [
                                  if (state is GenericErrorState)
                                    Text(
                                      state.message,
                                      style: TextStyle(
                                        color: Theme.of(context).colorScheme.error,
                                        fontWeight: FontWeight.bold,
                                        fontSize: 20,
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
                                  Button(
                                    key: const Key('sign_in_button'),
                                    onPressed: () => signInBloc.add(
                                      EmailPasswordSignInEvent(
                                        email: email.text,
                                        password: password.text,
                                      ),
                                    ),
                                    text: S.of(context).signIn,
                                  ),
                                  const SizedBox(height: spaceBetweenWidgets),
                                  Button(
                                    key: const Key('google_sign_in_button'),
                                    onPressed: () => signInBloc.add(GoogleSignInEvent()),
                                    text: S.of(context).signInWithGoogle,
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
                } else {
                  // Landscape mode or wide width
                  return Center(
                    child: SingleChildScrollView(
                      child: SizedBox(
                        width: 700,
                        child: Column(
                          children: [
                            SizedBox(
                              height: MediaQuery.of(context).size.height * 0.35,
                              child: Column(
                                children: [
                                  FittedBox(
                                    fit: BoxFit.fitWidth,
                                    child: Text(
                                      S.of(context).signIn,
                                      style:  TextStyle(
                                        color: isDark ? darkTextColor: lightTextColor,
                                        fontSize: 100,
                                        fontFamily: 'Pacifico',
                                      ),
                                    ),
                                  ),

                                ],
                              ),
                            ),
                            SizedBox(
                              height: MediaQuery.of(context).size.height * 0.5,
                              child: Row(
                                children: [
                                  Expanded(
                                    child: Column(
                                      mainAxisAlignment: MainAxisAlignment.center,
                                      crossAxisAlignment: CrossAxisAlignment.start,
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
                                              child: ElevatedButton(
                                                style: ElevatedButton.styleFrom(
                                                  backgroundColor: primaryColor, // Use the correct color property
                                                ),
                                                onPressed: () => signInBloc.add(
                                                  EmailPasswordSignInEvent(
                                                    email: email.text,
                                                    password: password.text,
                                                  ),
                                                ),
                                                child: Text(S.of(context).signIn ,style: TextStyle(color: isDark? lightTextColor: darkTextColor),),
                                              ),
                                            ),

                                            const SizedBox(width: 20), // Space between buttons
                                            Expanded(
                                              child: ElevatedButton(
                                                style: ElevatedButton.styleFrom(
                                                  backgroundColor: primaryColor, // Use the correct color property
                                                ),
                                                onPressed: () => signInBloc.add(GoogleSignInEvent()),
                                                child: Text(S.of(context).signInWithGoogle ,style: TextStyle(color: isDark? lightTextColor: darkTextColor),),
                                              ),
                                            ),
                                          ],
                                        ),
                                      ],
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  );
                }
              },
            );
          },
        ),
      ),
    );
  }
}
