import 'package:flashcard/authentication/authentication_screen.dart';
import 'package:flashcard/bloc/user/authentication_bloc.dart';
import 'package:flashcard/bloc/user/user_bloc.dart' as user_bloc;
import 'package:flashcard/constants.dart';
import 'package:flashcard/firebase_options.dart';
import 'package:flashcard/generated/l10n.dart';
import 'package:flashcard/pages/home_page/home_page.dart';
import 'package:flashcard/service/firestore_service.dart';
import 'package:flashcard/loading_screen.dart';
import 'package:flashcard/utils/scroll_behavior.dart';
import 'package:flashcard/utils/utils.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flashcard/bloc/subject_bloc.dart'; // Import the SubjectBloc
import 'package:intl/date_symbol_data_local.dart';

import 'bloc/subject_block_online.dart';




Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );

  // Initialize locale data for DateFormat
  await initializeDateFormatting('en_US', null); // Change 'en_US' to your target locale if different

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
    // Include the SubjectBloc provider
    BlocProvider(
    create: (BuildContext context) => SubjectBloc(firestoreService: FirestoreService()),
    ),
        BlocProvider<SubjectBlocFirebase>(  // Adding the Firestore version of SubjectBloc
          create: (BuildContext context) => SubjectBlocFirebase(FirestoreService()),
        ),
    // Add other BlocProviders here
    // BlocProvider(
    //   create: (BuildContext context) => OfferBloc(),
    // ),
    // BlocProvider(
    //   create: (BuildContext context) => LocationBloc(),
    // ),
    // BlocProvider(
    //   create: (BuildContext context) => OrderBloc(),
    // ),
    ],
    child: const MyApp(),));

}

//
// class AppRoot extends StatelessWidget {
//   const AppRoot({super.key});
//
//   @override
//   Widget build(BuildContext context) {
//     return MultiBlocProvider(
//       providers: [
//         BlocProvider(
//           lazy: false,
//           create: (BuildContext context) => AuthenticationBloc(),
//         ),
//         BlocProvider(
//           create: (BuildContext context) => user_bloc.UserBloc(),
//         ),
//         // Include the SubjectBloc provider
//         BlocProvider(
//           create: (BuildContext context) => SubjectBloc(),
//         ),
//       ],
//       child: const MyApp(),
//     );
//   }
// }

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  State<MyApp> createState() => _MyAppState();
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
        home: BlocListener<AuthenticationBloc, AuthenticationState>(
          listener: (context, state) {
      // Pop to first route
          Navigator.popUntil(context, (route) => route.isFirst);

          Widget newHome = const LoadingPage();

          if (state is InitializationState) {
            newHome = const LoadingPage();
          } else if (state is UnauthenticatedState) {
            newHome = const AuthenticationScreen();
          } else if (state is AuthenticatedState) {
           newHome = const HomePage();
           context.read<user_bloc.UserBloc>().add(user_bloc.InitUserBloc());

        // Trigger init events for other blocs here

      }

      // Update the home widget state
          setState(() {
          home = newHome;
         });
        },
         child: home,
  ));

  }
}
/*

import 'package:firebase_core/firebase_core.dart';
import 'package:flashcard/pages/home_page/home_page.dart';
import 'package:flashcard/service/firestore_service.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'bloc/subject_bloc.dart';

void main() async{
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();


  runApp(MultiBlocProvider(
    providers: [
      BlocProvider<SubjectBloc>(
        create: (BuildContext context) => SubjectBloc(firestoreService: FirestoreService() ),
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
*/
