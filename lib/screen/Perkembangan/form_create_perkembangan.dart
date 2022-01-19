import 'dart:convert';

import 'package:buruan_sae_apps/model/kelompok.dart';
import 'package:buruan_sae_apps/model/komoditas.dart';
import 'package:buruan_sae_apps/model/perkembangan.dart';
import 'package:buruan_sae_apps/model/user.dart';
import 'package:buruan_sae_apps/model/wilayah.dart';
import 'package:buruan_sae_apps/screen/components/step_form/custom_step_form_layout.dart';
import 'package:buruan_sae_apps/screen/components/widgets/custom_date_form_field.dart';
import 'package:buruan_sae_apps/screen/components/widgets/custom_multi_dropdown_v1/custom_multi_dropdown_v1.dart';
import 'package:buruan_sae_apps/screen/components/widgets/custom_progress_dialog.dart';
import 'package:buruan_sae_apps/screen/components/widgets/custom_single_dropdown/custom_single_dropdown.dart';
import 'package:buruan_sae_apps/screen/components/widgets/custom_single_dropdown_v1/custom_single_dropdown_v1.dart';
import 'package:buruan_sae_apps/screen/components/widgets/custom_snackbar_v1.dart';
import 'package:buruan_sae_apps/screen/components/widgets/custom_text_form_field.dart';
import 'package:buruan_sae_apps/screen/dashboard/dashboard.dart';
import 'package:buruan_sae_apps/utils/const_color.dart';
import 'package:buruan_sae_apps/utils/constants.dart';
import 'package:buruan_sae_apps/utils/db/buruan_sae_database.dart';
import 'package:buruan_sae_apps/utils/api/audit.dart';
import 'package:buruan_sae_apps/utils/api/general_api.dart';
import 'package:buruan_sae_apps/utils/shared_pref.dart';
import 'package:buruan_sae_apps/utils/size_config.dart';
import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:modal_progress_hud/modal_progress_hud.dart';
import 'package:shared_preferences/shared_preferences.dart';

class FormCreatePerkembangan extends StatefulWidget {
  static const routeName = '/Dashboard/PerkembanganMenu/FormCreatePerkembangan';
  final AuditModel? draftData;

  const FormCreatePerkembangan({
    Key? key,
    this.draftData,
  }) : super(key: key);
  @override
  _FormCreatePerkembanganState createState() => _FormCreatePerkembanganState();
}

class _FormCreatePerkembanganState extends State<FormCreatePerkembangan> {
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();
  late CustomSingleDropdownV1Controller _kecamatanController,
      _kelurahanController,
      _kelompokController;
  late CustomMultiDropdownV1Controller _jenisKomoditasController;
  late TextEditingController _penyuluhController,
      _dateController,
      _dateTanamController,
      _luasTanamController,
      _datePanenController,
      _luasPanenController,
      _provitasPanenController,
      _produksiPanenController,
      _datePengolahanController,
      _volumPengolahanController,
      _nilaiPengolahanController,
      _keteranganController;

  bool _enableKelurahan = true, _enableKelompok = true;
  bool _clearKelompok = false;

  bool _requireKecamatan = false,
      _requireKelurahan = false,
      _requireKelompok = false,
      _requireKomoditas = false;

  bool _validateForm() {
    setState(() {
      _requireKecamatan = _kecamatanController.value.trim().isEmpty;
      _requireKelurahan = _kelurahanController.value.trim().isEmpty;
      _requireKelompok = _kelompokController.value.trim().isEmpty;
      _requireKomoditas = _jenisKomoditasController.value.trim().isEmpty;
    });
    return _requireKecamatan ||
        _requireKelurahan ||
        _requireKelompok ||
        _requireKomoditas;
  }

  List<Map<String, dynamic>?>? _kecamatanListFiltered;
  List<Map<String, dynamic>?>? _kelurahanListFiltered;
  List<Map<String, dynamic>?>? _kelompokListFiltered;

