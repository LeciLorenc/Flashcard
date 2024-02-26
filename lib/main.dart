import 'package:flashcard/authentication/authentication_screen.dart';
import 'package:flashcard/bloc/user/authentication_bloc.dart';
import 'package:flashcard/bloc/user/user_bloc.dart' as user_bloc;
import 'package:flashcard/constants.dart';
import 'package:flashcard/firebase_options.dart';
import 'package:flashcard/generated/l10n.dart';
import 'package:flashcard/pages/home_page/home_page.dart';
import 'package:flashcard/loading_screen.dart';
import 'package:flashcard/utils/scroll_behavior.dart';
import 'package:flashcard/utils/utils.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  runApp(
    MultiBlocProvider(
      providers: [
        BlocProvider(
          lazy: false,
          create: (BuildContext context) => AuthenticationBloc(),
        ),
        BlocProvider(
          create: (BuildContext context) => user_bloc.UserBloc(),
        ),
      ],
      child: const MyApp(),
    ),
  );
}

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  State<StatefulWidget> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  Widget home = const LoadingPage();

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
      title: 'Walk the dog',
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
      home: BlocListener<AuthenticationBloc, AuthenticationState>(
        listener: (BuildContext context, AuthenticationState state) {
          Navigator.popUntil(context, (route) => route.isFirst);
          Widget home = const LoadingPage();

          if (state is InitializationState) {
            home = const LoadingPage();
          } else if (state is UnauthenticatedState) {
            home = const AuthenticationScreen();
          } else if (state is AuthenticatedState) {
            home = const HomePage();
            context.read<user_bloc.UserBloc>().add(user_bloc.InitUserBloc());
          }
          setState(() {
            this.home = home;
          });
        },
        child: home,
      ),
    );
  }
}


// import 'package:flashcard/pages/home_page/home_page.dart';
// import 'package:flutter/material.dart';
// import 'package:flutter_bloc/flutter_bloc.dart';
//
// import 'bloc/subject_bloc.dart';
//
// void main() {
//   runApp(MultiBlocProvider(
//     providers: [
//       BlocProvider<SubjectBloc>(
//         create: (BuildContext context) => SubjectBloc(),
//       ),
//
//     ],
//     child: const MyApp(),
//   ));
// }
//
// class MyApp extends StatelessWidget {
//   const MyApp({super.key});
//
//   // This widget is the root of your application.
//   @override
//   Widget build(BuildContext context) {
//     return MaterialApp(
//       title: 'Flashcard',
//       theme: ThemeData(
//         colorScheme: ColorScheme.fromSeed(seedColor: Colors.amberAccent),
//         useMaterial3: true,
//       ),
//       home: const HomePage(),
//     );
//   }
// }
