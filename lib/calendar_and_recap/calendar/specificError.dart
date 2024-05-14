import 'package:flashcard/calendar_and_recap/playErrors/model/newObject.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import '../---TO_BE_DISCARDED---/incorrectItem.dart';
import '../---TO_BE_DISCARDED---/playedItems.dart';
import '../playErrors/view/customListItem.dart';

/*

class SpecificErrorWidget extends StatelessWidget {
  final List<IncorrectItem> numberOfErrors;
  final PlayedDeck item;

  const SpecificErrorWidget({Key? key, required this.numberOfErrors, required this.item}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Your Details about the: ${item.subject}'),
      ),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text("Subject : ${item.subject}"),
          Text("Deck : ${item.deck}"),
          const Text("Questi sono gli errori :"),
          SizedBox(
            height: numberOfErrors.length*90,
            child: ListView.builder(
              itemCount: numberOfErrors.length,
              itemBuilder: (context, index) {
                final error = numberOfErrors[index];
                return Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: CustomListItemInErrorDialog(
                    question: error.question,
                    answer: error.answer,
                  ),
                );
              },
            ),
          ),
          Center(
            child: ElevatedButton(
              onPressed: () {
                Navigator.pop(context);
              },
              child: const Text("Go Back"),
            ),
          ),
        ],
      ),
    );
  }
}
*/


class SpecificErrorWidget extends StatelessWidget {
 final NewObject item;

  const SpecificErrorWidget({Key? key, required this.item}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Details about the errors'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            rowSubject(),
            rowDeck(),
            const SizedBox(height: 10,),
            const Text("Those are all the errors made :"),
            SizedBox(
              height: item.wrongAnswers.length*90,
              child: ListView.builder(
                itemCount: item.wrongAnswers.length,
                itemBuilder: (context, index)
                {
                  return Padding(
                    padding: const EdgeInsets.all(2.0),
                    child: CustomListItemInErrorDialog(
                      question: item.wrongQuestions[index],
                      answer: item.wrongAnswers[index],
                    ),
                  );
                },
              ),
            ),
            goBackButton(context),
          ],
        ),
      ),
    );
  }

  Widget rowSubject()
  {
    return Row(
      children: [
        const Column(
          children: [
            Text("Subject: "),
          ],
        ),
        Expanded(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(item.subject),
            ],
          ),
        ),
      ],
    );
  }

  Widget rowDeck()
  {
    return Row(
      children: [
        const Column(
          children: [
            Text("Deck: "),
          ],
        ),
        Expanded(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(item.deck),
            ],
          ),
        ),
      ],
    );
  }

  Widget goBackButton(BuildContext context)
  {
    return Center(
      child: ElevatedButton(
        onPressed: () {
          Navigator.pop(context);
        },
        child: const Text("Go Back"),
      ),
    );
  }
}
