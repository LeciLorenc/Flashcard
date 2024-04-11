
import 'package:country_flags/country_flags.dart';
import 'package:flutter/material.dart';

class DropdownLanguageSelector extends StatelessWidget {
  final String selectedLanguage;
  final void Function(String) onLanguageChanged;
  final Map<String, CountryFlag> languageIcons;

  const DropdownLanguageSelector({super.key,
    required this.selectedLanguage,
    required this.onLanguageChanged,
    required this.languageIcons,
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height:50,
      child:
      DropdownButton<String>(
        value: selectedLanguage,
        onChanged: (String? newValue) {
          if (newValue != null) {
            onLanguageChanged(newValue);
          }
        },
        items: languageIcons.entries.map<DropdownMenuItem<String>>((MapEntry<String, CountryFlag> entry) {
          return DropdownMenuItem<String>(
            value: entry.key,
            child: Row(
              children: [
                entry.value,
                const SizedBox(width: 8),
                Text(entry.key),
              ],
            ),
          );
        }).toList(),
      ),
    );
  }
}
