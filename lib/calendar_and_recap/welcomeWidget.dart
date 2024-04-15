import 'package:flutter/material.dart';

class WelcomeWidget extends StatelessWidget {
  const WelcomeWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return const Center(
      child: Column(
        children: [
          Text(
            "WELCOME USER   (  :-)  )\n Select a subject",
            style: TextStyle(fontSize: 14),
          ),

          //Image.asset('lib/presentation/welcome-back-image.jpg'),
        ],
      ),
    );
  }
}