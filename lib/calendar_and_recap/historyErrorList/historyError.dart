import 'package:flashcard/calendar_and_recap/historyErrorList/CustomErrorListItem.dart';
import 'package:flashcard/calendar_and_recap/playErrors/storage/NewSavings.dart';
//import 'package:flashcard/calendar_and_recap/playErrors/storage/storageData.dart';
import 'package:flutter/material.dart';


class HistoryError extends StatefulWidget {
  const HistoryError({super.key});

  @override
  _HistoryErrorState createState() => _HistoryErrorState();
}

class _HistoryErrorState extends State<HistoryError> {
  bool _isExpanded = false;
/*
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
                  itemCount: StorageData.errorList.length,
                  itemBuilder: (context, index) {
                    final error = StorageData. errorList[StorageData.errorList.length-1-index];

                      return CustomErrorListItem(
                        item: error,
                      );
                  },
                ),
              ),

              ElevatedButton(
                onPressed: () {
                  StorageData.deleteAll().then((_) {setState(() {});});
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
  }*/

  @override
  Widget build(BuildContext context) {
    return StatefulBuilder(
      builder: (context, setState) {
        return Padding(
          padding: const EdgeInsets.all(8.0),
          child: Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                FilterButton(),
                const SizedBox(height: 16),
                savingList(),
                deleteAllButton(),
              ],
            ),
          ),
        );
      },
    );
  }


  Widget filteringMenu() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.start,
      children: [

        // Filtraggio per deck
        DropdownButton<String>(
          hint: const Text('Select Deck'),
          onChanged: (String? newValue) {
            // Modificato il tipo del parametro
            // Implementa la logica per filtrare per deck
          },
          items: <String>['Deck 1', 'Deck 2', 'Deck 3']
              .map((String value) {
            return DropdownMenuItem<String>(
              value: value,
              child: Text(value),
            );
          }).toList(),
        ),

        // Filtraggio per subject
        DropdownButton<String>(
          hint: const Text('Select Subject'),
          onChanged: (String? newValue) { // Modificato il tipo del parametro
            // Implementa la logica per filtrare per subject
          },
          items: <String>['Subject 1', 'Subject 2', 'Subject 3']
              .map((String value) {
            return DropdownMenuItem<String>(
              value: value,
              child: Text(value),
            );
          }).toList(),
        ),

        // Filtraggio per data
        ElevatedButton(
          onPressed: () {
            // Implementa la logica per filtrare per data
          },
          child: const Row(
            children: [
              Icon(Icons.calendar_today),
              Text("Filter by Date"),
            ],
          ),
        ),
      ],
    );
  }


  Widget FilterButton()
  {
    return ElevatedButton(
      onPressed: () {
        setState(() {
          _isExpanded = !_isExpanded;
        });
      },
      style: ElevatedButton.styleFrom(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(20), // Specifica il raggio del bordo desiderato
        ),
      ),
      child: Column(
        children: [
          Row(
            children: [
              const Icon (Icons.filter_alt),
              Text(_isExpanded ? "Hide Filters" : "Filters"),
            ],
          ),
          Row(
            children : [
              AnimatedContainer(
                duration: const Duration(milliseconds: 300),
                height: _isExpanded ? 50 : 0, // Change the height as needed
                child: _isExpanded ? filteringMenu() : const SizedBox.shrink(),
              ),
            ],
          )
        ],
      ),
    );
  }

  Widget savingList()
  {
    return Expanded(
      child: ListView.builder(
        itemCount: NewSavings.savings.length,
        itemBuilder: (context, index)
        {
          // Inverti l'ordine
          final error = NewSavings.savings[NewSavings.savings.length - 1 - index];

          return Padding(
            padding: const EdgeInsets.all(2.0),
            child: CustomErrorListItem(
              item: error,
            ),
          );
        },
      ),
    );
  }

  Widget deleteAllButton()
  {
    return ElevatedButton(
      onPressed: () {
        NewSavings.deleteAll().then((_) {
          setState(() {});
        });
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
    );
  }
}