import 'package:buruan_sae_mobile_apps/screens/dashboard/dashboard.dart';
import 'package:buruan_sae_mobile_apps/screens/login/login_screen.dart';
import 'package:buruan_sae_mobile_apps/utils/const_color.dart';
import 'package:buruan_sae_mobile_apps/utils/route_generator.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    // Set portrait orientation
    SystemChrome.setPreferredOrientations([
      DeviceOrientation.portraitDown,
      DeviceOrientation.portraitUp,
    ]);
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Flutter Demo',
      theme: ThemeData(
        // primarySwatch: MaterialColor(kPrimaryColor.value, {
        //   500: kPrimaryColor,
        // }),
        primaryColor: kPrimaryColor,
        scaffoldBackgroundColor: Colors.white,
      ),
      initialRoute: Dashboard.routeName,
      onGenerateRoute: RouteGenerator.generateRoute,
    );
  }
}
