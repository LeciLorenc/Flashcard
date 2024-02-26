import 'package:flashcard/authentication/sign_in/sign_in_bloc.dart';
import 'package:flashcard/constants.dart';
import 'package:flashcard/custom_widgets/app_bar.dart';
import 'package:flashcard/custom_widgets/scroll_expandable.dart';
import 'package:flashcard/input/button.dart';
import 'package:flashcard/input/text_input.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../generated/l10n.dart';

class SignInScreen extends StatelessWidget {
  SignInScreen({super.key});

  final TextEditingController email = TextEditingController();
  final TextEditingController password = TextEditingController();
  final SignInBloc signInBloc = SignInBloc();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: const KAppBar(),
      body: BlocBuilder<SignInBloc, SignInState>(
        bloc: signInBloc,
        builder: (BuildContext context, SignInState state) {
          return ScrollExpandable(
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
                            errorText: state is EmailOrPasswordErrorState
                                ? S.of(context).emailOrPasswordError
                                : null,
                          ),
                          const SizedBox(
                            height: spaceBetweenWidgets,
                          ),
                          TextInput.password(
                            textEditingController: password,
                            errorText: state is EmailOrPasswordErrorState
                                ? S.of(context).emailOrPasswordError
                                : null,
                          ),
                          const SizedBox(
                            height: spaceBetweenWidgets,
                          ),
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
