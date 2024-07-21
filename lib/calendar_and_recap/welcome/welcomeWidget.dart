import 'package:flutter/material.dart';
import 'package:flashcard/calendar_and_recap/histogram.dart';
import 'package:flashcard/calendar_and_recap/welcome/welcomeViewModel.dart';
import '../../ChatGPT_services/model-view/api_service.dart';
import '../../constants.dart';
import '../../main.dart';
import 'monthAndYearPicker.dart';

class WelcomeWidget extends StatefulWidget {
  const WelcomeWidget({Key? key}) : super(key: key);

  @override
  _WelcomeWidgetState createState() => _WelcomeWidgetState();
}

class _WelcomeWidgetState extends State<WelcomeWidget> {
  late DateTime _selectedDate;
  String? _apiKey;
  bool _isLoading = true; // Added loading state

  @override
  void initState() {
    super.initState();
    _selectedDate = DateTime.now();
    _fetchApiKey();
  }

  void _fetchApiKey() async {
    String? apiKey = await ApiService.getApiKey(globalUserId);
    setState(() {
      _apiKey = apiKey;
      _isLoading = false; // Set loading to false once fetching is done
    });

    if (_apiKey == null || _apiKey == "" || _apiKey == " ") {
      _showApiKeyAlertDialog();
    }
  }

  void _showApiKeyAlertDialog() {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: const Text('API Key Missing'),
            content: const Text(
              "You didn't set the API key. Go to settings and set it in order to access all the functionalities of this app.",
              style: TextStyle(fontSize: 13, color: primaryColor),
              textAlign: TextAlign.center,
            ),
            actions: <Widget>[
              TextButton(
                child: const Text('OK', style: TextStyle(color: primaryColor)),
                onPressed: () {
                  Navigator.of(context).pop();
                },
              ),
            ],
          );
        },
      );
    });
  }

  @override
  Widget build(BuildContext context) {
    final isDarkMode = Theme.of(context).brightness == Brightness.dark;

    return LayoutBuilder(
      builder: (context, constraints) {
        if (constraints.maxWidth < 600) {
          // Portrait Mode
          return _buildPortraitLayout();
        } else {
          // Landscape Mode
          return _buildLandscapeLayout();
        }
      },
    );
  }

  Widget _buildPortraitLayout() {
    return Theme(
      data: Theme.of(context).copyWith(
        colorScheme: const ColorScheme.light(
          primary: primaryColor, // Set the color for the selected date
        ),
      ),
      child: Center(
        child: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                const SizedBox(height: 10),
                const Text(
                  "Hi User, welcome back!",
                  style: TextStyle(fontSize: 30),
                ),
                const SizedBox(height:90),
                if (_isLoading) const CircularProgressIndicator(), // Show a loading indicator while fetching
                const SizedBox(height: 50),
                const Text(
                  "Here there is your monthly recap:",
                  style: TextStyle(fontSize: 17),
                ),
                MonthYearPicker(
                  onChanged: (DateTime newDate) {
                    setState(() {
                      _selectedDate = newDate;
                    });
                  },
                  initialDate: _selectedDate,
                ),
                const SizedBox(height: 16),
                HistogramWidget(
                  selectedDate: _selectedDate,
                ),
                const SizedBox(height: 26),
                const Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      'blue lines',
                      style: TextStyle(
                        color: Colors.blue, // Set the text color to blue
                      ),
                    ),
                    Text(" = correct answers"),
                  ],
                ),
                const Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      'orange lines',
                      style: TextStyle(
                        color: Colors.orange, // Set the text color to blue
                      ),
                    ),
                    Text(" = wrong answers"),
                  ],
                ),
                SizedBox(height: 90,),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildLandscapeLayout() {
    return Theme(
      data: Theme.of(context).copyWith(
        colorScheme: const ColorScheme.light(
          primary: primaryColor, // Set the color for the selected date
        ),
      ),
      child: Center(
        child: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                const SizedBox(height: 10),
                const Text(
                  "Hi User, welcome back!",
                  style: TextStyle(fontSize: 30),
                ),
                if (_isLoading) const CircularProgressIndicator(), // Show a loading indicator while fetching
                const SizedBox(height: 10),
                const Text(
                  "Here there is your monthly recap:",
                  style: TextStyle(fontSize: 17),
                ),
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Row(
                    children: [
                      Flexible(
                        flex: 2,
                        child: Column(
                          children: [
                            Text("Choose here the month to display)"),
                            MonthYearPicker(
                              onChanged: (DateTime newDate) {
                                setState(() {
                                  _selectedDate = newDate;
                                });
                              },
                              initialDate: _selectedDate,
                            ),

                            SizedBox(height: 40,),
                            const Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Text(
                                  'blue lines',
                                  style: TextStyle(
                                    color: Colors.blue, // Set the text color to blue
                                  ),
                                ),
                                Text(" = correct answers"),
                              ],
                            ),
                            const Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Text(
                                  'orange lines',
                                  style: TextStyle(
                                    color: Colors.orange, // Set the text color to blue
                                  ),
                                ),
                                Text(" = wrong answers"),
                              ],
                            ),

                          ],
                        ),
                      ),
                      const SizedBox(width: 50),
                      Flexible(
                        flex: 2,
                        child: HistogramWidget(
                          selectedDate: _selectedDate,
                        ),
                      ),
                    ],
                  ),
                ),

                const SizedBox(height: 26),

              ],
            ),
          ),
        ),
      ),
    );
  }
}

class HistogramWidget extends StatelessWidget {
  final DateTime selectedDate;

  const HistogramWidget({Key? key, required this.selectedDate}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Histogram(
      points: WelcomeData.computeCorrectPoints(selectedDate),
      labels: WelcomeData.computeLabels(selectedDate),
      maxTotal: WelcomeData.computeTotalPoints(selectedDate),
    );
  }
}
