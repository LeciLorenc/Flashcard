import 'package:firebase_auth/firebase_auth.dart';
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
import 'package:flashcard/bloc/subject_bloc.dart';
import 'package:intl/date_symbol_data_local.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'ChatGPT_services/model-view/api_service.dart';
import 'bloc/subject_block_online.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  await ApiService.instance.initializeApiKeys();
  // Initialize locale data for DateFormat
  await initializeDateFormatting('en_US', null);

  runApp(
    MultiBlocProvider(
      providers: [
        BlocProvider(
          lazy: false,
          create: (BuildContext context) => AuthenticationBloc(),
        ),
        /*BlocProvider(
          create: (BuildContext context) => user_bloc.UserBloc(),
        ),*/
        BlocProvider(
          create: (BuildContext context) => SubjectBloc(firestoreService: FirestoreService()),
        ),
        /*BlocProvider<SubjectBlocFirebase>(
          create: (BuildContext context) => SubjectBlocFirebase(FirestoreService()),
        ),*/
      ],
      child: const MyApp(),
    ),
  );
}

String globalUserId = '';
bool isDark = false;

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  static _MyAppState? of(BuildContext context) =>
      context.findAncestorStateOfType<_MyAppState>();

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  Widget home = const LoadingPage();
  ThemeMode themeMode = ThemeMode.system;

  @override
  void initState() {
    super.initState();
    _loadTheme();
    _setOrientation();
  }

  Future<void> _loadTheme() async {
    final prefs = await SharedPreferences.getInstance();
    final isDarkMode = prefs.getBool('isDarkMode') ?? false;
    setState(() {
      themeMode = isDarkMode ? ThemeMode.dark : ThemeMode.light;
      isDark = isDarkMode;
    });
  }

  Future<void> toggleTheme(bool isDarkMode) async {
    final prefs = await SharedPreferences.getInstance();
    prefs.setBool('isDarkMode', isDarkMode);
    setState(() {
      themeMode = isDarkMode ? ThemeMode.dark : ThemeMode.light;
      isDark = isDarkMode;
    });
  }

  void _setOrientation() {
    final shortestSide = MediaQueryData.fromWindow(WidgetsBinding.instance.window).size.shortestSide;
    final isTablet = /*shortestSide >= 600;*/ true;

    if (isTablet) {
      SystemChrome.setPreferredOrientations([
        DeviceOrientation.landscapeLeft,
        DeviceOrientation.landscapeRight,
      /*]);
    } else {
      SystemChrome.setPreferredOrientations([*/
        DeviceOrientation.portraitUp,
        DeviceOrientation.portraitDown,
      ]);
    }
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      localizationsDelegates: const [
        S.delegate,
      ],
      supportedLocales: S.delegate.supportedLocales,
      builder: (context, child) {
        return ScrollConfiguration(
          behavior: NoGlowScrollBehavior(),
          child: child ?? const LoadingPage(),
        );
      },
      title: 'FlashCard',
      theme: ThemeData(
        brightness: Brightness.light,
        appBarTheme: const AppBarTheme(
          color: lightAppBarColor,
          iconTheme: IconThemeData(color: lightIconColor),
          foregroundColor: lightTextColor,
        ),
        fontFamily: 'OpenSans',
        primarySwatch: createColors(primaryColor),
        primaryColor: primaryColor,
        scaffoldBackgroundColor: lightBackgroundColor,
        textTheme: const TextTheme(
          bodyLarge: TextStyle(color: lightTextColor),
          bodyMedium: TextStyle(color: lightTextColor),
        ),
        iconTheme: const IconThemeData(color: lightIconColor),
      ),
      darkTheme: ThemeData(
        brightness: Brightness.dark,
        appBarTheme: const AppBarTheme(
          color: darkAppBarColor,
          iconTheme: IconThemeData(color: darkIconColor),
          foregroundColor: darkTextColor,
        ),
        fontFamily: 'OpenSans',
        primarySwatch: createColors(primaryColor),
        primaryColor: primaryColor,
        scaffoldBackgroundColor: darkBackgroundColor,
        textTheme: const TextTheme(
          bodyLarge: TextStyle(color: darkTextColor),
          bodyMedium: TextStyle(color: darkTextColor),
        ),
        iconTheme: const IconThemeData(color: darkIconColor),
      ),
      themeMode: themeMode,
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
            //context.read<user_bloc.UserBloc>().add(user_bloc.InitUserBloc());

            globalUserId = FirebaseAuth.instance.currentUser!.uid;
          }

          // Update the home widget state
          setState(() {
            home = newHome;
          });
        },
        child: home,
      ),
    );
  }
}
