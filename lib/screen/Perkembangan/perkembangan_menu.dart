import 'dart:convert';

import 'package:buruan_sae_apps/model/notif_msg.dart';
import 'package:buruan_sae_apps/model/penyuluhan.dart';
import 'package:buruan_sae_apps/model/perkembangan.dart';
import 'package:buruan_sae_apps/model/wilayah.dart';
import 'package:buruan_sae_apps/screen/Perkembangan/form_create_perkembangan.dart';
import 'package:buruan_sae_apps/screen/components/list_menu/list_menu_layout.dart';
import 'package:buruan_sae_apps/screen/components/widgets/custom_list_menu_tile_v1.dart';
import 'package:buruan_sae_apps/screen/components/widgets/custom_progress_dialog.dart';
import 'package:buruan_sae_apps/screen/components/widgets/custom_snackbar_v1.dart';
import 'package:buruan_sae_apps/screen/dashboard/dashboard.dart';
import 'package:buruan_sae_apps/utils/api/auth.dart';
import 'package:buruan_sae_apps/utils/const_color.dart';
import 'package:buruan_sae_apps/utils/db/buruan_sae_database.dart';
import 'package:buruan_sae_apps/utils/db/db_helper.dart';
import 'package:buruan_sae_apps/utils/api/audit.dart';
import 'package:buruan_sae_apps/utils/api/penyuluhan.dart';
import 'package:buruan_sae_apps/utils/service/internet_service.dart';
import 'package:buruan_sae_apps/utils/size_config.dart';
import 'package:data_connection_checker/data_connection_checker.dart';
import 'package:flutter/material.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:intl/intl.dart';
import 'package:modal_progress_hud/modal_progress_hud.dart';
import 'package:buruan_sae_apps/utils/string_extension.dart';

// ignore: must_be_immutable
class PerkembanganMenu extends StatefulWidget {
  static const routeName = '/Dashboard/PerkembanganMenu';
  late bool isDraft;
  PerkembanganMenu({
    Key? key,
    this.isDraft = false,
  }) : super(key: key);

  @override
  _PerkembanganMenuState createState() => _PerkembanganMenuState();
}

class _PerkembanganMenuState extends State<PerkembanganMenu> {
  String _menuName = "";
  NotifMessageModel _notifMessageModel = new NotifMessageModel();

  List<AuditModel>? itemList;
  List<AuditModel>? filteredItemList = [];

