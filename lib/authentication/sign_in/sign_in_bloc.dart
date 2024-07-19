  import 'package:firebase_auth/firebase_auth.dart';
  import 'package:google_sign_in/google_sign_in.dart';
  import 'package:flutter_bloc/flutter_bloc.dart';

  abstract class SignInEvent {}

  class EmailPasswordSignInEvent extends SignInEvent {
    final String email;
    final String password;

    EmailPasswordSignInEvent({
      required this.email,
      required this.password,
    });
  }

  class GoogleSignInEvent extends SignInEvent {}

  abstract class SignInState {}

  class InitialState extends SignInState {}

  class EmailOrPasswordErrorState extends SignInState {}

  class GenericErrorState extends SignInState {
    final String message;

    GenericErrorState(this.message);
  }

  class SignedInState extends SignInState {}

  class SignInBloc extends Bloc<SignInEvent, SignInState> {
    SignInBloc() : super(InitialState()) {
      on<EmailPasswordSignInEvent>(_onEmailPasswordSignInEvent);
      on<GoogleSignInEvent>(_onGoogleSignInEvent);
    }

    Future<void> _onEmailPasswordSignInEvent(
        EmailPasswordSignInEvent event, Emitter<SignInState> emit) async {
      try {
        await FirebaseAuth.instance.signInWithEmailAndPassword(
            email: event.email, password: event.password);
        emit(SignedInState());
      } on FirebaseAuthException catch (e) {
        if (e.code == 'user-not-found' || e.code == 'wrong-password') {
          emit(EmailOrPasswordErrorState());
        } else {
          emit(GenericErrorState(e.message ?? "Unknown error"));
        }
      } catch (e) {
        emit(GenericErrorState(e.toString()));
      }
    }

    Future<void> _onGoogleSignInEvent(
        GoogleSignInEvent event, Emitter<SignInState> emit) async {
      try {
        final GoogleSignInAccount? googleUser = await GoogleSignIn().signIn();
        if (googleUser == null) {
          emit(GenericErrorState("Google Sign-In was cancelled"));
          return;
        }
        final GoogleSignInAuthentication googleAuth = await googleUser.authentication;
        final AuthCredential credential = GoogleAuthProvider.credential(
          accessToken: googleAuth.accessToken,
          idToken: googleAuth.idToken,
        );

        await FirebaseAuth.instance.signInWithCredential(credential);
        emit(SignedInState());
      } catch (e) {
        emit(GenericErrorState("Google Sign-In failed: ${e.toString()}"));
      }
    }
  }
