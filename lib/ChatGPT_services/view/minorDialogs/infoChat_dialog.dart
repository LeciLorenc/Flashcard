import 'package:flashcard/constants.dart';
import 'package:flutter/material.dart';

class InfoDialog extends StatelessWidget
{
  final String message;

  const InfoDialog({super.key, required this.message});

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      content: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          const SizedBox(height: 16),
          Text(message, style: const TextStyle(color: primaryColor),),
          const SizedBox(height: 16),
        ],
      ),
    );
  }
}
