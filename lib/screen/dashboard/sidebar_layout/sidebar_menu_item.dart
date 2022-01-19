import 'package:buruan_sae_apps/utils/size_config.dart';
import 'package:flutter/material.dart';

class SidebarMenuItem extends StatelessWidget {
  final String? text;
  final IconData? icon;
  final Function? onTap;

  const SidebarMenuItem({
    Key? key,
    this.text,
    this.icon,
    this.onTap,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    SizeConfig().init(context);
    return InkWell(
      onTap: onTap as void Function()?,
      child: Container(
        width: SizeConfig.getWidthSize(50),
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisSize: MainAxisSize.max,
            children: <Widget>[
              Icon(
                icon,
                color: Colors.white,
                size: SizeConfig.getWidthSize(6),
              ),
              SizedBox(
                width: SizeConfig.getWidthSize(5),
              ),
              Text(
                text!,
                style: TextStyle(
                  fontSize: SizeConfig.getWidthSize(5),
                  color: Colors.white,
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}
