import 'package:buruan_sae_apps/utils/const_color.dart';
import 'package:buruan_sae_apps/utils/size_config.dart';
import 'package:flutter/material.dart';

import '../custom_rounded_button.dart';

class CustomSingleDropdownList extends StatefulWidget {
  final List<Map<String, dynamic>?> itemList;
  final Map<String, dynamic> initialValue;
  final Function(Map<String, dynamic>) onSelected;
  final bool showAllEnable;
  const CustomSingleDropdownList({
    Key? key,
    required this.itemList,
    required this.onSelected,
    required this.showAllEnable,
    required this.initialValue,
  }) : super(key: key);

  @override
  _CustomSingleDropdownListState createState() =>
      _CustomSingleDropdownListState();
}

class _CustomSingleDropdownListState extends State<CustomSingleDropdownList> {
  List<Map<String, dynamic>?> filteredList = [];
  Map<String, dynamic> _itemSelected = {};
  @override
  void initState() {
    super.initState();
    filteredList = this.widget.itemList;

    _itemSelected = this.widget.initialValue;
  }

  @override
  Widget build(BuildContext context) {
    SizeConfig().init(context);
    return Scaffold(
      key: this.widget.key,
      backgroundColor: Colors.transparent,
      resizeToAvoidBottomInset: false,
      body: WillPopScope(
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
                TextField(
                  style: TextStyle(
                      color: txtSecondColor,
                      fontSize: SizeConfig.getWidthSize(5)),
                  decoration: InputDecoration(
                      prefixIcon: Icon(Icons.search), hintText: 'Pencarian'),
                  onChanged: (value) {
                    setState(() {
                      filteredList = this
                          .widget
                          .itemList
                          .where((e) => e!['text'].toString().toLowerCase().contains(value.toLowerCase()))
                          .toList();
                    });
                  },
                ),
                SizedBox(height: 8),
                Expanded(
                  child: (filteredList.length == 0)
                      ? Center(
                          child: Text(
                            'Data tidak ditemukan!',
                            style: TextStyle(
                              color: txtSecondColor,
                              fontSize: SizeConfig.getWidthSize(5),
                            ),
                          ),
                        )
                      : ListView.builder(
                          padding: EdgeInsets.only(top: 8),
                          itemCount: filteredList.length,
                          itemBuilder: (context, index) {
                            return Card(
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(10.0),
                              ),
                              color: Colors.white,
                              child: ListTile(
                                key: Key(
                                    filteredList[index]!['value'].toString()),
                                tileColor: Colors.transparent,
                                title: Text(
                                  filteredList[index]!['text'].toString(),
                                  style: TextStyle(
                                    fontSize: SizeConfig.getWidthSize(4.5),
                                    fontWeight: FontWeight.bold,
                                    color: kPrimaryColor,
                                  ),
                                ),
                                trailing: Container(
                                  decoration: BoxDecoration(
                                      color: kLight2Color,
                                      borderRadius:
                                          BorderRadius.all(Radius.circular(2))),
                                  child: Icon(Icons.done,
                                      color:
                                          _itemSelected['value'].toString() ==
                                                  filteredList[index]!['value']
                                                      .toString()
                                              ? kPrimaryColor
                                              : Colors.transparent),
                                ),
                                onTap: () {
                                  setState(() {
                                    if (_itemSelected['value'] !=
                                        filteredList[index]!['value'])
                                      _itemSelected = filteredList[index]!;
                                  });
                                },
                              ),
                            );
                          },
                        ),
                ),
                if (this.widget.showAllEnable)
                  Padding(
                    padding: const EdgeInsets.only(top: 8),
                    child: Card(
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10.0),
                      ),
                      color: Colors.white,
                      child: ListTile(
                        key: Key('Show Aall'),
                        tileColor: Colors.transparent,
                        title: Text(
                          'Show All',
                          style: TextStyle(
                            fontSize: SizeConfig.getWidthSize(4.5),
                            fontWeight: FontWeight.bold,
                            color: kPrimaryColor,
                          ),
                        ),
                        trailing: Container(
                          decoration: BoxDecoration(
                              color: kLight2Color,
                              borderRadius:
                                  BorderRadius.all(Radius.circular(2))),
                          child: Icon(Icons.done,
                              color: _itemSelected['value'].toString() == '-1'
                                  ? kPrimaryColor
                                  : Colors.transparent),
                        ),
                        onTap: () {
                          setState(() {
                            if (_itemSelected['value'].toString() != '-1')
                              _itemSelected = {'value': -1, 'text': 'Show All'};
                          });
                        },
                      ),
                    ),
                  ),
                SizedBox(height: 8),
                CustomRoundedButton(
                  text: 'Done',
                  borderRadius: 35,
                  onPressed: () {
                    this.widget.onSelected(_itemSelected);
                    Navigator.pop(context);
                  },
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