  List<Map<String, dynamic>>? _komoditasListFiltered;

  Future<Null> _fecthKecamatanDataFromSqfLite() async {
    // setState(() {
    //   _progressHUDLoading = true;
    // });
    await BuruanSaeDatabase.instance
        .showAllKecamatan()
        .then((itemListFromSqfLite) {
      setState(() {
        _kecamatanListFiltered =
            _kecamatanListDistictProcess(itemListFromSqfLite);
        // _progressHUDLoading = false;
      });
    });
  }

  Future<Null> _fecthKomoditasDataFromSqfLite() async {
    // setState(() {
    //   _progressHUDLoading = true;
    // });
    await BuruanSaeDatabase.instance
        .showAllKomoditasFromSqflite()
        .then((itemListFromSqfLite) {
      setState(() {
        _komoditasListFiltered =
            _komoditasListDistictProcess(itemListFromSqfLite)
                .cast<Map<String, dynamic>>();
        // _progressHUDLoading = false;
      });
    });
  }

  List<Map<String, dynamic>?> _kecamatanListDistictProcess(
      List<KecamatanModel> item) {
    final jsonList = item
        .map<String>((e) => jsonEncode({
              'value': e.kecamatan_id.toString(),
              'text': e.nama_kecamatan.toString()
            }))
        .toList();
    final uniqueJsonList = jsonList.toSet().toList();
    return uniqueJsonList
        .map<Map<String, dynamic>?>((item) => jsonDecode(item))
        .toList()
          ..sort((a, b) => (a!['text'].compareTo(b!['text'])));
  }

  List<Map<String, dynamic>?> _komoditasListDistictProcess(
      List<KomoditasModel> item) {
    final jsonList = item
        .map<String>((e) => jsonEncode({
              'value': e.komoditas_id.toString(),
              'text': e.type.toString() + ' - ' + e.nama_komoditas.toString()
            }))
        .toList();
    final uniqueJsonList = jsonList.toSet().toList();
    return uniqueJsonList
        .map<Map<String, dynamic>?>((item) => jsonDecode(item))
        .toList()
          ..sort((a, b) => (a!['text'].compareTo(b!['text'])));
  }

  List<Map<String, dynamic>?> _kelurahanListDistictProcess(
      List<KelurahanModel> item) {
    final jsonList = item
        .map<String>((e) => jsonEncode({
              'value': e.kelurahan_id.toString(),
              'text': e.nama_kelurahan.toString()
            }))
        .toList();
    final uniqueJsonList = jsonList.toSet().toList();
    return uniqueJsonList
        .map<Map<String, dynamic>?>((item) => jsonDecode(item))
        .toList()
          ..sort((a, b) => (a!['text'].compareTo(b!['text'])));
  }

  List<Map<String, dynamic>?> _kelompokListDistictProcess(
      List<KelompokModel> item) {
    final jsonList = item
        .map<String>((e) => jsonEncode({
              'value': e.kelompok_id.toString(),
              'text': e.nama_kelompok.toString()
            }))
        .toList();
    final uniqueJsonList = jsonList.toSet().toList();
    return uniqueJsonList
        .map<Map<String, dynamic>?>((item) => jsonDecode(item))
        .toList()
          ..sort((a, b) => (a!['text'].compareTo(b!['text'])));
  }

  Future<Null> _onKecamatanSelected(query) async {
    // setState(() {
    //   _progressHUDLoading = true;
    // });
    await BuruanSaeDatabase.instance
        .showAllKelurahanById(
            query.toString().isNotEmpty ? int.parse(query) : 0)
        .then((itemListFromSqfLite) {
      setState(() {
        _kelurahanListFiltered =
            _kelurahanListDistictProcess(itemListFromSqfLite);
        // _progressHUDLoading = false;
      });
    });
  }

