import 'package:buruan_sae_apps/model/user.dart';
import 'package:buruan_sae_apps/screen/components/widgets/custom_snackbar_v1.dart';
import 'package:buruan_sae_apps/screen/dashboard/sidebar_layout/sidebar_menu_item.dart';
import 'package:buruan_sae_apps/screen/login/login_screen.dart';
import 'package:buruan_sae_apps/utils/api/auth.dart';
import 'package:buruan_sae_apps/utils/constants.dart';
import 'package:buruan_sae_apps/utils/size_config.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'account_tile.dart';

class Sidebar extends StatelessWidget {
  final String userName;
  final NetworkImage? userImage;
  const Sidebar({
    Key? key,
    this.userName = "Username",
    this.userImage,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    SizeConfig().init(context);
    return Column(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      mainAxisSize: MainAxisSize.max,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            SizedBox(
              height: SizeConfig.getHeightSize(8),
            ),
            AccountTile(
              image: this.userImage,
              name: this.userName,
            ),
            SizedBox(
              height: SizeConfig.getHeightSize(5),
            ),
            SidebarMenuItem(
              text: "Home",
              icon: Icons.home_sharp,
              onTap: () {},
            ),
            SidebarMenuItem(
              text: "Profile",
              icon: Icons.person,
              onTap: () {},
            ),
            SidebarMenuItem(
              text: "Settings",
              icon: Icons.settings,
              onTap: () {},
            ),
          ],
        ),
        Padding(
          padding: EdgeInsets.only(bottom: SizeConfig.getHeightSize(2)),
          child: SidebarMenuItem(
            text: "Logout",
            icon: Icons.logout,
            onTap: () async {
              final result = await AuthAPI().logout();
              if (result.getSuccess) {
                Navigator.of(context).pushNamedAndRemoveUntil(
                    LoginScreen.routeName, (Route<dynamic> route) => false);
              } else {
                CustomSnackbarV1.showSnackbar(context, result.getMessage);
              }
            },
          ),
        ),
      ],
    );
  }
}
