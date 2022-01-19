import 'dart:async';

import 'package:buruan_sae_apps/model/notif_msg.dart';
import 'package:data_connection_checker/data_connection_checker.dart';
import 'package:flutter/material.dart';

class InternetService {
  static StreamSubscription<DataConnectionStatus>? listener;
  static NotifMessageModel notifMessageModel = new NotifMessageModel();

  static checkConnection(BuildContext context,
      {Function? onConnected, Function? onDisconnected}) async {
    listener = DataConnectionChecker().onStatusChange.listen((status) {
      print(status);
      switch (status) {
        case DataConnectionStatus.connected:
          onConnected;
          break;
        case DataConnectionStatus.disconnected:
          onDisconnected;
          break;
      }
    });
    // return await DataConnectionChecker().connectionStatus;
  }
}
