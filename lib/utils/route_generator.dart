import 'package:buruan_sae_mobile_apps/screens/gen_components/pg_loading.dart';
import 'package:buruan_sae_mobile_apps/screens/login/login_screen.dart';
import 'package:flutter/material.dart';

class RouteGenerator {
  static String routePosition = '';
  static Route<dynamic> generateRoute(RouteSettings settings) {
    final args = settings.arguments;
    routePosition = settings.name ?? '';

    switch (settings.name) {
      case LoginScreen.routeName:
        return MaterialPageRoute(builder: (context) {
          ProgressLoadingDialog.loadingContext = context;
          // CustomProgressDialog.context = context;
          return LoginScreen();
        });
      // case Dashboard.routeName:
      //   return MaterialPageRoute(builder: (context) {
      //     CustomProgressDialog.context = context;
      //     return Dashboard();
      //   });
      // case PenyuluhanMenu.routeName:
      //   return MaterialPageRoute(
      //       builder: (context) => PenyuluhanMenu(
      //             isDraft: args as bool? ?? false,
      //           ));
      // case FormCreatePenyuluhan.routeName:
      //   return MaterialPageRoute(
      //     builder: (context) => FormCreatePenyuluhan(
      //       draftData: args as PenyuluhanModel,
      //     ),
      //   );
      // case PerkembanganMenu.routeName:
      //   return MaterialPageRoute(
      //       builder: (context) => PerkembanganMenu(
      //             isDraft: args as bool? ?? false,
      //           ));
      // case FormCreatePerkembangan.routeName:
      //   return MaterialPageRoute(
      //     builder: (context) => FormCreatePerkembangan(
      //       draftData: args as AuditModel,
      //     ),
      //   );
      default:
        return _errorRoute();
      // return MaterialPageRoute(builder: (context) => Dashboard());
    }
  }

  static Route<dynamic> _errorRoute() {
    return MaterialPageRoute(builder: (_) {
      return Scaffold(
        appBar: AppBar(
          title: Text('Error'),
        ),
        body: Center(
          child: Text('Error'),
        ),
      );
    });
  }
}
