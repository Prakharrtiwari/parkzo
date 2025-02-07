import 'package:flutter/material.dart';

void showToast(BuildContext context, String message, int duration) {
  ScaffoldMessenger.of(context).showSnackBar(
    SnackBar(
      content: Text(
        message,
        style: TextStyle(color: Colors.white), // Set text color to white
      ),
      duration: Duration(seconds: duration),
      behavior: SnackBarBehavior.floating,
      backgroundColor: Colors.black87,
    ),
  );
}
