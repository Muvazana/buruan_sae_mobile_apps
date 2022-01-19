import 'package:buruan_sae_apps/screen/components/widgets/custom_icon_button.dart';
import 'package:buruan_sae_apps/utils/const_color.dart';
import 'package:buruan_sae_apps/utils/size_config.dart';
import 'package:flutter/material.dart';
import 'package:flutter_speed_dial/flutter_speed_dial.dart';

import 'build_modal_bottom_sheet.dart';

class ListMenuLayout extends StatefulWidget {
  final String menuName;
  final Widget? child;
  final List? listData;
  final Function? onBack, onFilterApplied, onAddTapped, onDraftTapped;
  final bool isDraft;

  const ListMenuLayout({
    Key? key,
    this.menuName = "",
    this.child,
    this.onBack,
    this.onFilterApplied,
    this.onAddTapped,
    this.onDraftTapped,
    this.listData,
    this.isDraft = false,
  }) : super(key: key);

  @override
  _ListMenuLayoutState createState() => _ListMenuLayoutState();
}

class _ListMenuLayoutState extends State<ListMenuLayout> {
  @override
  Widget build(BuildContext context) {
    SizeConfig().init(context);
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        elevation: 0,
        title: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: <Widget>[
            CustomIconButton(
              icon: Icon(Icons.arrow_back),
              isCircular: false,
              iconColor: txtSecondColor,
              onPressed: widget.onBack,
            ),
            Text(widget.menuName),
            CustomIconButton(
              icon: Icon(Icons.filter_list),
              isCircular: false,
              iconColor: txtSecondColor,
              onPressed: () => showModalBottomSheet(
                isScrollControlled: true,
                backgroundColor: kLight1Color,
                shape: RoundedRectangleBorder(
                    borderRadius:
                        BorderRadius.vertical(top: Radius.circular(30))),
                context: context,
                builder: (context) => BuildModalBottomSheet(
                  this.widget.onFilterApplied,
                  listData: this.widget.listData,
                ),
              ),
            ),
          ],
        ),
      ),
      body: Container(
        width: SizeConfig.screenWidth,
        height: SizeConfig.screenHeight,
        child: Stack(
          children: <Widget>[
            Container(
              width: double.infinity,
              height: SizeConfig.getHeightSize(10),
              decoration: BoxDecoration(
                color: kPrimaryColor,
                borderRadius: BorderRadius.only(
                  bottomLeft: Radius.circular(45),
                  bottomRight: Radius.circular(4),
                ),
              ),
            ),
            Container(
              width: double.infinity,
              height: double.infinity,
              child: widget.child,
            ),
          ],
        ),
      ),
      floatingActionButton: _speedDial(),
    );
  }

  SpeedDial _speedDial() {
    return SpeedDial(
      backgroundColor: kPrimaryColor,
      buttonSize: SizeConfig.getWidthSize(13),
      animatedIcon: AnimatedIcons.menu_close,
      animatedIconTheme: IconThemeData(
          size: SizeConfig.getWidthSize(8), color: txtPrimaryColor),
      // onOpen: () => print("Dial Open"),
      // onClose: () => print("Dial Close"),
      children: [
        SpeedDialChild(
          backgroundColor: kPrimaryColor,
          child: Icon(Icons.edit, color: txtPrimaryColor),
          label: "Add Report",
          labelBackgroundColor: kPrimaryColor,
          labelStyle: TextStyle(color: txtPrimaryColor),
          onTap: widget.onAddTapped as void Function()?,
        ),
        SpeedDialChild(
          backgroundColor: this.widget.isDraft ? errMessage : kPrimaryColor,
          child: Icon(Icons.drafts, color: txtPrimaryColor),
          label: this.widget.isDraft ? "Draft Off" : "Draft On",
          labelBackgroundColor: this.widget.isDraft ? errMessage : kPrimaryColor,
          labelStyle: TextStyle(color: txtPrimaryColor),
          onTap: widget.onDraftTapped as void Function()?,
        )
      ],
    );
  }
}
