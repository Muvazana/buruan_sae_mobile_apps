import 'package:buruan_sae_apps/utils/const_color.dart';
import 'package:buruan_sae_apps/utils/size_config.dart';
import 'package:flutter/material.dart';

class CustomTextFormField extends StatelessWidget {
  final double size;
  final TextEditingController? controller;
  final int maxLines;
  final bool enable;
  final TextInputType? keyboardType;
  final String? prefixText;
  const CustomTextFormField({
    Key? key,
    this.size = 3,
    this.controller,
    this.maxLines = 1,
    this.enable = true,
    this.keyboardType,
    this.prefixText,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    SizeConfig().init(context);
    return Container(
      decoration: BoxDecoration(
          color: enable ? Colors.white : kDarkColor,
          borderRadius: BorderRadius.circular(10),
          border: Border.all(width: 1, color: Color(0xFFCCCCCC))),
      child: Scrollbar(
        child: TextField(
          enabled: enable,
          controller: controller,
          keyboardType: keyboardType,
          maxLines: maxLines,
          style: TextStyle(
            color: txtSecondColor,
            fontSize: SizeConfig.getWidthSize(this.size + 1.7),
          ),
          decoration: InputDecoration(
            prefixText: this.prefixText ?? '',
            prefixStyle: TextStyle(
              color: txtSecondColor,
              fontSize: SizeConfig.getWidthSize(this.size + 1.7),
              fontWeight: FontWeight.bold,
            ),
            contentPadding: EdgeInsets.symmetric(
              vertical: SizeConfig.getWidthSize(this.size - 0.5),
              horizontal: SizeConfig.getWidthSize(this.size),
            ),
            border: InputBorder.none,
          ),
        ),
      ),
    );
  }
}