  Future<Null> _onKelurahanSelected(query) async {
    // setState(() {
    //   _progressHUDLoading = true;
    // });
    await BuruanSaeDatabase.instance
        .showAllKelompokById(query.toString().isNotEmpty ? int.parse(query) : 0)
        .then((itemListFromSqfLite) {
      setState(() {
        _kelompokListFiltered =
            _kelompokListDistictProcess(itemListFromSqfLite);
        // _progressHUDLoading = false;
      });
    });
  }

  Future<Null> _setAllProperty(queryKecamatan, queryKelurahan) async {
    await _fecthKecamatanDataFromSqfLite();
    await _fecthKomoditasDataFromSqfLite();
    await _onKecamatanSelected(queryKecamatan);
    await _onKelurahanSelected(queryKelurahan);
  }

  Future<Null> _setKecamatanKomoditas() async {
    await _fecthKecamatanDataFromSqfLite();
    await _fecthKomoditasDataFromSqfLite();
  }

  var _kecamatanInitialVal,
      _kelurahanInitialVal,
      _kelompokInitialVal,
      _jenisKomoditasInitialVal;

  @override
  void initState() {
    super.initState();
    _penyuluhController = TextEditingController();
    _kecamatanController = CustomSingleDropdownV1Controller();
    _kelurahanController = CustomSingleDropdownV1Controller();
    _kelompokController = CustomSingleDropdownV1Controller();
    _dateController = TextEditingController();
    _jenisKomoditasController = CustomMultiDropdownV1Controller();
    _dateTanamController = TextEditingController();
    _luasTanamController = TextEditingController();
    _datePanenController = TextEditingController();
    _luasPanenController = TextEditingController();
    _provitasPanenController = TextEditingController();
    _produksiPanenController = TextEditingController();
    _datePengolahanController = TextEditingController();
    _volumPengolahanController = TextEditingController();
    _nilaiPengolahanController = TextEditingController();
    _keteranganController = TextEditingController();
    _prep();
  }

  bool _isPrep = false;
  _prep() {
    setState(() {
      _isPrep = true;
    });
    SharedPreferences.getInstance().then((value) async {
      final user =
          UserModel.formJson(await SharedPref.readString(Constants.USER)!);
      _penyuluhController.text = user.name;
    });
    if (this.widget.draftData != null) {
      setState(() {
        _kecamatanInitialVal = this.widget.draftData!.kelurahan!.kecamatan_id;
        _kelurahanInitialVal = this.widget.draftData!.kelurahan!.kelurahan_id;
        _kelompokInitialVal = this.widget.draftData!.kelompok!.kelompok_id;
        _jenisKomoditasInitialVal = this.widget.draftData!.komoditas_id;
        _dateController.text = this.widget.draftData!.date.toString();
        _dateTanamController.text =
            this.widget.draftData!.date_tanam.toString();
        _luasTanamController.text =
            this.widget.draftData!.luas_vol_tanam.toString();
        _datePanenController.text =
            this.widget.draftData!.date_panen.toString();
        _luasPanenController.text =
            this.widget.draftData!.luas_vol_panen.toString();
        _provitasPanenController.text =
            this.widget.draftData!.provitas_panen.toString();
        _produksiPanenController.text =
            this.widget.draftData!.produksi_panen.toString();
        _datePengolahanController.text =
            this.widget.draftData!.date_pengolahan.toString();
        _volumPengolahanController.text =
            this.widget.draftData!.vol_pengolahan.toString();
        _nilaiPengolahanController.text =
            this.widget.draftData!.total_nilai_harga.toString();
        _keteranganController.text =
            this.widget.draftData!.keterangan.toString();
      });
      _setAllProperty(
              _kecamatanInitialVal.toString(), _kelurahanInitialVal.toString())
          .then((value) {
        setState(() {
          _enableKelurahan = true;
          _enableKelompok = true;
          _isPrep = false;
        });
      });
    } else
      _setKecamatanKomoditas().then((value) {
        setState(() {
          _isPrep = false;
        });
      });
  }

