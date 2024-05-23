import 'package:flutter/material.dart';
import '../../presentation/education_icons.dart';
import 'package:flashcard/ChatGPT_services/view/minorDialogs/iconPicker_dialog.dart';
import 'package:flashcard/ChatGPT_services/view/dropDown.dart';
import 'package:flashcard/ChatGPT_services/model-view/number_manipulation.dart';
import 'package:flashcard/ChatGPT_services/model/deckCreation.dart';


Widget buildDeckNameInput(BuildContext context, IconData iconName, DeckCreationViewModel deckCreationViewModel) {
  return Row(
    children: [
      IconButton(
        icon: Icon(iconName),
        onPressed: () async {},
      ),
      const SizedBox(width: 8),
      Expanded(
        child: TextField(
          decoration: const InputDecoration(
            hintText: "Enter the deck's name",
          ),
          controller: deckCreationViewModel.textEditingController,
        ),
      ),
    ],
  );
}

Widget buildLabelForNumberOfFlashcards(BuildContext context )
{
  return const Padding(
    padding: EdgeInsets.only(top: 20),
    child: Row(
      children: [
        SizedBox(width: 6),
        Icon(EducationIcons.calculator),
        SizedBox(width: 18),
        Expanded(child: Text('Select the number of flashcards')),
      ],
    ),
  );
}

Widget buildNumberOfFlashcards(BuildContext context, DeckCreationViewModel deckCreationViewModel )
{
  return Row(children: [
    const SizedBox(width: 45),
    NumberManipulationWidget(
      onNumberChanged: (newNumber)
      {
          deckCreationViewModel.number = newNumber;
      },),
  ]
  );
}

Widget buildLabelForLanguagesOfFlashcards()
{
  return const Padding(
    padding: EdgeInsets.only(top: 8.0),
    child: Row(
      children: [
        SizedBox(width: 6),
        Icon(EducationIcons.language),
        SizedBox(width: 18),
        Expanded(child: Text('Select the language that you want')),
      ],
    ),
  );
}

Widget buildLanguageOfFlashcards(DeckCreationViewModel deckCreationViewModel, setState)
{
  return Padding(
    padding: const EdgeInsets.only(top: 3.0),
    child: Row(
      children: [
        const SizedBox(width: 50),
        Container(
          constraints: const BoxConstraints(maxHeight: 70),
          child: DropdownLanguageSelector(
            selectedLanguage: deckCreationViewModel.selectedLanguage,
            onLanguageChanged: (String languageSelected) {
                deckCreationViewModel.selectedLanguage = languageSelected;
                setState(() {
                  deckCreationViewModel.selectedLanguage = languageSelected;
                });
            },
            languageIcons: deckCreationViewModel.languageIcons,
          ),
        ),
      ],
    ),
  );
}

Widget buildLabelForDescriptionOfFlashcards(DeckCreationViewModel deckCreationViewModel)
{
  return Row(
    children: [
      const Icon(EducationIcons.openBook),
      const SizedBox(width: 8+16),
      Expanded(
        child: TextField(
          decoration: const InputDecoration(
            hintText: 'Enter the description field',
          ),
          controller: deckCreationViewModel.textDescriptionController,
        ),
      ),
    ],
  );
}

Widget buildLabelForIconOfFlashcards()
{
  return const Padding(
    padding: EdgeInsets.only(top: 20),
    child: Row(
      children: [
        SizedBox(width: 6),
        Icon(EducationIcons.atom),
        SizedBox(width: 18),
        Expanded(child: Text('Select the icon')),
      ],
    ),
  );
}

Widget buildIconSelectionWidget(BuildContext context,DeckCreationViewModel deckCreationViewModel, setState)
{
  return Row(children: [
    const SizedBox(width: 45),
    Icon(deckCreationViewModel.selectedIcon),
    ElevatedButton(
      onPressed: () {
        showIconPickerDialog(context, (IconData newValue) {
            deckCreationViewModel.selectedIcon = newValue;
            setState(() {
              deckCreationViewModel.selectedIcon = newValue;
            });
        });
      },
      child: const Text('Change'),
    ),
  ]);
}

Widget okButtonAction(DeckCreationViewModel deckCreationViewModel, BuildContext context)
{
  return TextButton(
    onPressed: () => Navigator.pop(context, ['OK',
      deckCreationViewModel.textEditingController.text,
      deckCreationViewModel.textDescriptionController.text,
      deckCreationViewModel.number,
      deckCreationViewModel.selectedLanguage,
      deckCreationViewModel.selectedIcon]),
    child: const Text('OK'),
  );
}
Widget cancelButtonAction(BuildContext context)
{
  return TextButton(
    onPressed: () => Navigator.pop(context, ['Cancel']),
    child: const Text('Cancel'),
  );
}