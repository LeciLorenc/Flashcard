/*
import 'package:flashcard/authentication/authentication_screen.dart';
import 'package:flashcard/bloc/play_bloc.dart';
import 'package:flashcard/bloc/user/authentication_bloc.dart';
import 'package:flashcard/bloc/user/user_bloc.dart' as user_bloc;
import 'package:flashcard/firebase_options.dart';
import 'package:flashcard/generated/l10n.dart';
import 'package:flashcard/pages/home_page/home_content/home_content.dart';
import 'package:flashcard/pages/home_page/home_page.dart';
import 'package:flashcard/loading_screen.dart';
import 'package:flashcard/utils/scroll_behavior.dart';
import 'package:flashcard/utils/utils.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flashcard/bloc/subject_bloc.dart';
import 'constants.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  runApp(const AppRoot());
}

class AppRoot extends StatelessWidget {
  const AppRoot({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider(
          lazy: false,
          create: (BuildContext context) => AuthenticationBloc(),
        ),
        BlocProvider(
          create: (BuildContext context) => user_bloc.UserBloc(),
        ),
        BlocProvider<SubjectBloc>(
          create: (BuildContext context) => SubjectBloc(),
        ),
      ],
      child: const MyApp(),
    );
  }
}

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      localizationsDelegates: const [
        S.delegate,
      ],
      supportedLocales: S.delegate.supportedLocales,
      builder: (context, child) {
        if (!isTablet(context)) {
          SystemChrome.setPreferredOrientations([
            DeviceOrientation.portraitUp,
            DeviceOrientation.portraitDown,
          ]);
        } else {
          SystemChrome.setPreferredOrientations([
            DeviceOrientation.portraitUp,
            DeviceOrientation.portraitDown,
            DeviceOrientation.landscapeLeft,
            DeviceOrientation.landscapeRight,
          ]);
        }
        return ScrollConfiguration(
          behavior: NoGlowScrollBehavior(),
          child: child ?? const LoadingPage(),
        );
      },
      title: 'FlashCard',
      theme: ThemeData(
        appBarTheme: const AppBarTheme(
          iconTheme: IconThemeData(color: Colors.black),
          foregroundColor: Colors.black,
        ),
        fontFamily: 'OpenSans',
        primarySwatch: createMaterialColor(primaryColor),
        primaryColor: primaryColor,
        scaffoldBackgroundColor: secondaryColor,
      ),
      home: BlocConsumer<AuthenticationBloc, AuthenticationState>(
        listener: (context, state) {
          // React to state changes here
          if (state is UnauthenticatedState) {
            Navigator.of(context).pushAndRemoveUntil(
              MaterialPageRoute(builder: (context) => const AuthenticationScreen()),
                  (Route<dynamic> route) => false,
            );
          } else if (state is AuthenticatedState) {
            Navigator.of(context).pushAndRemoveUntil(
              MaterialPageRoute(builder: (context) => const HomePage()),
                  (Route<dynamic> route) => false,
            );
          }
        },
        builder: (context, state) {
          if (state is InitializationState) {
            return const LoadingPage();
          }
          // Return an empty container to ensure the navigator operates correctly.
          return Container();
        },
      ),
    );
  }
}




*/
import 'package:flashcard/pages/home_page/home_page.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'bloc/subject_bloc.dart';

void main() {
  runApp(MultiBlocProvider(
    providers: [
      BlocProvider<SubjectBloc>(
        create: (BuildContext context) => SubjectBloc(),
      ),

    ],
    child: const MyApp(),
  ));
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flashcard',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.amberAccent),
        useMaterial3: true,
      ),
      home: const HomePage(),
    );
  }
}