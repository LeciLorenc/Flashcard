import 'package:flashcard/calendar_and_recap/histogram.dart';
import 'package:flashcard/calendar_and_recap/welcome/welcomeViewModel.dart';
import 'package:flutter/material.dart';

import '../../constants.dart';
import 'monthAndYearPicker.dart';

class WelcomeWidget extends StatefulWidget {
  const WelcomeWidget({Key? key}) : super(key: key);

  @override
  _WelcomeWidgetState createState() => _WelcomeWidgetState();
}

class _WelcomeWidgetState extends State<WelcomeWidget> {
  late DateTime _selectedDate;

  @override
  void initState() {
    super.initState();
    _selectedDate = DateTime.now();
  }

  @override
  Widget build(BuildContext context) {
    return Theme(
      data: Theme.of(context).copyWith(
          colorScheme: const ColorScheme.light(
            primary: primaryColor, // Set the color for the selected date
          ),),
      child: Center(
        child: Column(
          children: [
            const Text(
              "WELCOME USER   (  :-)  )",
              style: TextStyle(fontSize: 20),
            ),
            const Text(
              "Here there is your monthly recap : ",
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
            histogramWidget(),
          ],
        ),
      ),
    );
  }

  Widget histogramWidget()
  {
    return Histogram(
      data: WelcomeData.computeCorrectPoints(_selectedDate),
      labels: WelcomeData.computeLabels(_selectedDate),
      maxTotal: WelcomeData.computeTotalPoints(_selectedDate),
    );
  }
}