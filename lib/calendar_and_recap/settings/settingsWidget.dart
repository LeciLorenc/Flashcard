import 'package:flashcard/constants.dart';
import 'package:flutter/material.dart';
import 'package:flashcard/ChatGPT_services/model-view/api_service.dart';
import 'package:flutter/services.dart';

import '../../main.dart';

class SettingsWidget extends StatefulWidget {
  final Function(bool) onThemeChanged;

  SettingsWidget({required this.onThemeChanged});

  @override
  _SettingsWidgetState createState() => _SettingsWidgetState();
}

class _SettingsWidgetState extends State<SettingsWidget> {
  late String _newApiKey;

  @override
  void initState() {
    super.initState();
    _newApiKey = ApiService.getApiKey(globalUserId); // Initialize with current API key
  }

  @override
  Widget build(BuildContext context) {
    final brightness = Theme.of(context).brightness;
    final isDarkMode = brightness == Brightness.dark;
    final textColor = isDarkMode ? Colors.white : Colors.black;

    return Scaffold(
      body: SingleChildScrollView(
        child: ConstrainedBox(
          constraints: BoxConstraints(
            minHeight: MediaQuery.of(context).size.height,
          ),
          child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const SizedBox(height: 10),
                const Text(
                  "Here there are some settings :",
                  style: TextStyle(fontSize: 18),
                ),
                const SizedBox(height: 10),
                Container(
                  width: double.infinity,
                  child: SwitchListTile(
                    trackColor: MaterialStateProperty.all(
                      isDarkMode
                          ? backgroundButtonColorDark
                          : backgroundButtonColorLight,
                    ),
                    title: Text('Dark Mode', style: TextStyle(color: textColor)),
                    value: isDarkMode,
                    onChanged: (bool value) {
                      widget.onThemeChanged(value);
                    },
                  ),
                ),
                const SizedBox(height: 10),

                // Display current API key
                Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const SizedBox(width: 15),
                    const Text(
                      "API key: ",
                      style: TextStyle(fontSize: 18),
                    ),
                    Flexible(
                      child: GestureDetector(
                        onTap: () {
                          Clipboard.setData(ClipboardData(text: _newApiKey));
                          ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(content: Text("API key copied to clipboard")),
                          );
                        },
                        child: Text(
                          _newApiKey,
                          style: TextStyle(color: textColor),
                        ),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 10),

                // Button to change API key
                Row(
                  children: [
                    const SizedBox(width: 80),
                    ElevatedButton(
                      onPressed: () {
                        changeApiButtonWidget(context);
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: isDark
                            ? backgroundButtonColorDark
                            : backgroundButtonColorLight, // Set the background color here
                      ),
                      child: const Text(
                        "Click here to change the API",
                        style: TextStyle(color: primaryColor), // Set the text color
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  void changeApiButtonWidget(BuildContext context) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Change API Key'),
          content: SingleChildScrollView(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: <Widget>[
                TextField(
                  decoration: const InputDecoration(labelText: 'New API Key'),
                  onChanged: (value) {
                    setState(() {
                      _newApiKey = value;
                    });
                  },
                ),
              ],
            ),
          ),
          actions: <Widget>[
            TextButton(
              child: const Text('Cancel',  style: TextStyle(color: primaryColor),),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
            TextButton(
              child: const Text('Save', style: TextStyle(color: primaryColor),),
              onPressed: () {
                setState(() {
                  ApiService.setApiKey(globalUserId, _newApiKey); // Update API key
                });
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );
  }
}
