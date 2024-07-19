import 'package:flashcard/model/flashcard.dart';
import 'package:flashcard/model/subject.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../bloc/subject_bloc.dart';
import '../../../model/deck.dart';
import '../../../widget/adaptable_card/adaptable_card_holder.dart';
import '../../../widget/flashcard_text_editing_controller/auto_save_text_editing_controller.dart';

class DeckModify extends StatelessWidget {
  const DeckModify({
    super.key,
    required this.deck,
    required this.visualize,
    required this.subject,
  });

  final Deck deck;
  final bool visualize;
  final Subject subject;

  @override
  Widget build(BuildContext context) {
    return ReorderableListView(
      buildDefaultDragHandles: false,
      onReorder: (int oldIndex, int newIndex) =>
          onReorder(context, oldIndex, newIndex),
      footer: Column(
        children: [
          ListTile(
            leading: const Icon(Icons.add),
            title: const Text('Create new flashcard'),
            onTap: () => context
                .read<SubjectBloc>()
                .add(AddFlashcard(index: deck.flashcards.length)),

          ),
          Align(
          alignment: Alignment.bottomCenter,
          child: ListTile(
              leading: const Icon(Icons.arrow_back),
              title: const Text('Go back'),
              onTap: () =>  context.read<SubjectBloc>().add(SelectSubject(subject))
            ),
          ),
        ],
      ),
      children: [

        for (Flashcard flashcard in deck.flashcards) ...[
          Padding(
            key: ValueKey(flashcard.id),
            padding: const EdgeInsets.only(bottom: 42.0),
            child: AdaptableCardHolder(
              visualize: visualize,
              index: flashcard.index,
              flashcardTextEditingController: AutoSaveTextEditingController(
                flashcard: flashcard,
                subjectBloc: context.read<SubjectBloc>(),
              ),
            ),
          ),
        ],
      ],
    );
  }

  void onReorder(BuildContext context, int oldIndex, int newIndex) {
    if (oldIndex < newIndex) {
      newIndex -= 1;
    }
    context.read<SubjectBloc>().add(ReorderFlashcard(
          newIndex: newIndex,
          oldIndex: oldIndex,
        ));
  }
}
