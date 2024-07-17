import 'package:flashcard/calendar_and_recap/historyErrorList/CustomErrorListItem.dart';
import 'package:flashcard/calendar_and_recap/historyErrorList/view/orderMenuWidget.dart';
import 'package:flashcard/calendar_and_recap/pastErrors/model/newObject.dart';
import 'package:flashcard/calendar_and_recap/pastErrors/storage/NewSavings.dart';
import 'package:flashcard/calendar_and_recap/pastErrors/storage/utilitiesStorage.dart';
import 'package:flashcard/constants.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';

import 'historyErrorViewModel.dart';
import 'historyFitering.dart';


class HistoryError extends StatefulWidget {
  final HistoryErrorViewModel viewModel;
  const HistoryError({Key? key, required this.viewModel}) : super(key: key);

  @override
  _HistoryErrorState createState() => _HistoryErrorState();
}

class _HistoryErrorState extends State<HistoryError> {
  bool _isFilterExpanded = false;
  bool _isOrderExpanded = false;


  @override
  Widget build(BuildContext context) {

    return StatefulBuilder(
      builder: (context, setState) {
        return Theme(
          data: Theme.of(context).copyWith(
            colorScheme: const ColorScheme.light(
              primary: primaryColor, // Set the color for the selected date
            ),
          ),
          child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  FilterButton(),
                  const SizedBox(height: 8),
                  orderButton(),
                  const SizedBox(height: 16),
                  savingList(),
                  deleteAllButton(context),
                ],
              ),
            ),
          ),
        );
      },
    );
  }


  Widget FilterButton()
  {
    return ElevatedButton(
      onPressed: () {
        setState(() {
          _isFilterExpanded = !_isFilterExpanded;
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
              Text(_isFilterExpanded ? "Hide Filters" : "Filters"),
            ],
          ),
          Row(
            children : [
              AnimatedContainer(
                duration: const Duration(milliseconds: 300),
                height: _isFilterExpanded ? (MediaQuery.of(context).size.width > 720 ? 50: 200) : 0, // Change the height as needed
                child: _isFilterExpanded ?
                SingleChildScrollView(
                    child: filteringMenu()) : const SizedBox.shrink(),
              ),
            ],
          )
        ],
      ),
    );
  }




  Widget filteringMenu() {
    if(NewSavings.savings.isEmpty)
    {
      return const Center(
        child: Text("No filters available"),
      );
    }
    else {
      if(MediaQuery.of(context).size.width > 620) {
        return Row(
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            // Filtraggio per subject
            filterSubject(),
            // Filtraggio per deck
            filterDeck(),
            // Filtraggio per data
            filterDate(),
            removeFilter(),
          ],
        );
      }
      else
      {
        return Column(
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            // Filtraggio per subject
            filterSubject(),
            // Filtraggio per deck
            filterDeck(),
            // Filtraggio per data
            filterDate(),
            removeFilter(),
          ],
        );
      }
    }
  }
  Widget filterSubject()
  {
    return SizedBox(
      width: 140,
      child: DropdownButton<String>(
        hint: const Text('Select Subject'),
        onChanged: (String? newValue) {
          setState(() {
            widget.viewModel.updateSubjectFilter(newValue!);
          });
        },
        value: widget.viewModel.subjectFilter!='' ? widget.viewModel.subjectFilter: null,
        items: computeItemsForSubject(context),
      ),
    );
  }
  Widget filterDeck()
  {
    return SizedBox(
      width: 140,
      child: DropdownButton<String>(
        hint: const Text('Select Deck'),
        onChanged: (String? newValue) {
          setState(() {
            widget.viewModel.updateDeckFilter(newValue!);
          });
        },
        value: widget.viewModel.deckFilter!='' ? widget.viewModel.deckFilter: null,
        items: computeItemsForDeck(context),
      ),
    );
  }
  Widget filterDate()
  {
    return SizedBox(
      width: 140,
      child: ElevatedButton(
        onPressed: () async {
          final DateTime? picked = await showDatePicker(
            context: context,
            initialDate: DateTime.now(),
            firstDate: DateTime(2015, 8),
            lastDate: DateTime(2101),
          );
          if (picked != null) {
            setState(() {
              widget.viewModel.updateDateFilter( UtilitiesStorage.getOnlyDateFromSelectedDate(picked) );
            });
          }
        },
        child: const Row(
          children: [
            Icon(Icons.calendar_today),
            Text("Filter Date"),
          ],
        ),
      ),
    );
  }

  Widget removeFilter()
  {
    return SizedBox(
      width: 200,
      child: Row(
        children: [
          const SizedBox(width: 27),
          ElevatedButton(
            onPressed: () {
              setState(() {
                widget.viewModel.removeAllFilters();
              });
            },
            child: const Row(
              children: [
                Icon(Icons.highlight_remove),
                Text("Remove Filters"),
              ],
            ),
          ),
        ],
      ),
    );
  }










  Widget orderButton() {
    return ElevatedButton(
      onPressed: () {
        setState(() {
          _isOrderExpanded = !_isOrderExpanded;
        });
      },
      style: ElevatedButton.styleFrom(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(20),
        ),
      ),
      child: Column(
        children: [
          Row(
            children: [
              const Icon(Icons.filter_alt),
              Text(_isOrderExpanded ? "Hide Order" : "Order"),
            ],
          ),
          Row(
            children: [
              AnimatedContainer(
                duration: const Duration(milliseconds: 300),
                height: _isOrderExpanded ? 320 : 0,
                width: 200,
                child: _isOrderExpanded
                    ? ListView(
                  physics: NeverScrollableScrollPhysics(), // Disable scrolling
                  children: [OrderMenu(orderingCallback: updateOrdering)],
                )
                    : const SizedBox.shrink(),
              ),
            ],
          )
        ],
      ),
    );
  }


  void updateOrdering(String newOrdering) {
    setState(() {
      widget.viewModel.orderingVariable = newOrdering;
    });
  }


  Widget savingList()
  {
    List<pastErrorsObject> results = widget.viewModel.getFilteredSavings(NewSavings.savings);
    results = widget.viewModel.getOrderedSavings(results);

    //TODO here i'm still considering all the items each time -> todo maintain a state of the one already filtered
    return Expanded(
        child: buildList(results, results.length)
    );
  }


  Widget buildList(List list, int length)
  {
    return ListView.builder(
      itemCount: length,
      itemBuilder: (context, index)
      {
        // Inverti l'ordine
        final error = list[length - 1 - index];

        return Padding(
          padding: const EdgeInsets.all(2.0),
          child: CustomErrorListItem(
            item: error,
          ),
        );
      },
    );
  }

  Widget deleteAllButton(BuildContext context) {
    return ElevatedButton(
      onPressed: () {
        showDialog(
          context: context,
          builder: (BuildContext context) {
            return AlertDialog(
              title: const Text("Delete All Records"),
              content: const Text("Are you sure you want to delete all records?"),
              actions: <Widget>[
                TextButton(
                  onPressed: () {
                    Navigator.of(context).pop(); // Close the dialog
                  },
                  child: const Text("Cancel"),
                ),
                TextButton(
                  onPressed: () {
                    // Delete all records
                    NewSavings.deleteAll().then((_) {
                      setState(() {});
                      Navigator.of(context).pop(); // Close the dialog after deletion
                    });
                  },
                  child: const Text("Delete"),
                ),
              ],
            );
          },
        );
      },
      child: const SizedBox(
        width: 170,
        child: Center(
          child: Row(
            children: [
              Icon(Icons.delete),
              SizedBox(width: 8),
              Text("Delete all the records"),
            ],
          ),
        ),
      ),
    );
  }

}







