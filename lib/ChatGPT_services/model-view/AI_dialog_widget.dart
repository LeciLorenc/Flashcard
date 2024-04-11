import 'package:flutter/material.dart';
import 'package:country_flags/country_flags.dart';
import '../../../presentation/education_icons.dart';
import 'package:flashcard/ChatGPT_services/view/dialogs/iconPicker_dialog.dart';
import 'package:flashcard/ChatGPT_services/view/dropDown.dart';
import 'package:flashcard/ChatGPT_services/model-view/number_manipulation.dart';

CountryFlag builderCountryIcon(String language)
{
  return CountryFlag.fromCountryCode(
    language,
    height: 20,
    width: 20,
    borderRadius: 5,
  );
}
Future<List<dynamic>> showDeckDialog(BuildContext context) async {

  TextEditingController textEditingController = TextEditingController();
  TextEditingController textDescriptionController = TextEditingController();
  int number=5;
  String selectedLanguage = 'English';
  IconData selectedIcon=Icons.book;

  final Map<String, CountryFlag> languageIcons = {
    'Italian': builderCountryIcon("it"),
    'English': builderCountryIcon("gb"),
    'Russian': builderCountryIcon("ru"),
    'Spanish': builderCountryIcon("es"),
    'Portuguese': builderCountryIcon("pt"),
    'German': builderCountryIcon("de"),
    'Chinese': builderCountryIcon("cn"),
    // Add more languages and their respective flag icons here
  };


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
                  Row(
                    children: [
                      const Icon(EducationIcons.teaching),
                      const SizedBox(width: 8),
                      Expanded(
                        child: TextField(
                          decoration: const InputDecoration(
                            hintText: 'Enter the name of the deck',
                          ),
                          controller: textEditingController,
                        ),
                      ),
                    ],
                  ),
                  const Padding(
                    padding: EdgeInsets.only(top: 20),
                    child: Row(
                      children: [
                        SizedBox(width: 6),
                        Icon(EducationIcons.calculator),
                        SizedBox(width: 18),
                        Expanded(child: Text('Select the number of flashcards')),
                      ],
                    ),
                  ),
                  Row(children: [
                    const SizedBox(width: 45),
                    NumberManipulationWidget(
                      onNumberChanged: (newNumber)
                      {
                        setState(() {
                        number = newNumber;
                        });
                      },),
                  ]),
                  const Padding(
                    padding: EdgeInsets.only(top: 8.0),
                    child: Row(
                      children: [
                        SizedBox(width: 6),
                        Icon(EducationIcons.language),
                        SizedBox(width: 18),
                        Expanded(child: Text('Select the language that you want')),
                      ],
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.only(top: 3.0),
                    child: Row(
                      children: [
                        const SizedBox(width: 50),
                        Container(
                          constraints: const BoxConstraints(maxHeight: 70),
                          child: DropdownLanguageSelector(
                              selectedLanguage: selectedLanguage,
                              onLanguageChanged: (String newValue) {
                                setState(() {
                                  selectedLanguage = newValue;
                                });
                              },
                              languageIcons: languageIcons,
                            ),
                        ),
                      ],
                    ),
                  ),
                  Row(
                    children: [
                      const Icon(EducationIcons.openBook),
                      const SizedBox(width: 8),
                      Expanded(
                        child: TextField(
                          decoration: const InputDecoration(
                            hintText: 'Enter the description field',
                          ),
                          controller: textDescriptionController,
                        ),
                      ),
                    ],
                  ),
                  const Padding(
                    padding: EdgeInsets.only(top: 20),
                    child: Row(
                      children: [
                        SizedBox(width: 6),
                        Icon(EducationIcons.atom),
                        SizedBox(width: 18),
                        Expanded(child: Text('Select the icon')),
                      ],
                    ),
                  ),
                  Row(children: [
                    const SizedBox(width: 45),
                    Icon(selectedIcon),
                    ElevatedButton(
                      onPressed: () {
                        showIconPickerDialog(context, (IconData newValue) {
                          setState(() {
                            selectedIcon = newValue;
                          });
                        });
                      },
                      child: const Text('Change'),
                    ),
                  ]),
                ],
              ),
            ),
            actions: <Widget>[
              TextButton(
                onPressed: () => Navigator.pop(context, ['OK',
                                              textEditingController.text,
                                              textDescriptionController.text,
                                              number,
                                              selectedLanguage,
                                              selectedIcon]),
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


