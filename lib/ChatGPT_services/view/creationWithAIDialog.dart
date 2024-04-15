import 'package:flashcard/ChatGPT_services/view/lists_of_small_widgets.dart';
import 'package:flutter/material.dart';
import '../../../presentation/education_icons.dart';
import '../model/deckCreation.dart';

Future<List<dynamic>> creationWithAIDialog(BuildContext context, DeckCreationViewModel deckCreationViewModel) async {

  final result = await showDialog<List<dynamic>>(
    barrierColor: Colors.black.withOpacity(0.3),
    context: context,

    builder: (BuildContext context) {
      return StatefulBuilder(
        builder: (context, setState) {
          return AlertDialog(
            title: const Text('Create new deck with AI'),
            content: SingleChildScrollView(
              child: Flex(
                direction: Axis.vertical,
                mainAxisSize: MainAxisSize.min,
                children: [
                  buildDeckNameInput(context, EducationIcons.teaching, deckCreationViewModel),

                  buildLabelForNumberOfFlashcards(context),
                  buildNumberOfFlashcards(context,deckCreationViewModel),

                  buildLabelForLanguagesOfFlashcards(),
                  buildLanguageOfFlashcards(deckCreationViewModel, setState),

                  buildLabelForDescriptionOfFlashcards(deckCreationViewModel),

                  buildLabelForIconOfFlashcards(),
                  buildIconSelectionWidget(context, deckCreationViewModel, setState),

                ],
              ),
            ),
            actions: <Widget>[
              TextButton(
                onPressed: () => Navigator.pop(context, ['OK',
                  deckCreationViewModel.textEditingController.text,
                  deckCreationViewModel.textDescriptionController.text,
                  deckCreationViewModel.number,
                  deckCreationViewModel.selectedLanguage,
                  deckCreationViewModel.selectedIcon]),
                child: const Text('OK'),
              ),
              TextButton(
                onPressed: () => Navigator.pop(context, ['Cancel']),
                child: const Text('Cancel'),
              ),
            ],
          );
        },
      );
    },
  );

  return result ?? [];

}


