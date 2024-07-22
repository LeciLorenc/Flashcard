
import 'package:flashcard/calendar_and_recap/playWithErrors/pastErrorViewModel.dart';
import 'package:flashcard/constants.dart';
import 'package:flutter/material.dart';

import '../../pages/play_page/play_page.dart';
import '../historyErrorList/view/orderMenuWidget.dart';

class DeckChoice extends StatefulWidget {
  final OrderingCallback orderingCallback;
  final PastErrorsViewModel pastErrorsViewModel;

  List<String> possibleDecks = [];

  DeckChoice({super.key, required this.orderingCallback, required this.pastErrorsViewModel});

  @override
  _DeckChoice createState() => _DeckChoice();
}

class _DeckChoice extends State<DeckChoice> {

  @override
  Widget build(BuildContext context) {
    widget.possibleDecks = widget.pastErrorsViewModel.getDecks();

    return Container(
      decoration: const BoxDecoration(

      ),
      width: MediaQuery.of(context).size.width - 16,
      height: MediaQuery.of(context).size.height - 16 - 56 - 34,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          const SizedBox(height: 6),
          const Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text("Which deck would you like to play again?",
                textAlign: TextAlign.center,
                style: TextStyle(fontSize: 20),),
            ],
          ),
          const SizedBox(height: 3),
          buildCheckBox(),
          const SizedBox(height: 10),
          buildListViewOfDeck(),
          //const SizedBox(height: 15),
          const Spacer(),
          buildGoBackButton(),
        ],
      ),
    );

  }

  Widget buildButton(String label, String ordering) {
    return ElevatedButton(
      onPressed: () {
        widget.orderingCallback(ordering);
        widget.pastErrorsViewModel.createAllStuff();

        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (BuildContext context) => PlayPage(
              subject: widget.pastErrorsViewModel.subject,
              deck: widget.pastErrorsViewModel.deck,
            ),
          ),
        );

      },
      child: Row(
        children: [
          Text(label),
        ],
      ),
    );
  }


  Widget buildCheckBox()
  {
    return Row(
      children: [

        Checkbox(
          checkColor: primaryColor,
          fillColor: MaterialStateProperty.all(backgroundButtonColorLight),
          value: widget.pastErrorsViewModel.notOnly5Flashcards,
          onChanged: (bool? value) {
            setState(() {
              widget.pastErrorsViewModel.notOnly5Flashcards= value!;
            });
          },
        ),
        const Text("Replay ALL the wrong flashcards \nof the deck selected"),
      ],
    );
  }
  Widget buildListViewOfDeck()
  {
    return Expanded(
      child: SingleChildScrollView(
        child: Column(
          children: [
            ListView.builder(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              itemCount: widget.possibleDecks.length,
              itemBuilder: (context, index) {
                return Padding(
                  padding: const EdgeInsets.all(2.0),
                  child: ConstrainedBox(
                    constraints: const BoxConstraints(maxWidth: 100),
                    child: ElevatedButton(
                      /*style: ButtonStyle(
                        backgroundColor: MaterialStateProperty.all<Color>(isDark? backgroundButtonColorDark: backgroundButtonColorLight),
                      ),*/
                      onPressed: ()
                      {
                        widget.orderingCallback(widget.possibleDecks[index]);
                        widget.pastErrorsViewModel.createAllStuff();

                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (BuildContext context) => PlayPage(
                              subject: widget.pastErrorsViewModel.subject,
                              deck: widget.pastErrorsViewModel.deck,
                            ),
                          ),
                        );
                      },
                      child: Text(widget.possibleDecks[index], style: TextStyle(color: primaryColor),),
                    ),
                  ),
                );
              },
            ),
          ],
        ),
      ),
    );
  }

  Widget buildGoBackButton() {
    return ListTile(
      leading: const Icon(Icons.arrow_back),
      title: const Text('Go back'),
      onTap: () => widget.orderingCallback(''),
    );
  }
}
