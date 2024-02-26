import 'package:flutter/material.dart';
import 'package:flutter_markdown/flutter_markdown.dart';

class CardTextField extends StatelessWidget {
  const CardTextField.answer({
    super.key,
    required this.controller,
    required this.readOnly,
  })  : title = 'Answer';

  const CardTextField.question({
    super.key,
    required this.controller,
    required this.readOnly,
  })  : title = 'Question';

  final String title;
  final TextEditingController controller;
  final bool readOnly;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          title[0],
          style: const TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.bold,
          ),
        ),
        const SizedBox(height: 16),
        if (readOnly)
          MarkdownBody(
            data: controller.text,
            selectable: true,
          ),
        if (!readOnly)
        TextField(
          readOnly: readOnly,
          decoration: InputDecoration.collapsed(
            hintText: title,
          ),
          controller: controller,
          keyboardType: TextInputType.multiline,
          maxLines: null,
        ),
      ],
    );
  }
}
