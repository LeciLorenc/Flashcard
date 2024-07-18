
import 'package:flashcard/constants.dart';
import 'package:flutter/material.dart';

import '../../main.dart';

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


    return Theme(
      data: Theme.of(context).copyWith(
        colorScheme: isDark
            ? const ColorScheme.dark(
          primary: primaryColor,
          onPrimary: lightTextColor, //bianc
          surface: darkTextColor, //nero
          onSurface: darkTextColor, //nero
        )
            : ColorScheme.light(
          primary: primaryColor,
          onPrimary: darkTextColor,//nero   on primary colore font scritta light
          surface: lightTextColor,//bianc
          onSurface: lightTextColor,//bianc
        ),
        textButtonTheme: TextButtonThemeData(
          style: TextButton.styleFrom(
            foregroundColor: primaryColor, // Button text color
          ),
        ),
      ),
      child: Column(
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
      ),
    );
  }
}
