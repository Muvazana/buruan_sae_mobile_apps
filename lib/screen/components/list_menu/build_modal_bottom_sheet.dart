import 'dart:convert';

import 'package:buruan_sae_apps/screen/components/widgets/custom_rounded_button.dart';
import 'package:buruan_sae_apps/screen/components/widgets/custom_single_dropdown_v1/custom_single_dropdown_v1.dart';
import 'package:buruan_sae_apps/utils/const_color.dart';
import 'package:buruan_sae_apps/utils/size_config.dart';
import 'package:chips_choice/chips_choice.dart';
import 'package:flutter/material.dart';

class BuildModalBottomSheet extends StatefulWidget {
  final Function? onApplied;
  final List? listData;
  BuildModalBottomSheet(this.onApplied, {this.listData});

  @override
  _BuildModalBottomSheetState createState() => _BuildModalBottomSheetState();
}

class _BuildModalBottomSheetState extends State<BuildModalBottomSheet> {
  CustomSingleDropdownV1Controller? _tahunController,
      _kecamatanController,
      _kelurahanController;

  List<Map<String, dynamic>?> yearList = [];
  List<Map<String, dynamic>?> kecamatanList = [];
  List<Map<String, dynamic>?> kelurahanList = [];

  List<Map<String, dynamic>?> _tahunListDistictProcess(List item) {
    final jsonList = item
        .map((e) => jsonEncode({
              'value': DateTime.parse(e.date).year.toString(),
              'text': DateTime.parse(e.date).year.toString()
            }))
        .toList();
    final uniqueJsonList = jsonList.toSet().toList();
    return uniqueJsonList
        .map<Map<String, dynamic>?>((item) => jsonDecode(item))
        .toList()
          ..sort((a, b) => (a!['text'].compareTo(b!['text'])));
  }

  List<Map<String, dynamic>?> _kecamatanListDistictProcess(List item) {
    final jsonList = item
        .map((e) => jsonEncode({
              'value': e.kelurahan.kecamatan.kecamatan_id,
              'text': e.kelurahan.kecamatan.nama_kecamatan.toString()
            }))
        .toList();
    final uniqueJsonList = jsonList.toSet().toList();
    return uniqueJsonList
        .map<Map<String, dynamic>?>((item) => jsonDecode(item))
        .toList()
          ..sort((a, b) => (a!['text'].compareTo(b!['text'])));
  }

  List<Map<String, dynamic>?> _kelurahanListDistictProcess(List item) {
    final jsonList = item
        .map((e) => jsonEncode({
              'value': e.kelurahan.kelurahan_id,
              'text': e.kelurahan.nama_kelurahan.toString()
            }))
        .toList();
    final uniqueJsonList = jsonList.toSet().toList();
    return uniqueJsonList
        .map<Map<String, dynamic>?>((item) => jsonDecode(item))
        .toList()
          ..sort((a, b) => (a!['text'].compareTo(b!['text'])));
  }

  _onKematanSelected(query, List item) {
    final itemFiltered = item
        .where((e) => (query.toString().isNotEmpty
            ? e.kelurahan.kecamatan.kecamatan_id.toString() == query.toString()
            : true))
        .toList();
    setState(() {
      kelurahanList = _kelurahanListDistictProcess(itemFiltered);
    });
  }

  @override
  void initState() {
    super.initState();
    yearList = _tahunListDistictProcess(this.widget.listData!);
    kecamatanList = _kecamatanListDistictProcess(this.widget.listData!);
    _tahunController = CustomSingleDropdownV1Controller();
    _kecamatanController = CustomSingleDropdownV1Controller();
    _kelurahanController = CustomSingleDropdownV1Controller();
  }

  @override
  void dispose() {
    super.dispose();
    _tahunController!.dispose();
    _kecamatanController!.dispose();
    _kelurahanController!.dispose();
  }

