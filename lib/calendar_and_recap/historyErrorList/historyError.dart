import 'package:flashcard/calendar_and_recap/historyErrorList/CustomErrorListItem.dart';
import 'package:flashcard/calendar_and_recap/playErrors/playedSavings.dart';
import 'package:flutter/material.dart';

class HistoryError extends StatelessWidget {
  const HistoryError({super.key});

  @override
  Widget build(BuildContext context) {
    return StatefulBuilder(
      builder: (context, setState)
      {
        return Center
          (
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children:
            [
              const SizedBox(height: 16), // Spazio tra il testo e il ListView
              Expanded(
                child: ListView.builder(
                  itemCount: PlayedSavings.errorList.length,
                  itemBuilder: (context, index) {
                    final error = PlayedSavings. errorList[PlayedSavings.errorList.length-1-index];

                      return CustomErrorListItem(
                        item: error,
                      );
                  },
                ),
              ),

              ElevatedButton(
                onPressed: () {
                  PlayedSavings.deleteAll().then((_) {setState(() {});});
                },
                child: const SizedBox(
                  width: 170,
                  child: Center(
                    child: Row(
                      children: [
                        Icon(Icons.delete), // Removed 'const' from IconData
                        SizedBox(width: 8), // Added SizedBox for spacing
                        Text("Delete all the records"),
                      ],
                    ),
                  ),
                ),
              ),


            ],
          ),
        );
      },
    );
  }
}