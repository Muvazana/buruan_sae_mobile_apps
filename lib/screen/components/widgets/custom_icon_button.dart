import 'package:buruan_sae_apps/utils/const_color.dart';
import 'package:buruan_sae_apps/utils/size_config.dart';
import 'package:flutter/material.dart';

class CustomIconButton extends StatelessWidget {
  final Widget icon;
  final Function? onPressed;
  final double size;
  final bool isCircular;
  final Color bgColor;
  final Color iconColor;

  const CustomIconButton({
    Key? key,
    required this.icon,
    required this.onPressed,
    required this.isCircular,
    this.size = 8.5,
    this.bgColor = Colors.white,
    this.iconColor = txtPrimaryColor,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    SizeConfig().init(context);
    return Container(
      width: SizeConfig.getWidthSize(size),
      height: SizeConfig.getWidthSize(size),
      alignment: Alignment.center,
      decoration: BoxDecoration(
        shape: isCircular ? BoxShape.circle : BoxShape.rectangle,
        color: bgColor,
        borderRadius: isCircular ? null : BorderRadius.all(Radius.circular(10)),
      ),
      child: IconButton(
        iconSize: SizeConfig.getWidthSize(size - 3),
        padding: EdgeInsets.zero,
        icon: icon,
        color: iconColor,
        onPressed: onPressed as void Function()?,
      ),
    );
  }
}