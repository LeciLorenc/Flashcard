import 'package:flutter/material.dart';

class AdaptableButton extends StatelessWidget {
  final bool expanded;
  final Function onPressed;
  final IconData icon;
  final String title;
  final IconData? iconExpanded;
  final String? titleExpanded;
  final bool selected;
  final Color textColor;
  final Color iconColor;

  const AdaptableButton({
    super.key,
    required this.expanded,
    required this.onPressed,
    required this.icon,
    required this.title,
    this.iconExpanded,
    this.titleExpanded,
    this.selected = false,
    required this.textColor,
    required this.iconColor,
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 50,
      child: expanded
          ? ElevatedButton(
        style: ElevatedButton.styleFrom(
          elevation: 0,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(0),
          ),
          foregroundColor: textColor,
          backgroundColor: selected ? Colors.black12 : Colors.transparent,
        ),
        onPressed: () => onPressed(),
        child: Row(
          children: [
            Icon(iconExpanded ?? icon, color: iconColor),
            const SizedBox(width: 8.0),
            Text(
              titleExpanded ?? title,
              style: TextStyle(color: textColor),
            ),
          ],
        ),
      )
          : IconButton(
        style: IconButton.styleFrom(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(0),
          ),
          backgroundColor: selected ? Colors.black12 : Colors.transparent,
        ),
        tooltip: title,
        icon: Icon(icon, color: iconColor),
        onPressed: () => onPressed(),
      ),
    );
  }
}
