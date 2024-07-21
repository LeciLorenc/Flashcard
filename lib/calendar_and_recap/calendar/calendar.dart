import 'package:flashcard/calendar_and_recap/pastErrors/model/newObject.dart';
import 'package:flashcard/calendar_and_recap/pastErrors/storage/NewFilters.dart';
import 'package:flashcard/calendar_and_recap/pastErrors/storage/utilitiesStorage.dart';
import 'package:flashcard/constants.dart';
import 'package:flashcard/pages/home_page/home_page.dart';
import 'package:flutter/material.dart';

import '../../main.dart';
import '../pastErrors/storage/NewSavings.dart';
import 'CustomPlayedListItem.dart';
import 'calendarDataPicker.dart';

class CalendarWidget extends StatefulWidget {
  const CalendarWidget({super.key});

  @override
  _CalendarWidgetState createState() => _CalendarWidgetState();
}

class _CalendarWidgetState extends State<CalendarWidget> {
  late DateTime _selectedDate;

  @override
  void initState() {
    super.initState();
    _selectedDate = DateTime.now();
  }

  void _updateSelectedDate(DateTime date) {
    setState(() {
      _selectedDate = date;
    });
  }

  List<PastErrorsObject> calculateListOfPlayed()
  {
    return NewFiltersStorage.calculatePlayedListWithOnlyDate(_selectedDate, NewFiltersStorage.filterByUser(globalUserId, NewSavings.savings));
  }


  @override
  Widget build(BuildContext context) {
    final brightness = Theme.of(context).brightness;
    final isDarkMode = brightness == Brightness.dark;

    if(MediaQuery.of(context).orientation == Orientation.portrait) {
      return Scaffold(
        body: Theme(
          data: Theme.of(context).copyWith(
            colorScheme: isDarkMode
                ? const ColorScheme.dark(
              primary: primaryColor,
            )
                : const ColorScheme.light(
              primary: primaryColor,
            ),
          ),
          child: SingleChildScrollView(
            child: Column(
              children: [
                buildCalendarPicker(  MediaQuery.of(context).size.width *0.8,
                    MediaQuery.of(context).size.height * 0.5),
                buildDate(),
                buildListOfFilteredSavings( MediaQuery.of(context).size.width *0.8,
                    MediaQuery.of(context).size.height *0.35),
              ],
            ),
          ),
        ),
      );
    }
    else
    {
      return Scaffold(
        body: Theme(
          data: Theme.of(context).copyWith(
            colorScheme: const ColorScheme.light(
              primary: primaryColor, // Set the color for the selected date
            ),
          ),
          child: Row(
            children: [
              Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  buildCalendarPicker(MediaQuery.of(context).size.width *0.3,
                      MediaQuery.of(context).size.height * 0.9),
                ],
              ),
              Column(
                children: [
                  buildDate(),
                  buildListOfFilteredSavings(
                      HomePage.expanded ?  MediaQuery.of(context).size.width *0.4
                          :   MediaQuery.of(context).size.width *0.6,
                      MediaQuery.of(context).size.height *0.8),
                ],
              ),
            ],
          ),
        ),
      );
    }
  }


  Widget buildListOfFilteredSavings(double width, double height)
  {
    return Center(
      child: ConstrainedBox(
        constraints:  BoxConstraints(
          maxWidth: width,
          maxHeight: height*0.9,
        ),
        child: Container(
          margin: const EdgeInsets.all(3.0),
          decoration: BoxDecoration(
            border: Border.all(width: 1.0, color: Colors.black),
            borderRadius: BorderRadius.circular(8.0),
          ),
          child: Padding(
            padding: const EdgeInsets.all(2.0),
            child: Column(
              children: [
                Expanded(
                  child: ListView.builder(
                    itemCount: calculateListOfPlayed().length,
                    itemBuilder: (context, index) {
                      final playedItem = calculateListOfPlayed()[index];
                      return CustomPlayedListItem(
                        item: playedItem,
                      );
                    },
                  ),
                ),
              ],
            ),
          ),
        ),

      ),
    );
  }


  Widget buildCalendarPicker(double width, double height)
  {
    return SingleChildScrollView(
      child: ConstrainedBox(
        constraints:  BoxConstraints(
          maxWidth: width,
          maxHeight: height,
        ),
        child: DatePickerWidget(
          initialDate: _selectedDate,
          onDateChanged: _updateSelectedDate,
        ),
      ),
    );
  }

  Widget buildDate()
  {
    String dateWithWords = UtilitiesStorage.fromDateFormatToDateWithWords(_selectedDate);
    return Column(
      children: [
        const Text("Date selected: "),
        Text(dateWithWords,
          style: const TextStyle(
            fontSize: 16.0,
            fontWeight: FontWeight.bold,
            letterSpacing: 2.0,
            color: primaryColor,
          ),),
      ],
    );
  }
}
