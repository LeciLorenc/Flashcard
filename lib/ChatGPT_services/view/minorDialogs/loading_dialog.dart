import 'package:flutter/material.dart';

class LoadingDialog extends StatelessWidget
{
  static bool isLoading = true;

  const LoadingDialog({super.key});

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      content: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          const CircularProgressIndicator(), // Loading indicator
          const SizedBox(height: 16),
          const Text("Loading..."),
          const SizedBox(height: 16),
          ElevatedButton(
            onPressed: () {
              Navigator.pop(context);
              isLoading = false;// Cancel button action
            },
            child: const Text("Cancel"),
          ),
        ],
      ),
    );
  }
}