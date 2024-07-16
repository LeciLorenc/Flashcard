
import 'package:country_flags/country_flags.dart';
import 'package:flutter/material.dart';

class DropdownLanguageSelector extends StatelessWidget {
  final String selectedLanguage;
  final void Function(String) onLanguageChanged;
  final Map<String, dynamic> languageIcons;

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
        items: languageIcons.entries.map<DropdownMenuItem<String>>((MapEntry<String, dynamic> entry) {
          Widget iconWidget;
          if (entry.value is CountryFlag) {
            iconWidget = entry.value as CountryFlag; // Cast to CountryFlag
          } else if (entry.value is IconData) {
            iconWidget = Icon(entry.value as IconData); // Cast to IconData and create Icon widget
          } else {
            iconWidget = Container(); // Handle unknown cases, if any
          }

          return DropdownMenuItem<String>(
            value: entry.key,
            child: Row(
              children: [
                iconWidget,
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
