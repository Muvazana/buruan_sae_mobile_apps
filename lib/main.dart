// @dart=2.9
import 'dart:async';

import 'package:buruan_sae_apps/model/penyuluhan.dart';
import 'package:buruan_sae_apps/screen/components/widgets/custom_progress_dialog.dart';
import 'package:buruan_sae_apps/screen/dashboard/dashboard.dart';
import 'package:buruan_sae_apps/screen/login/login_screen.dart';
import 'package:buruan_sae_apps/screen/penyuluhan/penyuluhan_menu.dart';
import 'package:buruan_sae_apps/utils/api/auth.dart';
import 'package:buruan_sae_apps/utils/const_color.dart';
import 'package:buruan_sae_apps/utils/route_generator.dart';
import 'package:buruan_sae_apps/utils/service/internet_service.dart';
import 'package:cool_alert/cool_alert.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:modal_progress_hud/modal_progress_hud.dart';

import 'screen/penyuluhan/form_create_penyuluhan.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatefulWidget {
  @override
  _MyAppState createState() => _MyAppState();
}

class _MyAppState extends State<MyApp>{
  // AppLifecycleState _notification;
  // @override
  // void initState() {
  //   super.initState();
  //   // WidgetsBinding.instance.addObserver(this);
  //   // ExtendLoginTime.context = context;
  //   // ExtendLoginTime.start();
  //   // InternetService.checkConnection(context,
  //   //     onConnected: () => _extendLoginTime(),
  //   //     onDisconnected: () => ExtendLoginTime.cancel());
  // }

  // @override
  // void dispose() {
  //   // WidgetsBinding.instance.removeObserver(this);
  //   // ExtendLoginTime.dispose();
  //   InternetService.listener.cancel();
  //   super.dispose();
  // }

  // @override
  // void didChangeAppLifecycleState(AppLifecycleState state) {
  //   setState(() {
  //     _notification = state;
  //   });
  //   print(state);
  //   switch (state) {
  //     case AppLifecycleState.resumed:
  //       _extendLoginTime();
  //       // Handle this case
  //       break;
  //     case AppLifecycleState.inactive:
  //       ExtendLoginTime.cancel();
  //       // Handle this case
  //       break;
  //     case AppLifecycleState.paused:
  //       // Handle this case
  //       break;
  //     case AppLifecycleState.detached:
  //       // TODO: Handle this case.
  //       break;
  //   }
  // }

  // _extendLoginTime() async {
  //   if (RouteGenerator.routePosition != LoginScreen.routeName) {
  //     CustomProgressDialog.show();
  //     final result = await AuthAPI.extendLoginTime();
  //     if (!result.getSuccess &&
  //         result.getMessage != "Tidak ada jaringan Internet!") {
  //       Navigator.of(context).pushNamedAndRemoveUntil(
  //           LoginScreen.routeName, (Route<dynamic> route) => false);
  //     }
  //     ExtendLoginTime.start();
  //     CustomProgressDialog.dismiss();
  //   }
  // }

  @override
  Widget build(BuildContext context) {
    // Set portrait orientation
    SystemChrome.setPreferredOrientations([
      DeviceOrientation.portraitDown,
      DeviceOrientation.portraitUp,
    ]);

    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Buruan SAE',
      theme: ThemeData(
        primaryColor: kPrimaryColor,
        scaffoldBackgroundColor: Colors.white,
      ),
      initialRoute: LoginScreen.routeName,
      onGenerateRoute: RouteGenerator.generateRoute,
    );
  }
}