  static List<String> bulan = [
    'Show All',
    'Januari',
    'Februari',
    'Maret',
    'April',
    'Mei',
    'Juni',
    'Juli',
    'Agustus',
    'September',
    'Oktober',
    'November',
    'Desember',
  ];

  bool _enableKelurahan = false;

  int _bulanValue = 0;

  @override
  Widget build(BuildContext context) {
    SizeConfig().init(context);
    return Container(
      padding: EdgeInsets.symmetric(vertical: 20, horizontal: 15),
      height: SizeConfig.getHeightSize(90),
      child: Column(
        mainAxisSize: MainAxisSize.max,
        children: <Widget>[
          Container(
            height: 5,
            width: SizeConfig.getWidthSize(15),
            decoration: BoxDecoration(
                color: Color(0xFF292E31),
                borderRadius: BorderRadius.circular(5)),
          ),
          SizedBox(height: SizeConfig.getHeightSize(5)),
          Expanded(
            child: ListView(
              shrinkWrap: true,
              children: <Widget>[
                Text(
                  "Bulan",
                  style: TextStyle(
                    fontSize: SizeConfig.getWidthSize(5),
                    fontWeight: FontWeight.bold,
                    color: txtSecondColor,
                  ),
                ),
                _customSingleChipChoice(
                  value: _bulanValue,
                  onChanged: (value) {
                    setState(() {
                      _bulanValue = value;
                    });
                  },
                  itemsList: bulan,
                ),
                SizedBox(height: 16),
                CustomSingleDropdownV1(
                  hintText: "Tahun",
                  itemList: yearList,
                  controller: _tahunController,
                  showAllEnable: true,
                  showIconLabel: true,
                ),
                SizedBox(height: 16),
                CustomSingleDropdownV1(
                  hintText: "Kecamatan",
                  itemList: kecamatanList,
                  controller: _kecamatanController,
                  showAllEnable: true,
                  showIconLabel: true,
                  onChange: () {
                    _onKematanSelected(
                        _kecamatanController!.value, this.widget.listData!);
                    _kelurahanController!.clear!();
                    setState(() {
                      if (!_enableKelurahan) _enableKelurahan = true;
                    });
                  },
                ),
                SizedBox(height: 16),
                CustomSingleDropdownV1(
                  hintText: "Kelurahan",
                  itemList: kelurahanList,
                  controller: _kelurahanController,
                  enable: _enableKelurahan,
                  showAllEnable: true,
                  showIconLabel: true,
                ),
              ],
            ),
          ),
          SizedBox(height: 16),
          CustomRoundedButton(
            text: "Apply Filter",
            borderRadius: 35,
            onPressed: () {
              this.widget.onApplied!(
                  _bulanValue.toString(),
                  _tahunController!.value.toString(),
                  _kecamatanController!.value.toString(),
                  _kelurahanController!.value.toString());
            },
          ),
          SizedBox(height: 16),
          CustomRoundedButton(
            text: "Cancel",
            color: kPrimaryColor,
            backgroundColor: kLight2Color,
            borderRadius: 35,
            onPressed: () {
              Navigator.of(context).pop();
            },
          ),
          SizedBox(height: 20),
        ],
      ),
    );
  }
}

Widget _customSingleChipChoice(
    {int? value, Function? onChanged, required List<String> itemsList}) {
  return ChipsChoice.single(
    value: value,
    padding: EdgeInsets.zero,
    onChanged: (dynamic value) => onChanged!(value),
    choiceItems: C2Choice.listFrom(
      source: itemsList,
      value: (i, dynamic v) => i,
      label: (i, dynamic v) => v,
    ),
    wrapped: true,
    choiceStyle: C2ChoiceStyle(
      color: Color(0xFFDADADA),
      labelStyle: TextStyle(color: txtSecondColor),
      brightness: Brightness.dark,
    ),
    choiceActiveStyle: C2ChoiceStyle(
      color: kPrimaryColor,
      labelStyle: TextStyle(color: txtPrimaryColor),
    ),
  );
}
