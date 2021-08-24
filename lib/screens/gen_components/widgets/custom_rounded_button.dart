
import 'package:buruan_sae_mobile_apps/utils/const_color.dart';
import 'package:buruan_sae_mobile_apps/utils/size_config.dart';
import 'package:flutter/material.dart';

class CustomRoundedButton extends StatelessWidget {
  final String text;
  final IconData? prefixIcon, suffixIcon;
  final double elevation;
  final double width;
  final double fontSize, borderRadius;
  final Color backgroundColor, color;
  final Function onPressed;
  const CustomRoundedButton({
    Key? key,
    required this.text,
    required this.onPressed,
    this.fontSize = 5,
    this.backgroundColor = kPrimaryColor,
    this.color = txtPrimaryColor,
    this.borderRadius = 10,
    this.width = double.infinity,
    this.prefixIcon,
    this.suffixIcon, this.elevation = 2,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    SizeConfig().init(context);
    return Container(
      width: this.width,
      child: ElevatedButton(
        style: ElevatedButton.styleFrom(
          elevation: this.elevation,
          primary: this.backgroundColor,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(this.borderRadius),
          ),
          padding: EdgeInsets.symmetric(
            vertical: SizeConfig.getHeightSize(1.5),
          ),
        ),
        onPressed: onPressed as void Function()?,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: <Widget>[
            Center(
              child: Icon(
                this.prefixIcon,
                size: this.fontSize * 3.5,
                color: this.color,
              ),
            ),
            Center(
              child: Text(
                this.text,
                style: TextStyle(
                  color: this.color,
                  fontSize: SizeConfig.getWidthSize(this.fontSize),
                ),
              ),
            ),
            Center(
              child: Icon(
                this.suffixIcon,
                size: SizeConfig.getWidthSize(this.fontSize) - 4,
                color: this.color,
              ),
            )
          ],
        ),
      ),
    );
  }
}
