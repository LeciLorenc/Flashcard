import 'package:flutter/material.dart';

import '../../constants.dart';



typedef OrderingCallback = void Function(String subj);

class Choice extends StatefulWidget {
  final OrderingCallback orderingCallback;

  const Choice({Key? key, required this.orderingCallback}) : super(key: key);

  @override
  _Choice createState() => _Choice();
}

class _Choice extends State<Choice> {
  String? choice = '';

  @override
  Widget build(BuildContext context) {
    return Theme(
      data: Theme.of(context).copyWith(
        colorScheme: const ColorScheme.light(
          primary: primaryColor, // Set the color for the selected date
        ),) ,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children:[
          Transform.translate(
            offset: const Offset(0,-34),
            child: Container(
              decoration: BoxDecoration(
                border: Border.all(
                  color: Colors.blue, // Set the border color to blue
                  width: 1, // Set the border width
                ),
              ),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  const Text("Would like to review again?"),
                  const SizedBox(height: 2),
                  buildButton("Review a subject", 'Subject'),
                  const SizedBox(height: 6),
                  buildButton("Review a deck", 'Deck'),
                ],
              ),
            ),
          ),],
      ),
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
      child: Padding(
        padding: const EdgeInsets.all(2.0),
        child: SizedBox(
          width: 150,
          height: 30,
          child: Row(
            children: [
              Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children:[
                  Text(label),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
