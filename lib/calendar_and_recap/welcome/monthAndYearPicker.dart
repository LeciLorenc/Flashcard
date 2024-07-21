import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class MonthYearPicker extends StatefulWidget {
  final Function(DateTime) onChanged;
  final DateTime initialDate;

  const MonthYearPicker({Key? key, required this.onChanged, required this.initialDate}) : super(key: key);

  @override
  _MonthYearPickerState createState() => _MonthYearPickerState();
}

class _MonthYearPickerState extends State<MonthYearPicker> {
  late DateTime _selectedDate;

  @override
  void initState() {
    super.initState();
    _selectedDate = widget.initialDate;
  }

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        ElevatedButton(
          onPressed: () {
            _showMonthYearPicker(context);
          },
          child: Text(
            DateFormat('MMM yyyy').format(_selectedDate),
          ),
        ),
      ],
    );
  }

  Future<void> _showMonthYearPicker(BuildContext context) async {
    DateTime? pickedDate = await showDialog<DateTime>(
      barrierColor: Colors.black.withOpacity(0.3),
      context: context,
      builder: (BuildContext context) {
        int selectedMonth = _selectedDate.month;
        int selectedYear = _selectedDate.year;

        return StatefulBuilder(
          builder: (BuildContext context, StateSetter setState) {
            return AlertDialog(
              title: const Text('Select Month and Year'),
              content: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Row(
                    children: [
                      Expanded(
                        child: DropdownButton<int>(
                          value: selectedMonth,
                          onChanged: (int? month) {
                            if (month != null) {
                              setState(() {
                                selectedMonth = month;
                              });
                            }
                          },
                          items: List.generate(12, (index) {
                            return DropdownMenuItem<int>(
                              value: index + 1,
                              child: Text(DateFormat('MMMM').format(DateTime(2022, index + 1))),
                            );
                          }),
                        ),
                      ),
                      const SizedBox(width: 16),
                      Expanded(
                        child: DropdownButton<int>(
                          value: selectedYear,
                          onChanged: (int? year) {
                            if (year != null) {
                              setState(() {
                                selectedYear = year;
                              });
                            }
                          },
                          items: List.generate(30, (index) {
                            return DropdownMenuItem<int>(
                              value: DateTime.now().year - 15 + index,
                              child: Text('${DateTime.now().year - 15 + index}'),
                            );
                          }),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
              actions: <Widget>[
                TextButton(
                  onPressed: () {
                  Navigator.of(context).pop();
                },
                child: const Text('Cancel'),
                ),
                TextButton(
                  onPressed: () {
                    Navigator.of(context).pop(DateTime(selectedYear, selectedMonth));
                  },
                  child: const Text('OK'),
                ),
              ],
            );
          },
        );
      },
    );

    if (pickedDate != null && pickedDate != _selectedDate) {
      setState(() {
        _selectedDate = pickedDate;
        widget.onChanged(_selectedDate);
      });
    }
  }

}
