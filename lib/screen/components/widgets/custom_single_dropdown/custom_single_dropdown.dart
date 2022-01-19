import 'package:buruan_sae_apps/screen/components/widgets/custom_single_dropdown/dropdown_modal.dart';
import 'package:buruan_sae_apps/utils/const_color.dart';
import 'package:buruan_sae_apps/utils/size_config.dart';
import 'package:flutter/material.dart';

class CustomSingleDropdown extends StatefulWidget {
  final String? labelText;
  final String btnText;
  final String btnValue;
  final Function onChanged;
  final Function? onTap;
  final bool enabled;
  final double size;
  final List<Map<String, dynamic>?>? itemList;
  final TextEditingController? controller;

  /// List Example : [{'value': '...', 'text': '...'}]
  final Color filledColor, labelColor;
  final FocusNode? focusNode;
  final Widget? icon;
  CustomSingleDropdown({
    Key? key,
    this.labelText,
    required this.itemList,
    required this.onChanged,
    this.size = 3,
    this.filledColor = Colors.white,
    this.labelColor = txtSecondColor,
    this.focusNode,
    this.icon = const Icon(Icons.image_search_rounded, color: kPrimaryColor),
    this.enabled = true,
    this.btnValue = "",
    this.btnText = "Clear",
    required this.controller,
    this.onTap,
  }) : super(key: key);

  @override
  _CustomSingleDropdownState createState() => _CustomSingleDropdownState();
}

class _CustomSingleDropdownState extends State<CustomSingleDropdown> {
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
      child: Container(
        decoration: BoxDecoration(
            border: Border.all(
              width: 1,
              color: Color(0xFFDADADA),
            ),
            borderRadius: BorderRadius.circular(10.0)),
        child: TextField(
          enabled: this.widget.enabled,
          controller: this.widget.controller,
          focusNode: widget.focusNode,
          onTap: () => {
            this.widget.onTap!() ,
            showGeneralDialog(
              barrierDismissible: false,
              barrierLabel:
                  MaterialLocalizations.of(context).modalBarrierDismissLabel,
              barrierColor: Colors.black45,
              transitionDuration: const Duration(milliseconds: 200),
              context: context,
              pageBuilder: (BuildContext context, Animation<double> animation,
                      Animation<double> secondaryAnimation) =>
                  CustomDropdownList(
                btnText: widget.btnText,
                btnValue: widget.btnValue,
                itemList: widget.itemList,
                onSelected: (value, text) {
                  if (value.toString().isEmpty && widget.btnText == "Clear") {
                    this.widget.controller!.clear();
                  } else
                    this.widget.controller!.text = text;
                  setState(() {
                    widget.onChanged(value);
                  });
                },
              ),
            ),
          },
          showCursor: false,
          readOnly: true,
          style: TextStyle(
            color: txtSecondColor,
            fontSize: SizeConfig.getWidthSize(widget.size + 1.7),
          ),
          textAlignVertical: TextAlignVertical.center,
          decoration: InputDecoration(
            prefixIcon: widget.icon,
            suffixIcon: Icon(
              Icons.arrow_drop_down,
              color: txtSecondColor,
            ),
            focusedBorder: border,
            border: border,
            contentPadding: EdgeInsets.symmetric(
              vertical: SizeConfig.getWidthSize(widget.size - 0.5),
              horizontal: SizeConfig.getWidthSize(widget.size),
            ),
            filled: true,
            fillColor: this.widget.enabled ? widget.filledColor : kDarkColor,
            labelText: widget.labelText,
            labelStyle: TextStyle(
              fontSize: SizeConfig.getWidthSize(widget.size + 1.7),
              fontWeight: FontWeight.bold,
              color: widget.labelColor,
            ),
          ),
        ),
      ),
    );
  }
}
