import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class ProgressLoadingDialog {
  static List<String> _processList = [];
  static bool isActive = false;
  static BuildContext? loadingContext;

  static void showLoadingDialog(String process) {
    _processList.add(process);
    if (!isActive) {
      isActive = true;
      _loadingDialog();
    }
  }

  static void dismissLoadingDialog(String process) {
    _processList.remove(process);
    if (isActive && _processList.isEmpty) {
      isActive = false;
      Navigator.pop(loadingContext!);
    }
  }

  static Future<Null> _loadingDialog() async {
    if (Platform.isIOS) {
      return showCupertinoDialog(
        context: loadingContext!,
        barrierDismissible: false,
        builder: (context) => WillPopScope(
          child: Center(
            child: CupertinoActivityIndicator(),
          ),
          onWillPop: () {
            return Future.value(false);
          },
        ),
      );
    } else {
      return showDialog(
        context: loadingContext!,
        barrierDismissible: false,
        builder: (context) => WillPopScope(
          child: Center(
            child: CircularProgressIndicator(),
          ),
          onWillPop: () {
            return Future.value(false);
          },
        ),
      );
    }
  }
}