  @override
  void dispose() {
    super.dispose();
    _penyuluhController.dispose();
    _kecamatanController.dispose();
    _kelurahanController.dispose();
    _kelompokController.dispose();
    _dateController.dispose();
    _jenisKomoditasController.dispose();
    _dateTanamController.dispose();
    _luasTanamController.dispose();
    _datePanenController.dispose();
    _luasPanenController.dispose();
    _provitasPanenController.dispose();
    _produksiPanenController.dispose();
    _datePengolahanController.dispose();
    _volumPengolahanController.dispose();
    _nilaiPengolahanController.dispose();
    _keteranganController.dispose();
  }

  Future<Null> onDataSaved(bool isDraft) async {
    CustomProgressDialog.show();
    final dataReport = AuditModel(
      audit_id: this.widget.draftData != null
          ? this.widget.draftData!.audit_id
          : null,
      kelurahan_id: int.parse(_kelurahanController.value.toString()),
      date: _dateController.text.toString(),
      kelompok_id: int.parse(_kelompokController.value.toString()),
      komoditas_id:
          json.decode(_jenisKomoditasController.value.toString()).cast<int>(),
      date_tanam: _dateTanamController.text.toString(),
      luas_vol_tanam: _luasTanamController.text.toString(),
      date_panen: _datePanenController.text.toString(),
      luas_vol_panen: _luasPanenController.text.toString(),
      provitas_panen: _provitasPanenController.text.toString(),
      produksi_panen: _produksiPanenController.text.toString(),
      date_pengolahan: _datePengolahanController.text.toString(),
      vol_pengolahan: _volumPengolahanController.text.toString(),
      total_nilai_harga: _nilaiPengolahanController.text.toString(),
      keterangan: _keteranganController.text.toString(),
    );

    if (isDraft) {
      if (dataReport.audit_id == null)
        await BuruanSaeDatabase.instance.createAuditRecord(dataReport);
      else
        await BuruanSaeDatabase.instance.updateAuditRecord(dataReport);
    } else {
      final result = await AuditAPI.createAuditReportsToServer(dataReport);
      if (result.getSuccess) {
        if (dataReport.audit_id != null)
          await BuruanSaeDatabase.instance
              .deleteAuditRecordById(dataReport.audit_id as int);
        CustomSnackbarV1.showSnackbar(
            context, 'Berhasil mengirim data ke Server.');
      } else
        CustomSnackbarV1.showSnackbar(context, result.getMessage);
    }

    CustomProgressDialog.dismiss();

    Navigator.of(context).pop(isDraft);
  }

  @override
  Widget build(BuildContext context) {
    SizeConfig().init(context);
    return WillPopScope(
      onWillPop: _asyncConfirmDiscard,
      child: Scaffold(
        key: _scaffoldKey,
        resizeToAvoidBottomInset: false,
        body: _isPrep
            ? Container()
            : CustomStepFormLayout(
                pageList: _pageList(),
                onPageChange: (idx) {
                  if (idx == 1 && _clearKelompok) {
                    _kelompokController.clear!();
                  }
                },
                onSaved: () async {
                  if (!_validateForm()) {
                    await _asyncConfirmToSave(_scaffoldKey.currentContext!);
                  } else
                    await showAlertDialog(_scaffoldKey.currentContext!);
                },
                onCancel: () async {
                  Navigator.of(context).maybePop();
                },
              ),
      ),
    );
  }

