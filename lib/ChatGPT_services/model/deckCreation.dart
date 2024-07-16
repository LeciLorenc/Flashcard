
import 'package:country_flags/country_flags.dart';
import 'package:flutter/material.dart';

import '../../presentation/education_icons.dart';

class DeckCreationViewModel {
  late TextEditingController textEditingController;
  late TextEditingController textDescriptionController;
  late int number;
  late IconData iconName;
  late IconData iconDescription;
  late String selectedLanguage;
  late IconData selectedIcon;

  late Map<String, dynamic> languageIcons; // Declare here

  DeckCreationViewModel() {
    textEditingController = TextEditingController();
    textDescriptionController = TextEditingController();
    number = 5;
    iconName = EducationIcons.teaching;
    iconDescription = EducationIcons.certificate;
    selectedLanguage = 'English';
    selectedIcon = Icons.book;

    // Initialize languageIcons map here
    languageIcons = {
      'Italian': builderCountryIcon("it"),
      'English': builderCountryIcon("gb"),
      'Russian': builderCountryIcon("ru"),
      'Spanish': builderCountryIcon("es"),
      'Portuguese': builderCountryIcon("pt"),
      'German': builderCountryIcon("de"),
      'Chinese': builderCountryIcon("cn"),
      'Others': Icons.language,
      // Add more languages and their respective flag icons here
    };
  }

  CountryFlag   builderCountryIcon(String language) {
    return CountryFlag.fromCountryCode(
      language,
      height: 20,
      width: 20,
      borderRadius: 5,
    );
  }
}
