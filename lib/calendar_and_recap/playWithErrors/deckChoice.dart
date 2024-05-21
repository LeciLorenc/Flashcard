
import 'package:flashcard/calendar_and_recap/playWithErrors/pastErrorViewModel.dart';
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
      decoration: BoxDecoration(
        border: Border.all(
          color: Colors.blue, // Set the border color to blue
          width: 1, // Set the border width
        ),
      ),
      width: MediaQuery.of(context).size.width-16,
      height:  MediaQuery.of(context).size.height-16-56,
      child: Column(
        children: [
          Expanded(
            child: SingleChildScrollView(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.start,
                children:
                [
                  const Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text("Which deck would you like to review again?"),
                      SizedBox(height: 6),
                    ],
                  ),
                  buildCheckBox(),
                  const SizedBox(height: 15),
                  SizedBox(
                    width: 150,
                    child: Column(
                      children: [
                        Row(
                          children: [
                            buildListViewOfDeck(),
                          ],
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 15),
                ],
              ),
            ),
          ),
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
          value: widget.pastErrorsViewModel.notOnly5Flashcards,
          onChanged: (bool? value) {
            setState(() {
              widget.pastErrorsViewModel.notOnly5Flashcards= value!;
            });
          },
        ),
        const Text("Replay ALL wrong flashcards"),
      ],
    );
  }
  Widget buildListViewOfDeck()
  {
    return Expanded(
      child: ListView.builder(
        shrinkWrap: true,
        physics: const NeverScrollableScrollPhysics(),
        itemCount: widget.possibleDecks.length,
        itemBuilder: (context, index) {
          return Padding(
            padding: const EdgeInsets.all(2.0),
            child: ConstrainedBox(
              constraints: const BoxConstraints(maxWidth: 100),
              child: ElevatedButton(
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
                child: Text(widget.possibleDecks[index]),
              ),
            ),
          );
        },
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
