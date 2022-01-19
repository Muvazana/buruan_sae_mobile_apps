import 'package:buruan_sae_apps/utils/const_color.dart';
import 'package:buruan_sae_apps/utils/size_config.dart';
import 'package:flutter/material.dart';

class CustomDateFormField extends StatefulWidget {
  final double size;
  final bool enable;
  final Function? onTap;
  final TextEditingController? controller;
  const CustomDateFormField({
    Key? key,
    this.size = 3,
    this.enable = true,
    this.onTap,
    required this.controller,
  }) : super(key: key);

  @override
  _CustomDateFormFieldState createState() => _CustomDateFormFieldState();
}

class _CustomDateFormFieldState extends State<CustomDateFormField> {
  DateTime? selectedDate;

  Future<void> _selectDate(BuildContext context) async {
    final DateTime? picked = await showDatePicker(
        context: context,
        initialDate: selectedDate!,
        firstDate: DateTime(DateTime.now().year - 20),
        lastDate: DateTime(DateTime.now().year + 20),
        builder: (BuildContext context, Widget? child) {
          return Theme(
            data: ThemeData.dark().copyWith(
              colorScheme: ColorScheme.dark(
                brightness: Brightness.light,
                primary: kPrimaryColor,
                onPrimary: Colors.white,
                surface: kPrimaryColor,
                onSurface: txtSecondColor,
              ),
              dialogBackgroundColor: kLight1Color,
            ),
            child: child!,
          );
        });
    if (picked != null && picked != selectedDate)
      setState(() {
        selectedDate = picked;
        this.widget.controller!.text = "${picked.toLocal()}".split(' ')[0];
      });
  }

  @override
  void initState() {
    super.initState();
    selectedDate = widget.controller!.text.isEmpty ? DateTime.now() : DateTime.parse(widget.controller!.text); //("${DateTime.now().toLocal()}".split(' ')[0] == widget.controller!.text) ? DateTime.now() : DateTime.parse(widget.controller!.text);
    this.widget.controller!.text = "${selectedDate!.toLocal()}".split(' ')[0];
  }

  @override
  Widget build(BuildContext context) {
    SizeConfig().init(context);
    return Container(
      decoration: BoxDecoration(
          color: widget.enable ? Colors.white : kDarkColor,
          borderRadius: BorderRadius.circular(10),
          border: Border.all(width: 1, color: Color(0xFFCCCCCC))),
      child: Scrollbar(
        child: TextField(
          onTap: () => _selectDate(context),
          readOnly: true,
          textAlignVertical: TextAlignVertical.center,
          enabled: widget.enable,
          controller: this.widget.controller,
          style: TextStyle(
            color: txtSecondColor,
            fontSize: SizeConfig.getWidthSize(this.widget.size + 1.7),
          ),
          decoration: InputDecoration(
            suffixIcon: Icon(Icons.date_range, color: txtSecondColor),
            contentPadding: EdgeInsets.symmetric(
              vertical: SizeConfig.getWidthSize(this.widget.size - 0.5),
              horizontal: SizeConfig.getWidthSize(this.widget.size),
            ),
            border: InputBorder.none,
          ),
        ),
      ),
    );
  }
}
