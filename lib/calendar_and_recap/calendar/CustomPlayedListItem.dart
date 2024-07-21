
import 'package:flashcard/calendar_and_recap/calendar/specificError.dart';
import 'package:flashcard/calendar_and_recap/pastErrors/model/newObject.dart';
import 'package:flutter/material.dart';




class CustomPlayedListItem extends StatelessWidget {
  final PastErrorsObject item;

  const CustomPlayedListItem(
      {super.key,
        required this.item
      });


  int calculatePoints(){
    int itemLength = int.parse(item.numberOfTotalFlashcards);
    int numberOfErrorsLength = item.wrongAnswers.length;

    return itemLength - numberOfErrorsLength;
  }

  isTheButtonVisible() {
    int nTot = int.parse(item.numberOfTotalFlashcards);
    return calculatePoints()!=nTot;
  }




  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(8.0),
      decoration: BoxDecoration(
        border: Border.all(color: Colors.grey),
        borderRadius: BorderRadius.circular(8.0),
      ),
      child: Row(
        children: [
          Expanded(
            flex: 1,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text("Subject: ", style: TextStyle(fontWeight: FontWeight.bold),),
                Text("${item.subject}   "),
              ],
            ),
          ),
          Expanded(
            flex: 1,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text("Deck: ", style: TextStyle(fontWeight: FontWeight.bold),),
                Text("${item.deck}   "),
              ],
            ),
          ),
          Expanded(
            flex: 1,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text("Score: ", style: TextStyle(fontWeight: FontWeight.bold),),
                Text("${calculatePoints().toString()}/${item.numberOfTotalFlashcards}   "),
              ],
            ),
          ),
          SizedBox(
            width: 90,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Visibility(
                  visible: isTheButtonVisible(),
                  child: ElevatedButton(
                    onPressed: () {
                      Navigator.push
                        (
                        context, MaterialPageRoute(
                        //builder: (context) => SpecificErrorWidget(numberOfErrors: numberOfErrors, item:item),),
                        builder: (context) => SpecificErrorWidget(item:item),
                      ),
                      );
                    },
                    child: const Center(child: Text('See errors')),),
                )
              ],
            ),
          ),
        ],
      ),

    );
  }

}
