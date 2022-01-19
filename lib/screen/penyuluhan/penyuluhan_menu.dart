import 'dart:convert';

import 'package:buruan_sae_apps/model/notif_msg.dart';
import 'package:buruan_sae_apps/model/penyuluhan.dart';
import 'package:buruan_sae_apps/model/wilayah.dart';
import 'package:buruan_sae_apps/screen/components/list_menu/list_menu_layout.dart';
import 'package:buruan_sae_apps/screen/components/widgets/custom_list_menu_tile_v1.dart';
import 'package:buruan_sae_apps/screen/components/widgets/custom_progress_dialog.dart';
import 'package:buruan_sae_apps/screen/components/widgets/custom_snackbar_v1.dart';
import 'package:buruan_sae_apps/screen/dashboard/dashboard.dart';
import 'package:buruan_sae_apps/utils/api/auth.dart';
import 'package:buruan_sae_apps/utils/const_color.dart';
import 'package:buruan_sae_apps/utils/db/buruan_sae_database.dart';
import 'package:buruan_sae_apps/utils/db/db_helper.dart';
import 'package:buruan_sae_apps/utils/api/penyuluhan.dart';
import 'package:buruan_sae_apps/utils/service/internet_service.dart';
import 'package:buruan_sae_apps/utils/size_config.dart';
import 'package:data_connection_checker/data_connection_checker.dart';
import 'package:flutter/material.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:intl/intl.dart';
import 'package:modal_progress_hud/modal_progress_hud.dart';
import 'package:buruan_sae_apps/utils/string_extension.dart';

import 'form_create_penyuluhan.dart';

// ignore: must_be_immutable
class PenyuluhanMenu extends StatefulWidget {
  static const routeName = '/Dashboard/PenyuluhanMenu';
  late bool isDraft;
  PenyuluhanMenu({
    Key? key,
    this.isDraft = false,
  }) : super(key: key);

  @override
  _PenyuluhanMenuState createState() => _PenyuluhanMenuState();
}

class _PenyuluhanMenuState extends State<PenyuluhanMenu> {
  String _menuName = "";
  NotifMessageModel _notifMessageModel = new NotifMessageModel();

  List<PenyuluhanModel>? itemList;
  List<PenyuluhanModel>? filteredItemList = [];

  Future<Null> _refresh() async {
    CustomProgressDialog.show();
    if (this.widget.isDraft) {
      await BuruanSaeDatabase.instance
          .showAllPenyuluhanFromSqflite()
          .then((data) {
        setState(() {
          itemList = data;
          filteredItemList = data;
        });

        CustomProgressDialog.dismiss();
      });
      if (filteredItemList!.length == 0) {
        _notifMessageModel.setSuccess = false;
        _notifMessageModel.setMessage = 'No Data Entry';
      } else {
        _notifMessageModel.setSuccess = true;
        _notifMessageModel.setMessage = '';
      }
    } else {
      await PenyuluhanAPI.getPenyuluhanReportsFromServer().then((value) {
        if (value.getSuccess) {
          setState(() {
            itemList = value.getData as List<PenyuluhanModel>?;
            filteredItemList = value.getData as List<PenyuluhanModel>?;
          });
          if (filteredItemList!.length == 0) {
            _notifMessageModel.setSuccess = false;
            _notifMessageModel.setMessage = 'No Data Entry';
          } else {
            _notifMessageModel.setSuccess = true;
            _notifMessageModel.setMessage = '';
          }
        } else {
          _notifMessageModel.setSuccess = false;
          _notifMessageModel.setMessage = value.getMessage;
        }
        CustomProgressDialog.dismiss();
        // ExtendLoginTime.restart();
      });
    }
  }

