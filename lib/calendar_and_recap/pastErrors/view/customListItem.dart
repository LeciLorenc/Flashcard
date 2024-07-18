
import 'package:flutter/material.dart';

class CustomListItemInErrorDialog extends StatelessWidget {
  final String question;
  final String answer;

  const CustomListItemInErrorDialog({super.key, required this.question, required this.answer});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(2.0),
      decoration: BoxDecoration(
        border: Border.all(color: Colors.grey),
        borderRadius: BorderRadius.circular(8.0),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            "Question: $question",
            style: const TextStyle(fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 8.0),
          Text("Answer: $answer"),
        ],
      ),
    );
  }
}