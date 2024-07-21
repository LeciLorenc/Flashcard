import 'package:flashcard/calendar_and_recap/historyErrorList/CustomErrorListItem.dart';
import 'package:flashcard/calendar_and_recap/historyErrorList/view/orderMenuWidget.dart';
import 'package:flashcard/calendar_and_recap/pastErrors/model/newObject.dart';
import 'package:flashcard/calendar_and_recap/pastErrors/storage/NewSavings.dart';
import 'package:flashcard/calendar_and_recap/pastErrors/storage/utilitiesStorage.dart';
import 'package:flashcard/constants.dart';
import 'package:flashcard/layoutUtils.dart';
import 'package:flashcard/main.dart';
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
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                FilterButtonWidget(),
                const SizedBox(height: 8),
                orderButton(),
                const SizedBox(height: 16),
                savingList(),

              ],
            ),
          ),
        );
      },
    );
  }


  Widget FilterButtonWidget()
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
        backgroundColor: isDark ?  darkSecondaryColor : lightSecondaryColor,
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

                height: setHeightFilter(context),
                width: setWidthFilter(context),

                child: _isFilterExpanded ?
                SingleChildScrollView(
                  scrollDirection: Axis.horizontal,
                    child: SingleChildScrollView(
                      scrollDirection: Axis.vertical,
                        child: filteringMenu())) : const SizedBox.shrink(),
              ),
            ],
          )
        ],
      ),
    );
  }






  Widget filteringMenu() {
    if (NewSavings.savings.isEmpty) {
      return Center(
        child: SizedBox(
          width: LayoutUtils.getWidth(context)<400? 330: LayoutUtils.getWidth(context)<800 ? 460: 650,
          height: 50,
          child: Row(mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Column(
                children: [
                  Text("No filters available"),
                ],
              ),
            ],
          ),
        ),
      );
    } else {
      //landscape tab
      if (MediaQuery.of(context).size.width > 700) {
        return SingleChildScrollView(
          scrollDirection: Axis.horizontal,
          child: Row(
            children: [
              // Filtraggio per subject
              filterSubject(),
              // Filtraggio per deck
              filterDeck(),
              if(LayoutUtils.getWidth(context)>800)
                SizedBox(width: 10,),
              // Filtraggio per data
              filterDate(),
              removeFilter(),
            ],
          ),
        );
      } else
      //phone portrait
      {
        return Column(
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            // Filtraggio per subject
            Row(
              children: [
                Column(
                  children: [
                    filterSubject(),
                    filterDeck(),
                  ],
                ),
                // Filtraggio per data
                Column(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    filterDate(),
                    removeFilter(),
                  ],
                ),
              ],
            ),
          ],
        );
      }
    }
  }



  Widget filterSubject()
  {
    return SizedBox(
      width: LayoutUtils.isLandscape(context) && LayoutUtils.getWidth(context)>800 ? 130 :115,
      child: DropdownButton<String>(
        hint: Text('Select Subject', style: TextStyle(color: isDark ? darkTextColor : lightTextColor),),
        onChanged: (String? newValue) {
          setState(() {
            widget.viewModel.updateSubjectFilter(newValue!);
          });
        },
        value: widget.viewModel.subjectFilter!='' ? widget.viewModel.subjectFilter: null,
        style: TextStyle(color: isDark ? darkTextColor : lightTextColor),
        dropdownColor: isDark ? darkSecondaryColor : lightSecondaryColor,
        items: computeItemsForSubject(context),
      ),
    );
  }
  Widget filterDeck()
  {
    return SizedBox(
      width: LayoutUtils.isLandscape(context) && LayoutUtils.getWidth(context)>800 ? 130 :110,
      child: DropdownButton<String>(
        hint:  Text('Select Deck' ,style: TextStyle(color: isDark ? darkTextColor : lightTextColor),),
        onChanged: (String? newValue) {
          setState(() {
            widget.viewModel.updateDeckFilter(newValue!);
          });
        },
        value: widget.viewModel.deckFilter!='' ? widget.viewModel.deckFilter: null,

        style: TextStyle(color: isDark ? darkTextColor : lightTextColor),
        dropdownColor: isDark ? darkSecondaryColor : lightSecondaryColor,
        items: computeItemsForDeck(context),
      ),
    );
  }

  Widget filterDate() {
    return SizedBox(

      width: getWidthDate(),

      child: Row(
        children: [
          const SizedBox(width: 3,),
          ElevatedButton(
            onPressed: () async {
              final DateTime? picked = await showDatePicker(
                context: context,
                initialDate: DateTime.now(),
                firstDate: DateTime(2015, 8),
                lastDate: DateTime(2101),
                builder: (BuildContext context, Widget? child) {
                  final isDark = Theme.of(context).brightness == Brightness.dark;
                  return Theme(
                    data: Theme.of(context).copyWith(
                      colorScheme: isDark
                          ? const ColorScheme.dark(
                        primary: primaryColor,
                        onPrimary: darkTextColor,
                        surface: lightTextColor,
                        onSurface: darkTextColor,
                      )
                          : const ColorScheme.light(
                        primary: primaryColor,
                        onPrimary: lightTextColor,
                        surface: darkTextColor,
                        onSurface: lightTextColor,
                      ),
                      dialogBackgroundColor: isDark ? Colors.black : Colors.white,
                      textTheme: TextTheme(
                        bodyLarge: TextStyle(color: isDark ? Colors.white : Colors.black),
                        bodyMedium: TextStyle(color: isDark ? Colors.white : Colors.black),
                      ),
                    ),
                    child: child!,
                  );
                },
              );
              if (picked != null) {
                setState(() {
                  widget.viewModel.updateDateFilter(UtilitiesStorage.getOnlyDateFromSelectedDate(picked));
                });
              }
            },
            child: Row(
              children: [
                const Icon(Icons.calendar_today),
                if(LayoutUtils.getWidth(context)>800)
                  const SizedBox(width: 10,),
                if(LayoutUtils.getWidth(context)>800)
                  const Text("Filter Date"),
                if(LayoutUtils.getWidth(context)<800 && LayoutUtils.getWidth(context)>720)
                  const Text("Filter\nDate"),
                if(LayoutUtils.getWidth(context)<400)
                  const Text("Filter\nDate"),

              ],
            ),
          ),
        ],
      ),
    );
  }


  Widget removeFilter()
  {
    return SizedBox(
      width: getWidthRemoveFilters() ,


      child: Row(
        children: [
          LayoutUtils.getWidth(context) >400 ? (LayoutUtils.getWidth(context) >800 ?const SizedBox(width: 10):  const SizedBox(width: 0)):const SizedBox(width: 10,),
          ElevatedButton(
            onPressed: () {
              setState(() {
                widget.viewModel.removeAllFilters();
              });
            },
            child: Row(
              children: [
                const Icon(Icons.highlight_remove),
                if(LayoutUtils.getWidth(context)>800 && LayoutUtils.getWidth(context)<400)
                  const SizedBox(width: 10,),
                if(LayoutUtils.getWidth(context)>800)
                  const Text("Remove Filters"),
                if(LayoutUtils.getWidth(context)<800 // && LayoutUtils.getWidth(context)>720)
                )const Text("Remove \n Filters"),
              ],
            ),
          ),
        ],
      ),
    );
  }

  double getWidthRemoveFilters()
  {
    if(LayoutUtils.getWidth(context)<400)
    {
      return 140;
    }
    else if (LayoutUtils.getWidth(context)>800 ){
      return 300;
    }
    else{
      return 130;
    }
  }

  double getWidthDate()
  {
    if(LayoutUtils.getWidth(context)<400)
    {
      return 110;
    }
    else if (LayoutUtils.getWidth(context)>800 ){
      return 160;
    }
    else{
      return 120;
    }
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
        backgroundColor: isDark ?  darkSecondaryColor : lightSecondaryColor,
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
                height: calculateHeightOrder(),
                width: calculateWidthOrder(),
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

  double calculateHeightOrder()
  {
    if (_isOrderExpanded) {
      if (LayoutUtils.getWidth(context)<400) {
        return 300;
      } else if(LayoutUtils.getWidth(context)<800
      && LayoutUtils.getWidth(context)>400){
        return 160;
      }
      else{
        return 100;
      }
    }
    else {
      return 0;
    }
  }

  double calculateWidthOrder()
  {
    if(MediaQuery.of(context).size.width>400 &&
        MediaQuery.of(context).size.width<800 && LayoutUtils.isLandscape(context)){
      return 400;
    }
    else if(LayoutUtils.getWidth(context) > 800){
      return 645;
    }
    else if(MediaQuery.of(context).size.width<400){
      return 200;
    }
    return LayoutUtils.isPortrait(context) ? 600: 200;
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
      child: Column(
        children: [
          Expanded(
            child: buildList(results, results.length),
          ),
        ],
      ),
    );
  }


  Widget buildList(List list, int length) {
    return ListView.builder(
      itemCount: length + 1, // Incrementa length di uno per includere il bottone
      itemBuilder: (context, index) {
        if (index == 0) {
          // Ritorna il bottone quando si raggiunge l'ultimo indice
          return Padding(
            padding: const EdgeInsets.all(2.0),
            child: deleteAllRecordsButton(context),
          );
        } else {
          // Inverti l'ordine
          final error = list[length - 1 - index+1];

          return Padding(
            padding: const EdgeInsets.all(2.0),
            child: CustomErrorListItem(
              item: error,
            ),
          );
        }
      },
    );
  }

  Widget deleteAllRecordsButton(BuildContext context) {
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
  double? setHeightFilter(BuildContext context){
    if(_isFilterExpanded)
    {
      if(LayoutUtils.getWidth(context) > 720) //landscape tablet
      {
        return 50;
      }
      else {
        return 100;
      }
    }
    return 0;
  }
  double? setWidthFilter(BuildContext context){
    if(_isFilterExpanded)
    {
      if(LayoutUtils.getWidth(context) > 800) //landscape tablet
          {
        return 620;
      }
      //land phone
      else if(LayoutUtils.getWidth(context) > 720){
        return 475;
      }
      else {
        return 320;
      }
    }
    return 0;
  }
}