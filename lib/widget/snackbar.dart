import 'package:flutter/material.dart';

void showSnackbar(BuildContext context, String message) {
  ScaffoldMessenger.of(context).showSnackBar(
    SnackBar(
      content: Center(
        child: Text(
          "$message 🦆",
          style: TextStyle(
            fontSize: 16,
          ),
        ),
      ),
      backgroundColor: Colors.amber.shade700,
      behavior: SnackBarBehavior.floating,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16),
      ),
      duration: Duration(seconds: 3),
    ),
  );
}