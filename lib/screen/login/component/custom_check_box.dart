import 'package:buruan_sae_apps/utils/const_color.dart';
import 'package:flutter/material.dart';

class CustomCheckBox extends StatefulWidget {
  final String label;
  final double width, height;
  final Function onChange;

  const CustomCheckBox(
      {Key? key,
      required this.onChange,
      required this.label,
      required this.width,
      required this.height})
      : super(key: key);
  @override
  _CustomCheckBoxState createState() => _CustomCheckBoxState();
}

class _CustomCheckBoxState extends State<CustomCheckBox> {
  bool _isRemember = false;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        setState(() {
          _isRemember = !_isRemember;
          widget.onChange(_isRemember);
        });
      },
      child: Row(
        mainAxisAlignment: MainAxisAlignment.start,
        mainAxisSize: MainAxisSize.max,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Container(
            width: widget.width,
            height: widget.height,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(30),
              border: Border.all(width: 1, color: Colors.black),
              color: Colors.transparent,
            ),
            child: Padding(
              padding: EdgeInsets.all(1),
              child: Container(
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(30),
                  color: _isRemember ? kPrimaryColor : Colors.transparent,
                ),
              ),
            ),
          ),
          SizedBox(width: 8),
          Text(
            widget.label,
            style: TextStyle(
              color: kPrimaryColor,
              fontSize: widget.width,
            ),
          )
        ],
      ),
    );
  }
}
