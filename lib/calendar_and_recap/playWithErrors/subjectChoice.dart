
import 'package:flashcard/calendar_and_recap/playWithErrors/pastErrorViewModel.dart';
import 'package:flutter/material.dart';

import '../../constants.dart';
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
      decoration: const BoxDecoration(

      ),
      width: MediaQuery.of(context).size.width - 16,
      height: MediaQuery.of(context).size.height - 16 - 56 - 34-51,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          const SizedBox(height: 6),
          const Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text("Which subject would you like to review again?"),
            ],
          ),
          const SizedBox(height: 6),
          buildCheckBox(),
          const SizedBox(height: 15),
          buildListViewOfSubjects(),
          const SizedBox(height: 15),
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
      child: SingleChildScrollView(
        child: Column(
          children: [
            ListView.builder(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              itemCount: widget.possibleSubjects.length,
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
                      child: Text(widget.possibleSubjects[index], style: TextStyle(color: primaryColor),),
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
}
