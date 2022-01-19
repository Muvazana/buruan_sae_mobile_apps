import 'package:flutter/material.dart';

class CustomSnackbarV1 {
  static void showSnackbar(BuildContext context, String text) {
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(text)));
  }
}