  List<Widget> _pageList() {
    List<Widget> _pageList = [
      ListView(
        key: Key('ListView1'),
        padding: EdgeInsets.all(0),
        children: <Widget>[
          _formField(
            label: "Penyuluh",
            widget: CustomTextFormField(
              enable: false,
              controller: _penyuluhController,
            ),
          ),
          SizedBox(height: 16),
          _subJudul(text: 'Wilayah'),
          SizedBox(height: 8),
          _formField(
            label: "Kecamatan",
            require: _requireKecamatan,
            widget: CustomSingleDropdownV1(
              hintText: "Pilih Kecamatan",
              itemList: _kecamatanListFiltered ?? [],
              initialValue: _kecamatanInitialVal,
              controller: _kecamatanController,
              onChange: () {
                _onKecamatanSelected(_kecamatanController.value);
                _kelurahanController.clear!();
                setState(() {
                  _kelurahanInitialVal = -1;
                  _enableKelurahan = true;
                  _enableKelompok = false;
                  _clearKelompok = true;
                });
              },
            ),
          ),
          SizedBox(height: 8),
          _formField(
            label: "Kelurahan",
            require: _requireKelurahan,
            widget: CustomSingleDropdownV1(
              hintText: "Pilih Kelurahan",
              itemList: _kelurahanListFiltered ?? [],
              initialValue: _kelurahanInitialVal,
              controller: _kelurahanController,
              enable: _enableKelurahan,
              onChange: () {
                _onKelurahanSelected(_kelurahanController.value);
                setState(() {
                  _kelompokInitialVal = -1;
                  _enableKelompok = true;
                  _clearKelompok = true;
                });
              },
            ),
          ),
          SizedBox(height: 16),
          _formField(
            label: "Date",
            widget: CustomDateFormField(
              controller: _dateController,
            ),
          ),
        ],
      ),
      ListView(
        key: Key('ListView2'),
        padding: EdgeInsets.all(0),
        children: <Widget>[
          _formField(
            label: "Kelompok Tani",
            require: _requireKelompok,
            widget: CustomSingleDropdownV1(
              hintText: "Pilih Kelompok Tani",
              itemList: _kelompokListFiltered ?? [],
              initialValue: _kelompokInitialVal,
              controller: _kelompokController,
              enable: _enableKelompok,
              onChange: () {
                setState(() {
                  _clearKelompok = false;
                });
              },
            ),
          ),
          SizedBox(height: 16),
          _formField(
            label: "Jenis Komoditas",
            require: _requireKomoditas,
            widget: CustomMultiDropdownV1(
              hintText: "Pilih Jenis Komoditas",
              itemList: _komoditasListFiltered ?? [],
              initialValue: _jenisKomoditasInitialVal,
              controller: _jenisKomoditasController,
              onChange: () {},
            ),
          ),
          SizedBox(height: 16),
          _subJudul(text: 'Tanam'),
          SizedBox(height: 8),
          _formField(
            label: "Date",
            widget: CustomDateFormField(
              controller: _dateTanamController,
            ),
          ),
          SizedBox(height: 8),
          _formField(
            label: "Luas/Vol (Ha.)",
            widget: CustomTextFormField(
              controller: _luasTanamController,
            ),
          ),
        ],
      ),
      ListView(
        padding: EdgeInsets.all(0),
        children: <Widget>[
          _subJudul(text: 'Panen'),
          SizedBox(height: 8),
          _formField(
            label: "Date",
            widget: CustomDateFormField(
              controller: _datePanenController,
            ),
          ),
          SizedBox(height: 8),
          _formField(
            label: "Luas/Vol (Ha.)",
            widget: CustomTextFormField(
              controller: _luasPanenController,
            ),
          ),
          SizedBox(height: 8),
          _formField(
            label: "Provitas (ku/Ha)",
            widget: CustomTextFormField(
              controller: _provitasPanenController,
            ),
          ),
          SizedBox(height: 8),
          _formField(
            label: "Produksi (Ton)",
            widget: CustomTextFormField(
              controller: _produksiPanenController,
            ),
          ),
        ],
      ),
      ListView(
        padding: EdgeInsets.all(0),
        children: <Widget>[
          _subJudul(text: 'Pengelolahan / Pemasaran Hasil'),
          SizedBox(height: 8),
          _formField(
            label: "Date",
            widget: CustomDateFormField(
              controller: _datePengolahanController,
            ),
          ),
          SizedBox(height: 8),
          _formField(
            label: "Volum (Kg/Ku/..)",
            widget: CustomTextFormField(
              controller: _volumPengolahanController,
            ),
          ),
          SizedBox(height: 8),
          _formField(
            label: "Total Nilai Harga",
            widget: CustomTextFormField(
              controller: _nilaiPengolahanController,
              prefixText: 'Rp. ',
              keyboardType: TextInputType.number,
            ),
          ),
          SizedBox(height: 16),
          _formField(
            label: "Keterangan",
            widget: CustomTextFormField(
              controller: _keteranganController,
              maxLines: 3,
            ),
          ),
        ],
      ),
    ];
    return _pageList;
  }

