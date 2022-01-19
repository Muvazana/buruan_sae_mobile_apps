import 'package:buruan_sae_apps/model/penyuluhan.dart';
import 'package:buruan_sae_apps/model/perkembangan.dart';
import 'package:buruan_sae_apps/screen/Perkembangan/form_create_perkembangan.dart';
import 'package:buruan_sae_apps/screen/Perkembangan/perkembangan_menu.dart';
import 'package:buruan_sae_apps/screen/components/widgets/custom_progress_dialog.dart';
import 'package:buruan_sae_apps/screen/dashboard/dashboard.dart';
import 'package:buruan_sae_apps/screen/login/login_screen.dart';
import 'package:buruan_sae_apps/screen/penyuluhan/form_create_penyuluhan.dart';
import 'package:buruan_sae_apps/screen/penyuluhan/penyuluhan_menu.dart';
import 'package:flutter/material.dart';

class RouteGenerator {
  static String routePosition = '';
  static Route<dynamic> generateRoute(RouteSettings settings) {
    final args = settings.arguments;
    routePosition = settings.name ?? '';

    switch (settings.name) {
      case LoginScreen.routeName:
        return MaterialPageRoute(builder: (context) {
          CustomProgressDialog.context = context;
          return LoginScreen();
        });
      case Dashboard.routeName:
        return MaterialPageRoute(builder: (context) {
          CustomProgressDialog.context = context;
          return Dashboard();
        });
      case PenyuluhanMenu.routeName:
        return MaterialPageRoute(
            builder: (context) => PenyuluhanMenu(
                  isDraft: args as bool? ?? false,
                ));
      case FormCreatePenyuluhan.routeName:
        return MaterialPageRoute(
          builder: (context) => FormCreatePenyuluhan(
            draftData: args as PenyuluhanModel,
          ),
        );
      case PerkembanganMenu.routeName:
        return MaterialPageRoute(
            builder: (context) => PerkembanganMenu(
                  isDraft: args as bool? ?? false,
                ));
      case FormCreatePerkembangan.routeName:
        return MaterialPageRoute(
          builder: (context) => FormCreatePerkembangan(
            draftData: args as AuditModel,
          ),
        );
      default:
        return MaterialPageRoute(builder: (context) => Dashboard());
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
