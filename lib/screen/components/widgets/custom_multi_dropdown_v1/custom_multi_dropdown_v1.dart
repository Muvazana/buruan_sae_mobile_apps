import 'package:buruan_sae_apps/utils/const_color.dart';
import 'package:buruan_sae_apps/utils/size_config.dart';
import 'package:flutter/material.dart';

import 'multi_dropdown_modal_layout_v1.dart';

class CustomMultiDropdownV1Controller {
  String value = '';
  List<Map<String, dynamic>>? data;

  void dispose() {
    value = '';
    data = null;
  }
}

class CustomMultiDropdownV1 extends StatefulWidget {
  final CustomMultiDropdownV1Controller? controller;
  final double size;
  final String hintText;
  final Color filledColor;
  final bool enable;
  final Function? onChange;
  final List<Map<String, dynamic>> itemList;
  final List<int> initialValue;
  CustomMultiDropdownV1({
    Key? key,
    this.controller,
    this.size = 3,
    this.filledColor = Colors.white,
    this.enable = true,
    this.onChange,
    required this.itemList,
    List<int>? initialValue,
    this.hintText = 'Hint',
  }) : initialValue = initialValue ?? [], super(key: key);

  @override
  _CustomMultiDropdownV1State createState() => _CustomMultiDropdownV1State();
}

class _CustomMultiDropdownV1State extends State<CustomMultiDropdownV1> {
  final border = UnderlineInputBorder(
    borderRadius: BorderRadius.all(Radius.circular(10)),
    borderSide: BorderSide(
      color: Colors.transparent,
    ),
  );

  late TextEditingController _textcontroller;
  List<Map<String, dynamic>> _inititalValue = [];

  _setText(List<Map<String, dynamic>> list) {
    var str = '';
    for (var i = 0; i < list.length; i++) {
      str += list[i]['text'];
      if (i < list.length - 1) str += ' - ';
    }
    _textcontroller.text = str;
  }

  @override
  void initState() {
    super.initState();
    _textcontroller = TextEditingController();
    if (this.widget.initialValue.length > 0) {
      setState(() {
        for (var i in this.widget.initialValue) {
          _inititalValue.add(this
              .widget
              .itemList
              .firstWhere((e) => (e['value'].toString() == i.toString())));
        }
      });
    }
    if (this.widget.controller!.data == null) {
      setState(() {
        _setText(_inititalValue);
      });
      this.widget.controller!.data = _inititalValue;
      this.widget.controller!.value = _inititalValue.length > 0
          ? _inititalValue.map((e) => e['value']).toList().toString()
          : '';
    } else {
      setState(() {
        _inititalValue = this.widget.controller!.data!;
        _setText(this.widget.controller!.data!);
      });
    }
  }

  @override
  void dispose() {
    super.dispose();
    _textcontroller.dispose();
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
                  CustomMultiDropdownList(
                itemList: this.widget.itemList,
                initialValue: _inititalValue,
                onSelected: (value) async {
                  this.widget.controller!.data = value;
                  this.widget.controller!.value = value.length > 0
                      ? value.map((e) => e['value']).toList().toString()
                      : '';
                  _inititalValue = value;
                  _setText(value);
                },
              ),
            );
          },
          controller: _textcontroller,
          onChanged: (value) => this.widget.onChange!(),
          enabled: this.widget.enable,
          showCursor: false,
          readOnly: true,
          style: TextStyle(
            color: txtSecondColor,
            fontSize: SizeConfig.getWidthSize(this.widget.size + 1.7),
          ),
          textAlignVertical: TextAlignVertical.center,
          decoration: InputDecoration(
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
            fillColor:
                this.widget.enable ? this.widget.filledColor : kDarkColor,
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
}
