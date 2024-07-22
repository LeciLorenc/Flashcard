import 'package:flashcard/constants.dart';
import 'package:flashcard/input/text_input.dart';
import 'package:flutter/material.dart';

class TextInputButton extends StatelessWidget {
  const TextInputButton({
    super.key,
    required this.textEditingController,
    required this.onTap,
    required this.hintText,
    this.textIcon,
    this.errorText,
    required this.iconButton,
    this.textInputType,
    this.maxLines,
  });

  final TextEditingController textEditingController;
  final Function() onTap;
  final String hintText;
  final IconData? textIcon;
  final String? errorText;
  final IconData iconButton;
  final TextInputType? textInputType;
  final int? maxLines;

  @override
  Widget build(BuildContext context) {
    final isDarkMode = Theme.of(context).brightness == Brightness.dark;
    final iconColor = isDarkMode ? Colors.white : primaryColor;

    return Row(
      children: [
        Expanded(
          child: TextInput(
            maxLines: maxLines,
            textInputType: textInputType,
            errorText: errorText,
            icon: textIcon,
            hintText: hintText,
            textEditingController: textEditingController,
          ),
        ),
        const SizedBox(
          width: spaceBetweenWidgets / 2,
        ),
        GestureDetector(
          onTap: onTap,
          child: Container(
            width: 68,
            height: 68,
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(50),
            ),
            child: Icon(
              iconButton,
              size: 34,
              color: iconColor,
            ),
          ),
        ),
      ],
    );
  }
}
