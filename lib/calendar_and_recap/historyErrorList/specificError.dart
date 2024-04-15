import 'package:flutter/material.dart';

import '../playErrors/model/incorrectItem.dart';
import '../playErrors/model/playedItems.dart';
import '../playErrors/view/customListItem.dart';
import 'CustomErrorListItem.dart';

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
