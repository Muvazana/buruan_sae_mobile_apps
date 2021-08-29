import 'package:buruan_sae_mobile_apps/utils/const_color.dart';
import 'package:buruan_sae_mobile_apps/utils/constants.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

class HomeScreen {
  static Widget homeScreen(BuildContext context) {
    final _size = MediaQuery.of(context).size;
    return ListView(
      padding: EdgeInsets.all(kPrimaryPadding),
      shrinkWrap: true,
      children: <Widget>[
        Text(
          "Selamat \nDatang",
          style: TextStyle(
            fontSize: _size.width * 0.1,
            fontWeight: FontWeight.bold,
          ),
        ),
        SizedBox(height: 16),
        _cardDashboard(context, "Laporan \nPenyuluhan",
            "assets/icons/undraw_welcome_cats.svg",
            onClick: () => {}
            // Navigator.pushNamed(context, PenyuluhanMenu.routeName),
            ),
        SizedBox(height: 16),
        _cardDashboard(context, "Laporan \nPerkembangan",
            "assets/icons/undraw_welcome_cats.svg",
            onClick: () => {}
            // Navigator.pushNamed(context, PerkembanganMenu.routeName),
            ),
      ],
    );
  }

  static Widget _cardDashboard(BuildContext context, String title, String iconLocation,
      {required Function onClick}) {
    final _size = MediaQuery.of(context).size;
    return Container(
      width: double.infinity,
      height: _size.height * 0.2,
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
                    fontSize: _size.width * 0.06,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
              Positioned(
                right: 25,
                child: SvgPicture.asset(
                  iconLocation,
                  height: _size.height * 0.1,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