/*
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
                height: _isExpanded ? 50 : 0,
                width: MediaQuery.of(context).size.width*0.85,
                child: _isExpanded ? filteringMenu() : const SizedBox.shrink(),
              ),
            ],
          )
        ],
      ),
    );
  }*/
/*
  Widget filteringMenu() {
    return LayoutBuilder(
      builder: (context, constraints) {
        const buttonWidth = 100.0; // Width of each button
        final availableWidth = constraints.maxWidth;
        final maxButtonsPerRow = (availableWidth / buttonWidth).floor();

        if (maxButtonsPerRow >= 4) {
          return _buildButtonsRow(4);
        } else if (maxButtonsPerRow >= 2) {
          return _buildButtonsRow(2);
        } else {
          return _buildButtonsRow(1);
        }
      },
    );
  }

  Widget _buildButtonsRow(int buttonsCount) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: List.generate(buttonsCount, (index) {
        switch (index) {
          case 0:
            return Expanded(
              child: DropdownButton<String>(
                hint: const Text('Select Subject'),
                onChanged: (String? newValue) {
                  widget.viewModel.updateSubjectFilter(newValue!);
                },
                items: computeItemsForDeck(context),
              ),
            );
          case 1:
            return Expanded(
              child: DropdownButton<String>(
                hint: const Text('Select Deck'),
                onChanged: (String? newValue) {
                  widget.viewModel.updateDeckFilter(newValue!);
                },
                items: computeItemsForSubjects(context),
              ),
            );
          case 2:
            return Expanded(
              child: ElevatedButton(
                onPressed: () {
                  // Implement your logic here
                },
                child: const Row(
                  children: [
                    Icon(Icons.calendar_today),
                    Text("Filter by Date"),
                  ],
                ),
              ),
            );
          case 3:
            return Expanded(
              child: ElevatedButton(
                onPressed: () {
                  setState(() {
                    widget.viewModel.getFilteredSavings(NewSavings.savings);
                  });
                },
                child: const Row(
                  children: [
                    Icon(Icons.search),
                    Text("Search"),
                  ],
                ),
              ),
            );
          default:
            return const SizedBox.shrink();
        }
      }),
    );
  }*/

//SEARCH BUTTON
/*ElevatedButton(
        onPressed: () {
          setState(() {
            widget.viewModel.getFilteredSavings(NewSavings.savings);
            });
          },
          child: const Row(
            children: [
              Icon(Icons.search),
              Text("Search"),
            ],
          ),
        ),*/


