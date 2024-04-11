
import 'package:country_flags/country_flags.dart';
import 'package:flutter/material.dart';

import '../../presentation/education_icons.dart';

import 'package:flashcard/ChatGPT_services/model-view/AI_dialog_widget.dart';

class DeckCreationViewModel {
  late TextEditingController textEditingController;
  late TextEditingController textDescriptionController;
  late int number;
  late IconData iconName;
  late IconData iconDescription;
  late String selectedLanguage;
  late IconData selectedIcon;

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

  DeckCreationViewModel() {
    textEditingController = TextEditingController();
    textDescriptionController = TextEditingController();
    number = 5;
    iconName = EducationIcons.teaching;
    iconDescription = EducationIcons.certificate;
    selectedLanguage = 'English';
    selectedIcon = Icons.book;
  }
}
