import 'dart:convert';

import 'package:buruan_sae_apps/model/user.dart';
import 'package:buruan_sae_apps/screen/dashboard/sidebar_layout/sidebar.dart';
import 'package:buruan_sae_apps/utils/const_color.dart';
import 'package:buruan_sae_apps/utils/constants.dart';
import 'package:buruan_sae_apps/utils/size_config.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class SidebarLayout extends StatefulWidget {
  final Widget child;
  final Function isCollapsed;
  final String userName;
  final NetworkImage? userImage;
  const SidebarLayout({
    Key? key,
    required this.child,
    required this.isCollapsed,
    this.userName = "Username",
    this.userImage,
  }) : super(key: key);

  @override
  _SidebarLayoutState createState() => _SidebarLayoutState();
}

class _SidebarLayoutState extends State<SidebarLayout>
    with SingleTickerProviderStateMixin {
  bool isCollapsed = true;
  final Duration duration = const Duration(milliseconds: 350);
  late AnimationController _animationController;

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(vsync: this, duration: duration);
  }

  @override
  void dispose() {
    super.dispose();
    _animationController.dispose();
  }

  @override
  Widget build(BuildContext context) {
    SizeConfig().init(context);
    return Scaffold(
      backgroundColor: kPrimaryColor,
      body: Stack(
        children: <Widget>[
          Sidebar(
            userName: this.widget.userName,
            userImage: this.widget.userImage,
          ),
          AnimatedPositioned(
            top: isCollapsed ? 0 : SizeConfig.getHeightSize(10),
            bottom: isCollapsed ? 0 : SizeConfig.getHeightSize(10),
            left: isCollapsed ? 0 : SizeConfig.getWidthSize(60),
            right: isCollapsed ? 0 : SizeConfig.getWidthSize(-40),
            duration: duration,
            curve: Curves.easeInOut,
            child: Material(
              elevation: 8,
              color: Colors.white,
              borderRadius:
                  BorderRadius.all(Radius.circular(isCollapsed ? 0 : 10)),
              child: Container(
                padding: EdgeInsets.only(
                    left: 16, right: 16, top: isCollapsed ? 42 : 32),
                child: Column(
                  children: <Widget>[
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      mainAxisSize: MainAxisSize.max,
                      children: <Widget>[
                        InkWell(
                          child: AnimatedIcon(
                              icon: AnimatedIcons.menu_close,
                              progress: _animationController,
                              color: txtSecondColor),
                          onTap: () {
                            setState(() {
                              isCollapsed = !isCollapsed;
                              this.widget.isCollapsed(this.isCollapsed);
                              isCollapsed
                                  ? _animationController.reverse()
                                  : _animationController.forward();
                            });
                          },
                        ),
                        Container(
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
                            backgroundImage: this.widget.userImage,
                            backgroundColor: Colors.white,
                            child: this.widget.userImage == null
                                ? Icon(
                                    Icons.person,
                                    color: kPrimaryColor,
                                  )
                                : Container(),
                          ),
                        ),
                      ],
                    ),
                    Container(
                      width: double.infinity,
                      child: widget.child,
                    )
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