  _changeState() {
    if (this.widget.isDraft) {
      setState(() {
        _menuName = "Draft Penyuluhan";
      });
    } else {
      setState(() {
        _menuName = "Penyuluhan";
      });
    }
    _refresh();
  }

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance!
        .addPostFrameCallback((_) => _changeState());
  }

  _deleteDraftItemList(index) async {
    var _id = filteredItemList![index].penyuluhan_id!;
    CustomProgressDialog.show();
    setState(() {
      filteredItemList!.removeAt(index);
    });
    final status =
        await BuruanSaeDatabase.instance.deletePenyuluhanRecordById(_id);
    CustomProgressDialog.dismiss();
    if (status > 0)
      CustomSnackbarV1.showSnackbar(
          context, 'Report Penyuluhan Berhasil di Hapus!');
    else {
      CustomSnackbarV1.showSnackbar(
          context, 'Report Penyuluhan Gagal di Hapus!');
      _changeState();
    }
  }

  @override
  Widget build(BuildContext context) {
    SizeConfig().init(context);
    return ListMenuLayout(
      menuName: _menuName,
      onBack: () async {
        Navigator.of(context).pop();
      },
      onAddTapped: () async {
        this.widget.isDraft =
            await Navigator.pushNamed(context, FormCreatePenyuluhan.routeName)
                    as bool? ??
                this.widget.isDraft;
        _changeState();
      },
      isDraft: this.widget.isDraft,
      onDraftTapped: () {
        setState(() {
          this.widget.isDraft = !this.widget.isDraft;
        });
        _changeState();
      },
      listData: itemList,
      onFilterApplied: (bulan, tahun, kecamatan, kelurahan) {
        setState(() {
          filteredItemList = itemList!
              .where((element) =>
                  (bulan.toString() != '0'
                      ? DateTime.parse(element.date).month.toString() ==
                          bulan.toString()
                      : true) &&
                  (tahun.toString().isNotEmpty
                      ? DateTime.parse(element.date).year.toString() ==
                          tahun.toString()
                      : true) &&
                  (kecamatan.toString().isNotEmpty
                      ? element.kelurahan!.kecamatan!.kecamatan_id.toString() ==
                          kecamatan.toString()
                      : true) &&
                  (kelurahan.toString().isNotEmpty
                      ? element.kelurahan!.kelurahan_id.toString() ==
                          kelurahan.toString()
                      : true))
              .toList();
        });
        if (filteredItemList!.length == 0) {
          _notifMessageModel.setSuccess = false;
          _notifMessageModel.setMessage = 'No Data Entry';
        } else {
          _notifMessageModel.setSuccess = true;
          _notifMessageModel.setMessage = '';
        }
      },
      child: RefreshIndicator(
        onRefresh: _refresh,
        child: Container(
          width: double.infinity,
          height: double.infinity,
          child: !_notifMessageModel.getSuccess
              ? SingleChildScrollView(
                  physics: AlwaysScrollableScrollPhysics(),
                  child: Container(
                    height: SizeConfig.getHeightSize(85),
                    child: Center(
                      child: Text(
                        _notifMessageModel.getMessage,
                        style: TextStyle(
                          color: txtSecondColor,
                          fontWeight: FontWeight.bold,
                          fontSize: SizeConfig.getWidthSize(5),
                        ),
                      ),
                    ),
                  ),
                )
              : ListView.builder(
                  padding: EdgeInsets.all(16),
                  itemCount: !CustomProgressDialog.isOpen
                      ? filteredItemList!.length
                      : 0,
                  itemBuilder: (context, index) {
                    if (this.widget.isDraft) {
                      return Slidable(
                        key: Key(
                            filteredItemList![index].penyuluhan_id.toString()),
                        actionPane: SlidableStrechActionPane(),
                        dismissal: SlidableDismissal(
                          child: SlidableDrawerDismissal(),
                          onDismissed: (actionType) {
                            _deleteDraftItemList(index);
                          },
                        ),
                        actions: <Widget>[
                          IconSlideAction(
                            caption: 'Hapus',
                            color: errMessage,
                            icon: Icons.delete_forever,
                            onTap: () {
                              _deleteDraftItemList(index);
                            },
                          ),
                        ],
                        child: _listTileBind(filteredItemList![index]),
                      );
                    } else {
                      return _listTileBind(filteredItemList![index]);
                    }
                  },
                ),
        ),
      ),
    );
  }

  Widget _listTileBind(PenyuluhanModel penyuluhanModel) {
    return CustomListTileV1(
      value: penyuluhanModel,
      groupName: penyuluhanModel.kelompok!.nama_kelompok.toString(),
      kelurahan: penyuluhanModel.kelurahan!.nama_kelurahan.toString(),
      kecamatan:
          penyuluhanModel.kelurahan!.kecamatan!.nama_kecamatan.toString(),
      bulan: DateTime.parse(penyuluhanModel.date).month.toString(),
      tahun: DateTime.parse(penyuluhanModel.date).year.toString(),
      onTap: (PenyuluhanModel? value) async {
        if (this.widget.isDraft) {
          this.widget.isDraft = await Navigator.pushNamed(
                  context, FormCreatePenyuluhan.routeName,
                  arguments: value!) as bool? ??
              this.widget.isDraft;
          _changeState();
        } else {
          print("Show ${value!.kelompok!.nama_kelompok}");
          showModalBottomSheet(
            isScrollControlled: true,
            backgroundColor: kLight1Color,
            shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.vertical(top: Radius.circular(30))),
            context: context,
            builder: (context) => _penyuluhanDetailModalBottom(context, value),
          );
        }
      },
    );
  }

  Widget _penyuluhanDetailModalBottom(
      BuildContext context, PenyuluhanModel penyuluhanModel) {
    SizeConfig().init(context);
    var _sizeTxtJudul = 6.5;
    var _sizeTxtSubJudul = 5.0;
    var _sizeText = 4.0;
    var datePenyuluhan =
        DateFormat('dd MMMM yyyy').format(DateTime.parse(penyuluhanModel.date));

    return Container(
      padding: EdgeInsets.symmetric(vertical: 20, horizontal: 24),
      height: SizeConfig.getHeightSize(90),
      child: Column(
        mainAxisSize: MainAxisSize.max,
        crossAxisAlignment: CrossAxisAlignment.center,
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
              children: <Widget>[
                Row(
                  mainAxisSize: MainAxisSize.max,
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: <Widget>[
                    Text(
                      penyuluhanModel.kelompok!.nama_kelompok,
                      style: TextStyle(
                          color: kPrimaryColor,
                          fontSize: SizeConfig.getWidthSize(_sizeTxtJudul),
                          fontWeight: FontWeight.bold),
                    ),
                    Row(
                      mainAxisSize: MainAxisSize.min,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: <Widget>[
                        Text(
                          penyuluhanModel.jumlah_anggota.toString(),
                          style: TextStyle(
                            color: txtSecondColor,
                            fontSize: SizeConfig.getWidthSize(_sizeText),
                          ),
                        ),
                        SizedBox(width: 2),
                        Icon(
                          Icons.person,
                          size: SizeConfig.getWidthSize(_sizeText + 1),
                          color: txtSecondColor,
                        ),
                      ],
                    )
                  ],
                ),
                SizedBox(height: 2),
                Align(
                  alignment: Alignment.topLeft,
                  child: Column(
                    mainAxisSize: MainAxisSize.max,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[
                      _detailtextBottomModal(
                        penyuluhanModel.kelurahan!.nama_kelurahan +
                            " / " +
                            penyuluhanModel
                                .kelurahan!.kecamatan!.nama_kecamatan,
                        _sizeText,
                        isBold: true,
                      ),
                      SizedBox(height: 16),
                      Text(
                        penyuluhanModel.kegiatan.capitalize(),
                        overflow: TextOverflow.ellipsis,
                        maxLines: 2,
                        style: TextStyle(
                            color: txtSecondColor,
                            fontSize: SizeConfig.getWidthSize(_sizeTxtJudul),
                            fontWeight: FontWeight.bold),
                      ),
                      SizedBox(height: 2),
                      _detailtextBottomModal(datePenyuluhan, _sizeText),
                      SizedBox(height: 16),
                      _detailtxtSubJudulBottomModal('Sosial', _sizeTxtSubJudul),
                      SizedBox(height: 2),
                      _detailtextBottomModal(
                          penyuluhanModel.sosial!.isNotEmpty
                              ? penyuluhanModel.sosial!
                              : '-',
                          _sizeText),
                      SizedBox(height: 16),
                      _detailtxtSubJudulBottomModal('Teknis', _sizeTxtSubJudul),
                      SizedBox(height: 2),
                      _detailtextBottomModal(
                          penyuluhanModel.teknis!.isNotEmpty
                              ? penyuluhanModel.teknis!
                              : '-',
                          _sizeText),
                      SizedBox(height: 16),
                      _detailtxtSubJudulBottomModal(
                          'Ekonomi', _sizeTxtSubJudul),
                      SizedBox(height: 2),
                      _detailtextBottomModal(
                          penyuluhanModel.ekonomi!.isNotEmpty
                              ? penyuluhanModel.ekonomi!
                              : '-',
                          _sizeText),
                      SizedBox(height: 16),
                      _detailtxtSubJudulBottomModal(
                          'Masalah', _sizeTxtSubJudul),
                      SizedBox(height: 2),
                      _detailtextBottomModal(
                          penyuluhanModel.masalah!.isNotEmpty
                              ? penyuluhanModel.masalah!
                              : '-',
                          _sizeText),
                      SizedBox(height: 16),
                      _detailtxtSubJudulBottomModal(
                          'Pemecahan Masalah', _sizeTxtSubJudul),
                      SizedBox(height: 2),
                      _detailtextBottomModal(
                          penyuluhanModel.pemecahan_masalah!.isNotEmpty
                              ? penyuluhanModel.pemecahan_masalah!
                              : '-',
                          _sizeText),
                    ],
                  ),
                ),
              ],
            ),
          )
        ],
      ),
    );
  }

  Text _detailtxtSubJudulBottomModal(String text, double size) {
    return Text(
      text,
      style: TextStyle(
        color: txtSecondColor,
        fontSize: SizeConfig.getWidthSize(size),
        fontWeight: FontWeight.bold,
      ),
    );
  }

  Text _detailtextBottomModal(String text, double size, {bool isBold = false}) {
    return Text(
      text,
      style: TextStyle(
        color: txtSecondColor,
        fontSize: SizeConfig.getWidthSize(size),
        fontWeight: isBold ? FontWeight.bold : FontWeight.normal,
      ),
    );
  }
}