  Future<Null> _refresh() async {
    CustomProgressDialog.show();
    if (this.widget.isDraft) {
      await BuruanSaeDatabase.instance.showAllAuditFromSqflite().then((data) {
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
      await AuditAPI.getAuditReportsFromServer().then((value) {
        if (value.getSuccess) {
          setState(() {
            itemList = value.getData as List<AuditModel>?;
            filteredItemList = value.getData as List<AuditModel>?;
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

  Future<Null> _changeState() async {
    if (this.widget.isDraft) {
      setState(() {
        _menuName = "Draft Perkembangan";
      });
    } else {
      setState(() {
        _menuName = "Perkembangan";
      });
    }
    await _refresh();
  }

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance!
        .addPostFrameCallback((_) => _changeState());
  }

  _deleteDraftItemList(index) async {
    var _id = filteredItemList![index].audit_id!;
    CustomProgressDialog.show();
    setState(() {
      filteredItemList!.removeAt(index);
    });
    final status = await BuruanSaeDatabase.instance.deleteAuditRecordById(_id);
    CustomProgressDialog.dismiss();
    if (status > 0)
      CustomSnackbarV1.showSnackbar(
          context, 'Report Perkembangan Berhasil di Hapus!');
    else {
      CustomSnackbarV1.showSnackbar(
          context, 'Report Perkembangan Gagal di Hapus!');
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
            await Navigator.pushNamed(context, FormCreatePerkembangan.routeName)
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
                        key: Key(filteredItemList![index].audit_id.toString()),
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

  Widget _listTileBind(AuditModel auditModel) {
    return CustomListTileV1(
      key: Key(auditModel.audit_id.toString()),
      value: auditModel,
      groupName: auditModel.kelompok!.nama_kelompok.toString(),
      kelurahan: auditModel.kelurahan!.nama_kelurahan.toString(),
      kecamatan: auditModel.kelurahan!.kecamatan!.nama_kecamatan.toString(),
      bulan: DateTime.parse(auditModel.date).month.toString(),
      tahun: DateTime.parse(auditModel.date).year.toString(),
      onTap: (AuditModel? value) async {
        if (this.widget.isDraft) {
          this.widget.isDraft = await Navigator.pushNamed(
                  context, FormCreatePerkembangan.routeName,
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
            builder: (context) =>
                _perkembanganDetailModalBottom(context, value),
          );
        }
      },
    );
  }

  Widget _perkembanganDetailModalBottom(
      BuildContext context, AuditModel auditModel) {
    SizeConfig().init(context);
    var _sizeTxtJudul = 6.5;
    var _sizeTxtSubJudul = 5.0;
    var _sizeText = 4.0;
    var datePenyuluhan =
        DateFormat('dd MMMM yyyy').format(DateTime.parse(auditModel.date));

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
                Text(
                  auditModel.kelompok!.nama_kelompok,
                  style: TextStyle(
                      color: kPrimaryColor,
                      fontSize: SizeConfig.getWidthSize(_sizeTxtJudul),
                      fontWeight: FontWeight.bold),
                ),
                _detailtextBottomModal(
                  auditModel.kelurahan!.nama_kelurahan +
                      " / " +
                      auditModel.kelurahan!.kecamatan!.nama_kecamatan,
                  _sizeText,
                  isBold: true,
                ),
                _detailtextBottomModal(datePenyuluhan, _sizeText),
                _detailtxtSubJudulBottomModal(
                    'Jenis Komoditas', _sizeTxtSubJudul),
                for (var item in auditModel.komoditas!)
                  _detailtextBottomModal(item.nama_komoditas!, _sizeText),
                _detailtxtSubJudulBottomModal('Tanam', _sizeTxtSubJudul),
                _detailtextBottomModal(
                    DateFormat('dd MMMM yyyy')
                        .format(DateTime.parse(auditModel.date_tanam!)),
                    _sizeText),
                _detailTextWithBottomModal(
                    auditModel.luas_vol_tanam!.isNotEmpty
                        ? auditModel.luas_vol_tanam!
                        : '0',
                    " Luas/Vol/(Ha.)/...",
                    _sizeText),
                _detailtxtSubJudulBottomModal('Panen', _sizeTxtSubJudul),
                _detailtextBottomModal(
                    DateFormat('dd MMMM yyyy')
                        .format(DateTime.parse(auditModel.date_panen!)),
                    _sizeText),
                _detailTextWithBottomModal(
                    auditModel.luas_vol_panen!.isNotEmpty
                        ? auditModel.luas_vol_panen!
                        : '0',
                    " Ha.",
                    _sizeText),
                _detailTextWithBottomModal(
                    auditModel.provitas_panen!.isNotEmpty
                        ? auditModel.provitas_panen!
                        : '0',
                    " Ku/Ha",
                    _sizeText),
                _detailTextWithBottomModal(
                    auditModel.produksi_panen!.isNotEmpty
                        ? auditModel.produksi_panen!
                        : '0',
                    " Ton",
                    _sizeText),
                _detailtxtSubJudulBottomModal(
                    'Pengelolahan / Pemasaran Hasil', _sizeTxtSubJudul),
                _detailtextBottomModal(
                    DateFormat('dd MMMM yyyy')
                        .format(DateTime.parse(auditModel.date_pengolahan!)),
                    _sizeText),
                _detailTextWithBottomModal(
                    auditModel.vol_pengolahan!.isNotEmpty
                        ? auditModel.vol_pengolahan!
                        : '0',
                    " kg/Ku/...",
                    _sizeText),
                _detailtextBottomModal(
                    'Rp. ' +
                        (auditModel.total_nilai_harga!.isNotEmpty
                            ? auditModel.total_nilai_harga!
                            : '0'),
                    _sizeText),
                _detailtxtSubJudulBottomModal('Keterangan', _sizeTxtSubJudul),
                _detailtextBottomModal(
                    auditModel.keterangan!.isNotEmpty
                        ? auditModel.keterangan!
                        : '-',
                    _sizeText),
              ],
            ),
          )
        ],
      ),
    );
  }

  Widget _detailtxtSubJudulBottomModal(String text, double size,
      {double paddingTop = 16.0}) {
    return Padding(
      padding: EdgeInsets.only(top: paddingTop),
      child: Text(
        text,
        style: TextStyle(
          color: txtSecondColor,
          fontSize: SizeConfig.getWidthSize(size),
          fontWeight: FontWeight.bold,
        ),
      ),
    );
  }

  Widget _detailtextBottomModal(String text, double size,
      {bool isBold = false, double paddingTop = 2.0}) {
    return Padding(
      padding: EdgeInsets.only(top: paddingTop),
      child: Text(
        text,
        style: TextStyle(
          color: txtSecondColor,
          fontSize: SizeConfig.getWidthSize(size),
          fontWeight: isBold ? FontWeight.bold : FontWeight.normal,
        ),
      ),
    );
  }

  Widget _detailTextWithBottomModal(String text, String satuan, double size,
      {double paddingTop = 2.0}) {
    return Padding(
      padding: EdgeInsets.only(top: paddingTop),
      child: Row(
        mainAxisSize: MainAxisSize.max,
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: <Widget>[
          Text(
            text,
            style: TextStyle(
              color: txtSecondColor,
              fontSize: SizeConfig.getWidthSize(size),
            ),
          ),
          Text(
            satuan,
            style: TextStyle(
              color: txtSecondColor,
              fontSize: SizeConfig.getWidthSize(size),
            ),
          ),
        ],
      ),
    );
  }
}
