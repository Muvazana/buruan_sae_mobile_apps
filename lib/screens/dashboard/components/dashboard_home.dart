import 'dart:io';

import 'package:buruan_sae_mobile_apps/screens/dashboard/dashboard.dart';
import 'package:buruan_sae_mobile_apps/screens/dashboard/screens/home_screen.dart';
import 'package:buruan_sae_mobile_apps/utils/const_color.dart';
import 'package:buruan_sae_mobile_apps/utils/constants.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:flutter_platform_widgets/flutter_platform_widgets.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:flutter_zoom_drawer/flutter_zoom_drawer.dart';

class DashboardHome extends StatefulWidget {
  final Duration duration;
  const DashboardHome(this.duration, {Key? key}) : super(key: key);
  @override
  _DashboardHomeState createState() => _DashboardHomeState();
}

class _DashboardHomeState extends State<DashboardHome>
    with SingleTickerProviderStateMixin {
  late AnimationController _animationController;

  @override
  void initState() {
    super.initState();
    _animationController =
        AnimationController(vsync: this, duration: this.widget.duration);
  }

  @override
  void dispose() {
    super.dispose();
    _animationController.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final _size = MediaQuery.of(context).size;
    final _currentPage =
        context.select<MenuProvider, int>((provider) => provider.currentPage);
    Widget container = Container(
      alignment: Alignment.center,
      color: Colors.white,
      child: Text("${Dashboard.mainMenu[_currentPage].title}"),
    );
    switch (Dashboard.mainMenu[_currentPage].index) {
      case 0:
        container = HomeScreen.homeScreen(context);
        break;
    }
    return ValueListenableBuilder<DrawerState>(
      valueListenable: ZoomDrawer.of(context)!.stateNotifier!,
      builder: (context, state, child) {
        if (state == DrawerState.closed) _animationController.reverse();
        return AbsorbPointer(
          absorbing: state != DrawerState.closed,
          child: child,
        );
      },
      child: GestureDetector(
        onPanUpdate: (details) {
          if (details.delta.dx < 6) {
            ZoomDrawer.of(context)!.toggle();
          }
        },
        child: PlatformScaffold(
          backgroundColor: Colors.white,
          appBar: PlatformAppBar(
            automaticallyImplyLeading: false,
            material: (_, __) => MaterialAppBarData(
                backgroundColor: Colors.white, elevation: 0, centerTitle: true),
            // title: PlatformText(
            //   Dashboard.mainMenu[_currentPage].title,
            //   style: TextStyle(color: txtSecondColor),
            // ),
            leading: PlatformIconButton(
              materialIcon: AnimatedIcon(
                icon: AnimatedIcons.menu_close,
                progress: _animationController,
                color: txtSecondColor,
              ),
              onPressed: () {
                ZoomDrawer.of(context)!.toggle();
                print(ZoomDrawer.of(context)!.stateNotifier!.value);
                ZoomDrawer.of(context)!.stateNotifier!.value ==
                        DrawerState.opening
                    ? _animationController.forward()
                    : _animationController.reverse();
              },
            ),
            trailingActions: [
              Center(
                child: Container(
                  height: _size.height * 0.05,
                  width: _size.height * 0.05,
                  margin: EdgeInsets.only(right: 8),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.all(Radius.circular(50)),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.grey.withOpacity(1),
                        spreadRadius: 2,
                        blurRadius: 5,
                        offset: Offset(2, 3),
                      ),
                    ],
                  ),
                  child: CircleAvatar(
                    // backgroundImage: this.widget.userImage,
                    backgroundColor: Colors.white,
                    child:
                        // this.widget.userImage == null
                        //     ? Icon(
                        //         Icons.person,
                        //         color: kPrimaryColor,
                        //       )
                        //     :
                        Container(),
                  ),
                ),
              )
            ],
          ),
          body: Platform.isAndroid
              ? container
              : SafeArea(
                  child: container,
                ),
        ),
      ),
    );
    // return Scaffold(
    //   appBar: AppBar(
    //     backgroundColor: Colors.white,
    //     elevation: 0,
    //     leading: Center(
    //       child: InkWell(
    //         child: AnimatedIcon(
    //           icon: AnimatedIcons.menu_close,
    //           progress: _animationController,
    //           color: txtSecondColor,
    //         ),
    //         onTap: () {
    //           this.widget.drawerController.toggle!();
    //           this.widget.drawerController.stateNotifier!.value ==
    //                   DrawerState.opening
    //               ? _animationController.forward()
    //               : _animationController.reverse();
    //         },
    //       ),
    //     ),
    //     actions: [
    //       Center(
    //         child: Container(
    //           height: _size.height * 0.05,
    //           width: _size.height * 0.05,
    //           margin: EdgeInsets.only(right: 8),
    //           decoration: BoxDecoration(
    //             color: Colors.white,
    //             borderRadius: BorderRadius.all(Radius.circular(50)),
    //             boxShadow: [
    //               BoxShadow(
    //                 color: Colors.grey.withOpacity(1),
    //                 spreadRadius: 2,
    //                 blurRadius: 5,
    //                 offset: Offset(2, 3),
    //               ),
    //             ],
    //           ),
    //           child: CircleAvatar(
    //             // backgroundImage: this.widget.userImage,
    //             backgroundColor: Colors.white,
    //             child:
    //                 // this.widget.userImage == null
    //                 //     ? Icon(
    //                 //         Icons.person,
    //                 //         color: kPrimaryColor,
    //                 //       )
    //                 //     :
    //                 Container(),
    //           ),
    //         ),
    //       )
    //     ],
    //     title: Text('Dashboard'),
    //   ),
    //   body:
    // );
  }
}
