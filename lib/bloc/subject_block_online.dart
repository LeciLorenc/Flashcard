/*
import 'dart:async';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../model/deck.dart';
import '../model/subject.dart';
import '../service/firestore_service.dart';

class SubjectEventFirebase {}

class LoadSubjectsFirebase extends SubjectEventFirebase {}
class AddSubjectFirebase extends SubjectEventFirebase {
  final Subject subject;
  AddSubjectFirebase(this.subject);
}
class UpdateSubjectFirebase extends SubjectEventFirebase {
  final Subject subject;
  UpdateSubjectFirebase(this.subject);
}
class DeleteSubjectFirebase extends SubjectEventFirebase {
  final String subjectId;
  DeleteSubjectFirebase(this.subjectId);
}

class SubjectStateFirebase {
  final List<Subject> subjects;
  final Subject? subject;
  final Deck? deck;

  SubjectStateFirebase({
    this.subjects = const [],
    this.subject,
    this.deck,
  });
}

class SubjectBlocFirebase extends Bloc<SubjectEventFirebase, SubjectStateFirebase> {
  final FirestoreService firestoreService;

  SubjectBlocFirebase(this.firestoreService) : super(SubjectStateFirebase()) {
    on<LoadSubjectsFirebase>((event, emit) => _loadSubjects(emit));
    on<AddSubjectFirebase>((event, emit) => _addSubject(event, emit));
    on<UpdateSubjectFirebase>((event, emit) => _updateSubject(event, emit));
    on<DeleteSubjectFirebase>((event, emit) => _deleteSubject(event, emit));
  }

  void _loadSubjects(Emitter<SubjectStateFirebase> emit) async {
    emit(SubjectStateFirebase(subjects: await firestoreService.streamSubjects().first));
  }

  void _addSubject(AddSubjectFirebase event, Emitter<SubjectStateFirebase> emit) async {
    await firestoreService.addSubject(event.subject);
    _loadSubjects(emit);
  }

  void _updateSubject(UpdateSubjectFirebase event, Emitter<SubjectStateFirebase> emit) async {
    await firestoreService.updateSubject(event.subject);
    _loadSubjects(emit);
  }

  void _deleteSubject(DeleteSubjectFirebase event, Emitter<SubjectStateFirebase> emit) async {
    await firestoreService.deleteSubject(event.subjectId);
    _loadSubjects(emit);
  }
}*/
