import 'package:flashcard/calendar_and_recap/pastErrors/model/newObject.dart';
import 'package:flutter/material.dart';
/*
class CustomErrorListItem extends StatelessWidget {
   final IncorrectItem item;

  const CustomErrorListItem(
      {super.key,
        required this.item
      });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(8.0),
      decoration: BoxDecoration(
        border: Border.all(color: Colors.grey),
        borderRadius: BorderRadius.circular(8.0),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [

          Center(
            child: Row(
              children: [
                Column(
                  children: [
                    RichText(
                      text: TextSpan(
                        style: const TextStyle(color: Colors.black),
                        children:
                        [
                          const TextSpan(
                            text: "Date: ",
                            style: TextStyle(fontWeight: FontWeight.bold),
                          ),
                          TextSpan(text: "${item.date};   "),
                        ],
                      ),
                    ),
                  ],
                ),
                Column(
                  children: [
                    RichText(
                      text: TextSpan(
                        style: const TextStyle(color: Colors.black),
                        children:
                        [
                          const TextSpan(
                            text: "Time: ",
                            style: TextStyle(fontWeight: FontWeight.bold),
                          ),
                          TextSpan(text: "${item.time};   "),
                        ],
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),



          Row(
            children: [
              Column(
                children: [
                  RichText(
                  text: TextSpan(
                  style: const TextStyle(color: Colors.black),
                  children:
                  [
                        const TextSpan(
                          text: "Subject: ",
                          style: TextStyle(fontWeight: FontWeight.bold),
                        ),
                        TextSpan(text: "${item.subject};   "),
                      ],
                    ),
                  ),
                ],
              ),
              Column(
                children: [
                  RichText(
                    text: TextSpan(
                      style: const TextStyle(color: Colors.black),
                      children:
                      [
                        const TextSpan(
                          text: "Deck: ",
                          style: TextStyle(fontWeight: FontWeight.bold),
                        ),
                        TextSpan(text: "${item.deck};   "),
                      ],
                    ),
                  ),
                ],
              ),
            ],
          ),
          const SizedBox(height: 8.0),
          const Text(
            "Question:",
            style: TextStyle(fontWeight: FontWeight.bold),
          ),
          Text(" ${item.question}"),
          const SizedBox(height: 8.0),
          const Text(
            "Answer:",
            style: TextStyle(fontWeight: FontWeight.bold),
          ),
          Text(" ${item.answer}"),
        ],
      ),
    );
  }
}*/



class CustomErrorListItem extends StatelessWidget {
  final NewObject item;

  const CustomErrorListItem(
      {super.key,
        required this.item
      });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(8.0),
      decoration: BoxDecoration(
        border: Border.all(color: Colors.grey),
        borderRadius: BorderRadius.circular(8.0),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [

          Center(
            child: Row(
              children: [
                Column(
                  children: [
                    RichText(
                      text: TextSpan(
                        style: const TextStyle(color: Colors.black),
                        children:
                        [
                          const TextSpan(
                            text: "Date: ",
                            style: TextStyle(fontWeight: FontWeight.bold),
                          ),
                          TextSpan(text: "${item.date};   "),
                        ],
                      ),
                    ),
                  ],
                ),
                Column(
                  children: [
                    RichText(
                      text: TextSpan(
                        style: const TextStyle(color: Colors.black),
                        children:
                        [
                          const TextSpan(
                            text: "Time: ",
                            style: TextStyle(fontWeight: FontWeight.bold),
                          ),
                          TextSpan(text: "${item.time};   "),
                        ],
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),



          Row(
            children: [
              Column(
                children: [
                  RichText(
                    text: TextSpan(
                      style: const TextStyle(color: Colors.black),
                      children:
                      [
                        const TextSpan(
                          text: "Subject: ",
                          style: TextStyle(fontWeight: FontWeight.bold),
                        ),
                        TextSpan(text: "${item.subject};   "),
                      ],
                    ),
                  ),
                ],
              ),
              Column(
                children: [
                  RichText(
                    text: TextSpan(
                      style: const TextStyle(color: Colors.black),
                      children:
                      [
                        const TextSpan(
                          text: "Deck: ",
                          style: TextStyle(fontWeight: FontWeight.bold),
                        ),
                        TextSpan(text: "${item.deck};   "),
                      ],
                    ),
                  ),
                ],
              ),
            ],
          ),
          const SizedBox(height: 8.0),

          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              for (int i = 0; i < item.wrongQuestions.length; i++)
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text("Question: ${item.wrongQuestions[i]}"),
                    Text("Answer: ${item.wrongAnswers[i]}"),
                    const SizedBox(height: 8.0),
                  ],
                ),
            ],
          ),

        ],
      ),
    );
  }
}