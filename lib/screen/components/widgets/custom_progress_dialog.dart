import 'package:cool_alert/cool_alert.dart';
import 'package:flutter/material.dart';

class CustomProgressDialog {
  static BuildContext? context;
  static bool isOpen = false;
  static show() {
    CoolAlert.show(
        context: context!,
        type: CoolAlertType.loading,
        barrierDismissible: false);
    isOpen = true;
  }

  static dismiss() {
    if (isOpen) Navigator.pop(context!);
    isOpen = false;
  }
}
