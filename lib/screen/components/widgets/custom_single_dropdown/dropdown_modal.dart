import 'package:buruan_sae_apps/screen/components/widgets/custom_rounded_button.dart';
import 'package:buruan_sae_apps/utils/const_color.dart';
import 'package:buruan_sae_apps/utils/size_config.dart';
import 'package:flutter/material.dart';

class CustomDropdownList extends StatelessWidget {
  final List<Map<String, dynamic>?>? itemList;
  final String btnText, btnValue;
  final Function onSelected;
  const CustomDropdownList({
    Key? key,
    required this.itemList,
    required this.onSelected,
    required this.btnText,
    required this.btnValue,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    SizeConfig().init(context);
    return WillPopScope(
      // ignore: missing_return
      onWillPop: () {} as Future<bool> Function()?,
      child: Center(
        child: Container(
          width: double.infinity,
          height: SizeConfig.getHeightSize(85),
          padding: EdgeInsets.all(16),
          decoration: BoxDecoration(
              color: kLight1Color, borderRadius: BorderRadius.circular(20)),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            mainAxisSize: MainAxisSize.max,
            children: <Widget>[
              Expanded(
                child: ListView.builder(
                  padding: EdgeInsets.only(top: 8),
                  itemCount: this.itemList!.length,
                  itemBuilder: (context, index) {
                    return Card(
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10.0),
                      ),
                      color: Colors.white,
                      child: ListTile(
                        key: Key(this.itemList![index]!['value'].toString()),
                        tileColor: Colors.transparent,
                        title: Text(
                          this.itemList![index]!['text'],
                          style: TextStyle(
                            fontSize: SizeConfig.getWidthSize(4.5),
                            fontWeight: FontWeight.bold,
                            color: kPrimaryColor
                          ),
                        ),
                        onTap: () {
                          this.onSelected(this.itemList![index]!['value'].toString(), this.itemList![index]!['text'].toString());
                          Navigator.pop(context);
                        },
                      ),
                    );
                  },
                ),
              ),
              SizedBox(height: SizeConfig.getHeightSize(2)),
              CustomRoundedButton(
                text: this.btnText,
                borderRadius: 35,
                onPressed: () {
                  // this.onSelected();
                  Navigator.pop(context);
                },
              )
            ],
          ),
        ),
      ),
    );
  }
}
