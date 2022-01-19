import 'package:buruan_sae_apps/utils/const_color.dart';
import 'package:buruan_sae_apps/utils/size_config.dart';
import 'package:flutter/material.dart';

import 'single_dropdown_modal_layout_v1.dart';

class CustomSingleDropdownV1Controller {
  VoidCallback? clear;
  String value = '';
  Map<String, dynamic>? data;

  void dispose() {
    clear = null;
    value = '';
    data = null;
  }
}

class CustomSingleDropdownV1 extends StatefulWidget {
  final CustomSingleDropdownV1Controller? controller;
  final double size;
  final String hintText;
  final bool enable, showAllEnable, showIconLabel;
  final Widget? icon;
  final Function? onChange;
  final List<Map<String, dynamic>?> itemList;
  final int initialValue;
  CustomSingleDropdownV1({
    Key? key,
    this.controller,
    this.size = 3,
    this.enable = true,
    this.showAllEnable = false,
    this.showIconLabel = false,
    this.icon = const Icon(Icons.image_search_rounded, color: kPrimaryColor),
    this.onChange,
    required this.itemList,
    int? initialValue,
    this.hintText = 'Hint',
  })  : initialValue = initialValue ?? -1,
        super(key: key);

  @override
  _CustomSingleDropdownV1State createState() => _CustomSingleDropdownV1State();
}

class _CustomSingleDropdownV1State extends State<CustomSingleDropdownV1> {
  final border = UnderlineInputBorder(
    borderRadius: BorderRadius.all(Radius.circular(10)),
    borderSide: BorderSide(
      color: Colors.transparent,
    ),
  );

  late TextEditingController _textcontroller;
  late FocusNode _focusNode;
  late Map<String, dynamic> _inititalValue;

  @override
  void initState() {
    super.initState();
    _textcontroller = TextEditingController();
    _focusNode = FocusNode();
    this.widget.controller!.clear = clear;
    _inititalValue = {
      'value': -1,
      'text': this.widget.showAllEnable ? 'Show All' : ''
    };
    if (this.widget.initialValue != -1) {
      setState(() {
        _inititalValue = this.widget.itemList.firstWhere((e) =>
            (e!['value'].toString() == this.widget.initialValue.toString()))!;
      });
    }

    if (this.widget.controller!.data == null) {
      _textcontroller.text = _inititalValue['text'];
      this.widget.controller!.data = _inititalValue;
      this.widget.controller!.value = _inititalValue['value'].toString() == '-1'
          ? ''
          : _inititalValue['value'].toString();
    } else {
      setState(() {
        _inititalValue = this.widget.controller!.data!;
      });
      _textcontroller.text = this.widget.controller!.data!['text'];
    }
  }

  @override
  void dispose() {
    super.dispose();
    _textcontroller.dispose();
    _focusNode.dispose();
  }

  void clear() {
    this.widget.controller!.data = null;
    this.widget.controller!.value = '';
    _textcontroller.clear();
    _focusNode.unfocus();
  }

  @override
  Widget build(BuildContext context) {
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
          onTap: () {
            showGeneralDialog(
              barrierDismissible: false,
              barrierLabel:
                  MaterialLocalizations.of(context).modalBarrierDismissLabel,
              barrierColor: Colors.black45,
              transitionDuration: const Duration(milliseconds: 200),
              context: context,
              pageBuilder: (BuildContext context, Animation<double> animation,
                      Animation<double> secondaryAnimation) =>
                  CustomSingleDropdownList(
                key: Key(this.widget.hintText),
                itemList: this.widget.itemList,
                initialValue: _inititalValue,
                showAllEnable: this.widget.showAllEnable,
                onSelected: (value) {
                  this.widget.controller!.data = value;
                  this.widget.controller!.value =
                      value['value'].toString() == '-1'
                          ? ''
                          : value['value'].toString();
                  _inititalValue = value;
                  _textcontroller.text = value['text'];
                  if (this.widget.onChange != null) this.widget.onChange!();
                },
              ),
            );
          },
          controller: _textcontroller,
          focusNode: _focusNode,
          enabled: this.widget.enable,
          showCursor: false,
          readOnly: true,
          style: TextStyle(
            color: txtSecondColor,
            fontSize: SizeConfig.getWidthSize(this.widget.size + 1.7),
          ),
          textAlignVertical: TextAlignVertical.center,
          decoration: this.widget.showIconLabel
              ? _showIconLabel()
              : InputDecoration(
                  suffixIcon: Icon(
                    Icons.arrow_drop_down,
                    color: txtSecondColor,
                  ),
                  focusedBorder: border,
                  border: border,
                  contentPadding: EdgeInsets.symmetric(
                    vertical: SizeConfig.getWidthSize(this.widget.size + 1),
                    horizontal: SizeConfig.getWidthSize(this.widget.size),
                  ),
                  filled: true,
                  fillColor: this.widget.enable ? Colors.white : kDarkColor,
                  hintText: this.widget.hintText,
                  hintStyle: TextStyle(
                    fontSize: SizeConfig.getWidthSize(this.widget.size + 1.7),
                    fontWeight: FontWeight.bold,
                    color: txtSecondColor,
                  ),
                ),
        ),
      ),
    );
  }

  InputDecoration _showIconLabel() {
    return InputDecoration(
      prefixIcon: this.widget.icon,
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
      fillColor: this.widget.enable ? Colors.white : kDarkColor,
      labelText: this.widget.hintText,
      labelStyle: TextStyle(
        fontSize: SizeConfig.getWidthSize(widget.size + 1.7),
        fontWeight: FontWeight.bold,
        color: txtSecondColor,
      ),
    );
  }
}
