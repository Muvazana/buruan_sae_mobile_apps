import 'package:buruan_sae_mobile_apps/utils/const_color.dart';
import 'package:buruan_sae_mobile_apps/utils/size_config.dart';
import 'package:flutter/material.dart';

class RoundedInputFieldLogin extends StatefulWidget {
  final String? labelText;
  final double size;
  final Color filledColor, labelColor;
  final ValueChanged<String>? onChanged;
  final ValueSetter<String?>? onSaved;
  final TextInputType? keyboardType;
  final Function? validator;
  final TextEditingController? controller;
  final bool isPassword;
  final bool enable;
  final int maxLine;
  const RoundedInputFieldLogin({
    Key? key,
    this.labelText,
    this.onChanged,
    this.keyboardType,
    this.validator,
    this.controller,
    this.isPassword = false,
    this.onSaved,
    this.size = 2.5,
    this.filledColor = const Color(0xFFF5F5F5),
    this.labelColor = const Color(0xFFC4C4C4),
    this.enable = true,
    this.maxLine = 1,
  }) : super(key: key);

  @override
  _RoundedInputFieldLoginState createState() => _RoundedInputFieldLoginState();
}

class _RoundedInputFieldLoginState extends State<RoundedInputFieldLogin> {
  bool _hidePassword = true;

  final border = UnderlineInputBorder(
    borderRadius: BorderRadius.all(Radius.circular(10)),
    borderSide: BorderSide(
      color: Colors.transparent,
    ),
  );

  @override
  Widget build(BuildContext context) {
    SizeConfig().init(context);
    return Theme(
      data: Theme.of(context).copyWith(
        hintColor: Colors.transparent,
      ),
      child: TextFormField(
        obscureText: widget.isPassword ? _hidePassword : false,
        validator: widget.validator as String? Function(String?)?,
        controller: widget.controller,
        keyboardType: widget.keyboardType,
        onChanged: widget.onChanged,
        onSaved: widget.onSaved,
        maxLines: widget.maxLine,
        decoration: InputDecoration(
          enabled: widget.enable,
          suffixIcon: widget.isPassword
              ? GestureDetector(
                  child: Icon(
                    Icons.visibility,
                    size: SizeConfig.getWidthSize(widget.size + 3.5),
                    color: _hidePassword ? Color(0xFFC4C4C4) : kPrimaryColor,
                  ),
                  onTap: () {
                    setState(() {
                      _hidePassword = !_hidePassword;
                    });
                  },
                )
              : null,
          focusedBorder: border,
          border: border,
          contentPadding: EdgeInsets.symmetric(
            vertical: SizeConfig.getWidthSize(widget.size),
            horizontal: SizeConfig.getWidthSize(widget.size + 0.5),
          ),
          filled: true,
          fillColor: widget.enable ? widget.filledColor : Color(0x48C4C4C4),
          labelText: widget.labelText,
          labelStyle: TextStyle(
            fontSize: SizeConfig.getWidthSize(widget.size + 1.7),
            color: widget.labelColor,
          ),
        ),
      ),
    );
  }
}
