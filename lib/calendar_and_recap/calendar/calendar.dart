import 'package:flashcard/calendar_and_recap/playErrors/model/newObject.dart';
import 'package:flashcard/calendar_and_recap/---TO_BE_DISCARDED---/playedItems.dart';
import 'package:flashcard/calendar_and_recap/playErrors/storage/utilitiesStorage.dart';
import 'package:flutter/material.dart';

import 'CustomPlayedListItem.dart';
import '../---TO_BE_DISCARDED---/incorrectItem.dart';
import 'DataPicker.dart';

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

  /*PlayedDeck calculatePlayedItem(int index)
  {
    int indexToUse = UtilitiesStorage.calculatePlayedListWithOnlyDate(_selectedDate).length-1-index;
    return UtilitiesStorage.calculatePlayedListWithOnlyDate(_selectedDate)[indexToUse];
  }
  List<IncorrectItem> calculateErrors(PlayedDeck playedItem)
  {
    return UtilitiesStorage.calculateNumberOfErrors(playedItem.time, _selectedDate ,playedItem.subject, playedItem.deck);
  }
*/

  List<NewObject> calculateListOfPlayed()
  {
     return UtilitiesStorage.calculatePlayedListWithOnlyDate(_selectedDate);
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
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
           
              /*child: ConstrainedBox(
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
                              itemCount: UtilitiesStorage.calculatePlayedListWithOnlyDate(_selectedDate).length,
                              itemBuilder: (context, index) {
                                final playedItem = calculatePlayedItem(index);
                                return CustomPlayedListItem(
                                  item: playedItem,
                                  numberOfErrors: calculateErrors(playedItem),
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
    );*/
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
            ),
          ),
        ],
      ),
    );
  }
}
