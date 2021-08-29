import 'package:buruan_sae_mobile_apps/screens/dashboard/components/dashboard_home.dart';
import 'package:buruan_sae_mobile_apps/screens/dashboard/components/dashboard_menu.dart';
import 'package:flutter/material.dart';
import 'package:flutter_zoom_drawer/flutter_zoom_drawer.dart';
import 'package:provider/provider.dart';

class Dashboard extends StatefulWidget {
  static const routeName = '/Dashboard';
  static List<MenuItem> mainMenu = [
    MenuItem(0, "Dashboard", Icons.home_sharp),
    MenuItem(1, "Profile", Icons.person),
    MenuItem(2, "About", Icons.settings),
  ];
  const Dashboard({Key? key}) : super(key: key);

  @override
  _DashboardState createState() => _DashboardState();
}

class _DashboardState extends State<Dashboard> {
  final _drawerController = new ZoomDrawerController();
  final _duration = const Duration(milliseconds: 350);

  int _currentPage = 0;

  @override
  Widget build(BuildContext context) {
    final _size = MediaQuery.of(context).size;
    return Scaffold(
      body: ZoomDrawer(
        controller: _drawerController,
        style: DrawerStyle.Style1,
        menuScreen: DashboardMenu(
          Dashboard.mainMenu,
          callback: _updatePage,
          current: _currentPage,
        ),
        mainScreen: DashboardHome(_duration),
        borderRadius: 15.0,
        showShadow: false,
        angle: 0.0,
        backgroundColor: Colors.grey[300]!,
        slideWidth: _size.width * 0.50,
        duration: _duration,
        openCurve: Curves.easeInOut,
        closeCurve: Curves.easeInOut,
      ),
    );
  }

  void _updatePage(index) {
    Provider.of<MenuProvider>(context, listen: false).updateCurrentPage(index);
    _drawerController.toggle!();
  }
}

class MenuProvider extends ChangeNotifier {
  int _currentPage = 0;

  int get currentPage => _currentPage;

  void updateCurrentPage(int index) {
    if (index != currentPage) {
      _currentPage = index;
      notifyListeners();
    }
  }
}

