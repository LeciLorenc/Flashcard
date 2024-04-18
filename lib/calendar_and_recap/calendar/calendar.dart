import 'package:flashcard/calendar_and_recap/playErrors/model/incorrectItem.dart';
import 'package:flashcard/calendar_and_recap/playErrors/model/playedItems.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import '../historyErrorList/CustomPlayedListItem.dart';
import '../playErrors/playedSavings.dart';

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


  String getDateFromSelectedDate()
  {
    return DateFormat('yyyy-MM-dd').format(_selectedDate).toString();
  }

  List<PlayedDeck> calculatePlayedListWithDate()
  {
  return  PlayedSavings.
            getPlayedItemsFilteredByDate(getDateFromSelectedDate());
  }

  List<IncorrectItem> calculateNumberOfErrors(String time, String subject, String deck)
  {
    return PlayedSavings.getErrorItemsFilteredByDateSubjectDeck(getDateFromSelectedDate(), time,subject, deck);
  }




  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Your Calendar: '),
      ),
      body: Column(
        children: [
          ConstrainedBox(
            constraints:  BoxConstraints(
              maxWidth: MediaQuery.of(context).size.width / 1.2,
              maxHeight: MediaQuery.of(context).size.height / 1,
            ),
              child: DatePickerWidget(
                initialDate: _selectedDate,
                onDateChanged: _updateSelectedDate,
              ),
          ),
          Center(
           
              child: ConstrainedBox(
                constraints:  BoxConstraints(
                  maxWidth: MediaQuery.of(context).size.width / 1.2,
                  maxHeight: MediaQuery.of(context).size.height / 3.2,
                ),
                child: Container(
                  margin: const EdgeInsets.all(3.0),
                  decoration: BoxDecoration(
                    border: Border.all(width: 1.0, color: Colors.black),
                    borderRadius: BorderRadius.circular(8.0),
                  ),
                  child: SingleChildScrollView(
                    child: Padding(
                      padding: const EdgeInsets.all(2.0),
                      child: Column(
                        children: [
                          SizedBox(
                            height: MediaQuery.of(context).size.height / 2,
                            child: ListView.builder(
                              itemCount: calculatePlayedListWithDate().length,
                              itemBuilder: (context, index) {
                                final playedItem = calculatePlayedListWithDate()[calculatePlayedListWithDate().length-1-index];
                                return CustomPlayedListItem(
                                  item: playedItem,
                                  numberOfErrors: calculateNumberOfErrors(playedItem.time, playedItem.subject, playedItem.deck),
                                );
                              },
                            ),
                          ),

                        ],
                      ),
                    ),
                  ),
                ),
              ),
            ),
        ],
      ),
    );
  }
}

class DatePickerWidget extends StatefulWidget {
  final DateTime initialDate;
  final ValueChanged<DateTime> onDateChanged;

  const DatePickerWidget({
    required this.initialDate,
    required this.onDateChanged,
    super.key,
  });

  @override
  _DatePickerWidgetState createState() => _DatePickerWidgetState();
}

class _DatePickerWidgetState extends State<DatePickerWidget> {
  late DateTime _selectedDate;

  @override
  void initState() {
    super.initState();
    _selectedDate = widget.initialDate;
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        CalendarDatePicker(
          initialDate: widget.initialDate,
          firstDate: DateTime(2015, 8),
          lastDate: DateTime(2101),
          onDateChanged: (date) {
            setState(() {
              _selectedDate = date;
              widget.onDateChanged(date);
            });
          },
        ),
      ],
    );
  }
}