  Text _subJudul({String text = 'Sub Judul'}) {
    return Text(
      text,
      style: TextStyle(
        color: txtThirdColor,
        fontWeight: FontWeight.bold,
        fontSize: SizeConfig.getWidthSize(4.6),
      ),
    );
  }

  Widget _formField({
    String label = "Label",
    bool require = false,
    Widget? widget,
  }) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.start,
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisSize: MainAxisSize.min,
      children: <Widget>[
        Row(
          mainAxisSize: MainAxisSize.min,
          children: <Widget>[
            Text(
              label,
              style: TextStyle(
                color: txtThirdColor,
                fontWeight: FontWeight.bold,
                fontSize: SizeConfig.getWidthSize(4.6),
              ),
            ),
            SizedBox(width: 2),
            if (require)
              Text(
                "*",
                style: TextStyle(
                  color: errMessage,
                  fontWeight: FontWeight.bold,
                  fontSize: SizeConfig.getWidthSize(4.6),
                ),
              ),
          ],
        ),
        SizedBox(height: 8),
        widget!,
      ],
    );
  }

  Future<bool> _asyncConfirmDiscard() async {
    return (await showDialog(
          context: context,
          barrierDismissible: false, // user must tap button for close dialog!
          builder: (BuildContext context) {
            return AlertDialog(
              title: Text('Batal Insert Data?'),
              content: const Text(
                  'Proses ini akan menghapus semua perubahan yang dilakukan.'),
              actions: <Widget>[
                TextButton(
                  child: const Text('Cancel'),
                  onPressed: () {
                    Navigator.of(context).pop(false);
                  },
                ),
                TextButton(
                  child: const Text(
                    'Hapus',
                    style: TextStyle(color: errMessage),
                  ),
                  onPressed: () {
                    Navigator.of(context).pop(true);
                  },
                )
              ],
            );
          },
        )) ??
        false;
  }

  Future<Null> _asyncConfirmToSave(BuildContext context) async {
    return showDialog(
      context: context,
      barrierDismissible: false, // user must tap button for close dialog!
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Pilih Penyimpanan Report Perkembangan!'),
          content: const Text(
              'Peyimpanan yang dapat dipilih: \n->Draft (Dapat Diedit)\n->Server (Final)'),
          actions: <Widget>[
            TextButton(
              child: const Text(
                'Cancel',
                style: TextStyle(color: errMessage),
              ),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
            TextButton(
              child: const Text(
                'Server',
              ),
              onPressed: () async {
                Navigator.of(context).pop();
                await onDataSaved(false);
              },
            ),
            TextButton(
              child: const Text(
                'Draft',
                style: TextStyle(color: kPrimaryColor),
              ),
              onPressed: () async {
                Navigator.of(context).pop();
                await onDataSaved(true);
              },
            )
          ],
        );
      },
    );
  }

  showAlertDialog(BuildContext context,
      {String title = "Form Error!",
      String text = "Terdapat form kosong! Harap cek kembali inputan anda."}) {
    // Create button
    Widget okButton = TextButton(
      child: Text("OK"),
      onPressed: () {
        Navigator.of(context).pop();
      },
    );

    // Create AlertDialog
    AlertDialog alert = AlertDialog(
      title: Text(
        title,
        style: TextStyle(color: errMessage),
      ),
      content: Text(text),
      actions: [
        okButton,
      ],
    );

    // show the dialog
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return alert;
      },
    );
  }
}
