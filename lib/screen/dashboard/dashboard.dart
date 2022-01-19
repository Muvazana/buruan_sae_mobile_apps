import 'dart:convert';

import 'package:buruan_sae_apps/main.dart';
import 'package:buruan_sae_apps/model/user.dart';
import 'package:buruan_sae_apps/screen/Perkembangan/perkembangan_menu.dart';
import 'package:buruan_sae_apps/screen/components/widgets/custom_progress_dialog.dart';
import 'package:buruan_sae_apps/screen/login/login_screen.dart';
import 'package:buruan_sae_apps/screen/penyuluhan/penyuluhan_menu.dart';
import 'package:buruan_sae_apps/utils/api/auth.dart';
import 'package:buruan_sae_apps/utils/const_color.dart';
import 'package:buruan_sae_apps/utils/constants.dart';
import 'package:buruan_sae_apps/utils/db/db_helper.dart';
import 'package:buruan_sae_apps/utils/service/internet_service.dart';
import 'package:buruan_sae_apps/utils/shared_pref.dart';
import 'package:buruan_sae_apps/utils/size_config.dart';
import 'package:data_connection_checker/data_connection_checker.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:modal_progress_hud/modal_progress_hud.dart';

import 'sidebar_layout/sidebar_layout.dart';

class Dashboard extends StatefulWidget {
  static const routeName = '/Dashboard';
  const Dashboard({Key? key}) : super(key: key);

  @override
  _DashboardState createState() => _DashboardState();
}

class _DashboardState extends State<Dashboard> {
  bool _isCollapsed = true;
  String _userName = "Username";
  NetworkImage? _userImage;
  Future<Null> _preparingForSession() async {
    UserModel? userModel;

    if (await SharedPref.isExist(Constants.USER)) {
      userModel =
          UserModel.formJson(await SharedPref.readString(Constants.USER)!);
      setState(() {
        _userName = userModel!.name;
      });
    }
    if (await DataConnectionChecker().hasConnection) {
      setState(() {
        try {
          if (userModel != null && userModel.image != null)
            _userImage = NetworkImage(userModel.image!);
        } catch (e) {}
      });
      CustomProgressDialog.show();
      await DBHelper.setDataKecamatanToSqflite();
      await DBHelper.setDataKelurahanToSqflite();
      await DBHelper.setDataKelompokToSqflite();
      await DBHelper.setDataKomoditasToSqflite();
      CustomProgressDialog.dismiss();
    }
  }

  @override
  void initState() {
    super.initState();
    _preparingForSession();
  }

  @override
  Widget build(BuildContext context) {
    SizeConfig().init(context);
    return SidebarLayout(
      userName: _userName,
      userImage: _userImage,
      isCollapsed: (value) {
        setState(() {
          _isCollapsed = value;
        });
      },
      child: Center(
        child: ListView(
          shrinkWrap: true,
          children: <Widget>[
            Text(
              "Selamat \nDatang",
              style: TextStyle(
                fontSize: SizeConfig.getWidthSize(10),
                fontWeight: FontWeight.bold,
              ),
            ),
            SizedBox(height: 16),
            _cardDashboard(context, "Laporan \nPenyuluhan",
                "assets/icons/penyuluhan.svg",
                onClick: () =>
                    Navigator.pushNamed(context, PenyuluhanMenu.routeName)),
            SizedBox(height: 16),
            _cardDashboard(context, "Laporan \nPerkembangan",
                "assets/icons/perkembangan.svg",
                onClick: () =>
                    Navigator.pushNamed(context, PerkembanganMenu.routeName)),
          ],
        ),
      ),
    );
  }

  Container _cardDashboard(
      BuildContext context, String title, String iconLocation,
      {required Function onClick}) {
    return Container(
      width: double.infinity,
      height: SizeConfig.getHeightSize(20),
      child: Card(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(15.0),
        ),
        color: kPrimaryColor,
        elevation: 8,
        child: InkWell(
          onTap: () => onClick(),
          child: Stack(
            alignment: Alignment.center,
            children: <Widget>[
              Positioned(
                left: 25,
                bottom: 20,
                child: Text(
                  title,
                  style: TextStyle(
                    color: txtPrimaryColor,
                    fontSize: SizeConfig.getWidthSize(6),
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
              Visibility(
                visible: this._isCollapsed,
                child: Positioned(
                  right: 25,
                  child: SvgPicture.asset(
                    iconLocation,
                    height: SizeConfig.getHeightSize(13),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
