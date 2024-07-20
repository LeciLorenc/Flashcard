import 'dart:async';
import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
// import 'package:flashcard/model/dog.dart';
import 'package:flashcard/model/internal_user.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
/*
abstract class UserEvent {}

class _ReloadEvent extends UserEvent {
  final DocumentSnapshot<Map> userDocument;

  _ReloadEvent({
    required this.userDocument,
  });
}

class ModifyEvent extends UserEvent {
  final Map<String, dynamic> firestoreModel;
  final File? image;

  ModifyEvent({
    String? name,
    String? bio,
    this.image,
  }) : firestoreModel = {
          'name': name,
          'bio': bio,
        };
}

class DeleteDogEvent extends UserEvent {
  final String uid;
  final Completer? completer;

  DeleteDogEvent({
    required this.uid,
    this.completer,
  });
}

class ModifyDogEvent extends UserEvent {
  final Map<String, dynamic> firestoreModel;
  final String? uid;

  ModifyDogEvent({
    required String name,
    required bool sex,
    this.uid,
  }) : firestoreModel = {
          'name': name,
          'sex': sex,
        };
}

class InitUserBloc extends UserEvent {}

abstract class UserState {}

class InitializationState extends UserState {}

abstract class InitializedState extends UserState {
  final InternalUser internalUser;

  InitializedState({
    required this.internalUser,
  });
}

class NotInitializedState extends InitializedState {
  NotInitializedState({required super.internalUser});
}

class CompleteState extends InitializedState {
  CompleteState({required super.internalUser});
}

class UserBloc extends Bloc<UserEvent, UserState> {
  StreamSubscription? streamSubscription;

  UserBloc() : super(InitializationState()) {
    on<_ReloadEvent>(_onReloadEvent);
    on<ModifyEvent>(_onModifyEvent);
    on<DeleteDogEvent>(_onDeleteDogEvent);
    on<InitUserBloc>((InitUserBloc event, Emitter<UserState> emit) {
      streamSubscription?.cancel();
      streamSubscription = FirebaseFirestore.instance
          .collection('users')
          .doc(FirebaseAuth.instance.currentUser!.uid)
          .snapshots()
          .listen((DocumentSnapshot<Map<String, dynamic>> event) {
        add(_ReloadEvent(userDocument: event));
      });
    });
  }

  _onDeleteDogEvent(DeleteDogEvent event, Emitter<UserState> emit) async {
    DocumentReference documentReference =
        FirebaseFirestore.instance.collection('dogs').doc(event.uid);

    FirebaseFirestore.instance
        .collection('users')
        .doc(FirebaseAuth.instance.currentUser!.uid)
        ;

    await documentReference.delete();

    event.completer?.complete();
  }


  _onReloadEvent(_ReloadEvent event, Emitter<UserState> emit) async {
    if (!event.userDocument.exists || event.userDocument['name'] == null) {
      emit(
        NotInitializedState(
          internalUser: InternalUser(
            uid: FirebaseAuth.instance.currentUser!.uid,
            fetched: false,
          ),
        ),
      );
      return;
    }

  }

  _onModifyEvent(ModifyEvent event, Emitter<UserState> emit) {
    FirebaseFirestore.instance
        .collection('users')
        .doc(FirebaseAuth.instance.currentUser!.uid)
        .set(event.firestoreModel, SetOptions(merge: true));

    if (event.image != null) {
      FirebaseStorage.instance
          .ref(FirebaseAuth.instance.currentUser!.uid)
          .child('profile.jpg')
          .putFile(event.image!);
    }
  }
}
*/