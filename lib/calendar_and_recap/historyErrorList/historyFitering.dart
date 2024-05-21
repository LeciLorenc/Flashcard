import 'package:flashcard/bloc/subject_bloc.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';


List<DropdownMenuItem<String>> computeItemsForSubject(BuildContext context)
{
  return context.read<SubjectBloc>().state.subjects.map((subject) {
    return DropdownMenuItem<String>(
      value: subject.name,
      child: Text(subject.name),
    );
  }).toList();

}


List<DropdownMenuItem<String>> computeItemsForDeck(BuildContext context)
{
  Set<String> deckNames = {};

  context.read<SubjectBloc>().state.subjects.forEach((subject) {
    // Iterate over decks in each subject
    subject.decks.forEach((deck) {
      // Add deck name to the set
      deckNames.add(deck.name);
    });
  });

  return deckNames.map((deckName) {
    return DropdownMenuItem<String>(
      value: deckName,
      child: Text(deckName),
    );
  }).toList();
}