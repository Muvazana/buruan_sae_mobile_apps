import 'dart:io';

import 'package:buruan_sae_mobile_apps/screens/dashboard/dashboard.dart';
import 'package:buruan_sae_mobile_apps/utils/const_color.dart';
import 'package:flutter/material.dart';
import 'package:flutter_platform_widgets/flutter_platform_widgets.dart';
import 'package:provider/provider.dart';

class DashboardMenu extends StatefulWidget {
  final List<MenuItem> mainMenu;
  final Function(int)? callback;
  final int? current;
  DashboardMenu(
    this.mainMenu, {
    Key? key,
    this.callback,
    this.current,
  });

  @override
  _DashboardMenuState createState() => _DashboardMenuState();
}

class _DashboardMenuState extends State<DashboardMenu> {
  @override
  Widget build(BuildContext context) {
    final _size = MediaQuery.of(context).size;
    final TextStyle androidStyle =
        TextStyle(fontSize: _size.width * 0.045, color: Colors.white);
    final TextStyle iosStyle = const TextStyle(color: Colors.white);
    final style = Platform.isAndroid ? androidStyle : iosStyle;

    return Scaffold(
      body: Container(
        padding: EdgeInsets.only(left: 8),
        color: Theme.of(context).primaryColor,
        child: SafeArea(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            mainAxisSize: MainAxisSize.max,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              Spacer(),
              Padding(
                padding: const EdgeInsets.only(left: 8),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: <Widget>[
                    Container(
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.all(Radius.circular(50)),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black.withOpacity(0.4),
                            spreadRadius: 2,
                            blurRadius: 5,
                            offset: Offset(2, 3),
                          ),
                        ],
                      ),
                      child: CircleAvatar(
                        radius: _size.width * 0.085,
                        // backgroundImage: image,
                        backgroundColor: Colors.white,
                        child:
                            // (image == null)
                            //     ? Icon(
                            //         Icons.person,
                            //         color: kPrimaryColor,
                            //         size: _size.width * 0.1,
                            //       )
                            //     :
                            Container(),
                      ),
                    ),
                    SizedBox(height: 6),
                    Text(
                      'Name Text',
                      style: TextStyle(
                        fontSize: _size.width * 0.055,
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ],
                ),
              ),
              SizedBox(height: 24),
              Selector<MenuProvider, int>(
                selector: (_, provider) => provider.currentPage,
                builder: (_, index, __) => Column(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    ...widget.mainMenu
                        .map((item) => MenuItemWidget(
                              key: Key(item.index.toString()),
                              item: item,
                              callback: widget.callback,
                              style: style,
                              selected: index == item.index,
                            ))
                        .toList()
                  ],
                ),
              ),
              Spacer(flex: 5),
              Padding(
                padding: const EdgeInsets.only(left: 24.0, right: 24.0),
                child: TextButton(
                  onPressed: () {
                    print("Logout Pressed !");
                  },
                  child: Row(
                    mainAxisSize: MainAxisSize.max,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: <Widget>[
                      Icon(
                        Icons.arrow_back,
                        color: Colors.white,
                        size: _size.width * 0.06,
                      ),
                      SizedBox(
                        width: 16.0,
                      ),
                      Expanded(
                        child: Text(
                          "Logout",
                          style: style,
                        ),
                      )
                    ],
                  ),
                ),
              ),
              // Padding(
              //   padding: const EdgeInsets.only(left: 24.0, right: 24.0),
              //   child: PlatformTextButton(
              //     child: Padding(
              //       padding: const EdgeInsets.all(8.0),
              //       child: Text(
              //         "logout",
              //         style: TextStyle(fontSize: 18),
              //       ),
              //     ),
              //     onPressed: () => print("Pressed !"),
              //   ),
              // ),
              Spacer(flex: 1),
            ],
          ),
        ),
      ),
    );
  }
}

class MenuItem {
  final int index;
  final String title;
  final IconData icon;

  const MenuItem(this.index, this.title, this.icon);
}

class MenuItemWidget extends StatelessWidget {
  final MenuItem? item;
  final TextStyle? style;
  final Function? callback;
  final bool? selected;

  final white = Colors.white;

  const MenuItemWidget({
    Key? key,
    this.item,
    this.style,
    this.callback,
    this.selected,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final _size = MediaQuery.of(context).size;
    return TextButton(
      onPressed: () => callback!(item!.index),
      style: TextButton.styleFrom(
        primary: selected! ? Color(0x44000000) : null,
      ),
      child: Row(
        mainAxisSize: MainAxisSize.max,
        crossAxisAlignment: CrossAxisAlignment.center,
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          Icon(
            item!.icon,
            color: white,
            size: _size.width * 0.06,
          ),
          SizedBox(
            width: 16.0,
          ),
          Expanded(
            child: Text(
              item!.title,
              style: style,
            ),
          )
        ],
      ),
    );
  }
}
