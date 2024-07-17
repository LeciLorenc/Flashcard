import 'package:flashcard/pages/home_page/home_page.dart';
import 'package:flutter/material.dart';
import 'package:flashcard/ChatGPT_services/model-view/api_service.dart';

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

    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(height: 10),
          Text(
            "Here there are some settings :",
            style: TextStyle(fontSize: 18),
          ),
          SizedBox(height: 10),
          Container(
            width: double.infinity,
            child: SwitchListTile(
              title: Text('Dark Mode', style: TextStyle(color: textColor)),
              value: isDarkMode,
              onChanged: (bool value) {
                widget.onThemeChanged(value);
              },
            ),
          ),
          SizedBox(height: 10),

          // Display current API key
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              SizedBox(width: 15,),
              Text("API key: ", style: TextStyle(fontSize: 18),),
              Flexible(
                child: Text(
                  _newApiKey,
                  style: TextStyle(color: textColor),
                ),
              ),
            ],
          ),
          SizedBox(height: 10),

          // Button to change API key
          Row(
            children: [
              SizedBox(width: 80,),
              ElevatedButton(
                onPressed: () {
                  showNewWidget(context);
                },
                child: const Text("Click here to change the API"),
              ),
            ],
          ),
        ],
      ),
    );
  }

  void showNewWidget(BuildContext context) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Change API Key'),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: <Widget>[
              TextField(
                decoration: InputDecoration(labelText: 'New API Key'),
                onChanged: (value) {
                  setState(() {
                    _newApiKey = value;
                  });
                },
              ),
            ],
          ),
          actions: <Widget>[
            TextButton(
              child: Text('Cancel'),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
            TextButton(
              child: Text('Save'),
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
