
import 'package:flashcard/calendar_and_recap/playWithErrors/pastErrorViewModel.dart';
import 'package:flutter/material.dart';

import '../../pages/play_page/play_page.dart';
import '../historyErrorList/view/orderMenuWidget.dart';


class SubjectChoice extends StatefulWidget {
  final OrderingCallback orderingCallback;
  final PastErrorsViewModel pastErrorsViewModel;

  List<String> possibleSubjects = [];

  SubjectChoice({super.key, required this.orderingCallback, required this.pastErrorsViewModel});

  @override
  _SubjectChoice createState() => _SubjectChoice();
}

class _SubjectChoice extends State<SubjectChoice> {
  @override
  Widget build(BuildContext context) {
    widget.possibleSubjects = widget.pastErrorsViewModel.getSubjects();

    return Container(
      decoration: BoxDecoration(
        border: Border.all(
          color: Colors.blue, // Set the border color to blue
          width: 1, // Set the border width
        ),
      ),
      width: MediaQuery.of(context).size.width - 16,
      height: MediaQuery.of(context).size.height - 16 - 56,
      child: Column(
        children: [
          Expanded(
            child: SingleChildScrollView(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  const Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text("Which subject would you like to review again?"),
                      SizedBox(height: 6),
                    ],
                  ),
                  buildCheckBox(),
                  const SizedBox(height: 15),
                  SizedBox(
                    width: 200,
                    child: Column(
                      children: [
                        Row(
                          children: [
                            buildListViewOfSubjects(),
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

  Widget buildGoBackButton() {
    return ListTile(
      leading: const Icon(Icons.arrow_back),
      title: const Text('Go back'),
      onTap: () => widget.orderingCallback(''),
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
              widget.pastErrorsViewModel.notOnly5Flashcards = value!;
            });
          },
        ),
        const Text("Replay ALL wrong flashcards"),
      ],
    );
  }

  Widget buildListViewOfSubjects()
  {
    return Expanded(
      child: ListView.builder(
        shrinkWrap: true,
        physics: const NeverScrollableScrollPhysics(),
        itemCount: widget.possibleSubjects.length,
        itemBuilder: (context, index) {
          return Padding(
            padding: const EdgeInsets.all(4.0),
            child: ElevatedButton(
              onPressed: () {
                widget.orderingCallback(widget.possibleSubjects[index]);
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
              child: Text(widget.possibleSubjects[index]),
            ),
          );
        },
      ),
    );
  }
}


/*class SubjectChoice extends StatefulWidget {
  final OrderingCallback orderingCallback;

  const SubjectChoice({Key? key, required this.orderingCallback}) : super(key: key);

  @override
  _SubjectChoice createState() => _SubjectChoice();
}

class _SubjectChoice extends State<SubjectChoice> {
  String? choice = '';

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.start,
      children: [
        const Text("What you would like to review again?"),
        buildButton("Choose Sub1", 'Sub1 sdcleta'),
        const SizedBox(height: 6),
        buildButton("Choose Sub2", 'Sub2 scelat'),
        const SizedBox(height: 6),
        buildGoBackButton(),
      ],
    );
  }

  Widget buildButton(String label, String ordering) {

    const Color customLightPink = Color.fromRGBO(255, 220, 220, 1.0);


    return ElevatedButton(
      onPressed: () {
        setState(() {
          choice = ordering;
        });
        widget.orderingCallback(ordering);
      },
      style: ButtonStyle(
        backgroundColor: MaterialStateProperty.resolveWith<Color>((states) {
          if (choice == ordering) {
            return customLightPink; // Change to light blue when selected
          } else {
            return Colors.white; // Change to white when not selected
          }
        }),
      ),
      child: Row(
        children: [
          Text(label),
        ],
      ),
    );
  }


  Widget buildGoBackButton() {
    return ElevatedButton(
      onPressed: () {
        setState(() {
          choice = '';
        });
        widget.orderingCallback('');
      },
      child: const Text("Go back"),
    );
  }
}*/
