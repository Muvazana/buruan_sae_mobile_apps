import 'dart:convert';

import 'package:buruan_sae_apps/model/kelompok.dart';
import 'package:buruan_sae_apps/model/komoditas.dart';
import 'package:buruan_sae_apps/model/wilayah.dart';

final String tableAudit = 'tb_audit';

class AuditFields {
  static final List<String> values = [
    audit_id,
    kelurahan_id,
    date,
    kelompok_id,
    komoditas_id,
    date_tanam,
    luas_vol_tanam,
    date_panen,
    luas_vol_panen,
    provitas_panen,
    produksi_panen,
    date_pengolahan,
    vol_pengolahan,
    total_nilai_harga,
    keterangan,
  ];

  static final String audit_id = 'audit_id';
  static final String kelurahan_id = 'kelurahan_id';
  static final String date = 'date';
  static final String kelompok_id = 'kelompok_id';
  static final String komoditas_id = 'komoditas_id';
  static final String date_tanam = 'date_tanam';
  static final String luas_vol_tanam = 'luas_vol_tanam';
  static final String date_panen = 'date_panen';
  static final String luas_vol_panen = 'luas_vol_panen';
  static final String provitas_panen = 'provitas_panen';
  static final String produksi_panen = 'produksi_panen';
  static final String date_pengolahan = 'date_pengolahan';
  static final String vol_pengolahan = 'vol_pengolahan';
  static final String total_nilai_harga = 'total_nilai_harga';
  static final String keterangan = 'keterangan';
}

class AuditModel {
  int? audit_id;
  int kelurahan_id;
  KelurahanModel? kelurahan;
  String date;
  int kelompok_id;
  KelompokModel? kelompok;
  List<int>? komoditas_id;
  List<KomoditasModel>? komoditas;
  String? date_tanam;
  String? luas_vol_tanam;
  String? date_panen;
  String? luas_vol_panen;
  String? provitas_panen;
  String? produksi_panen;
  String? date_pengolahan;
  String? vol_pengolahan;
  String? total_nilai_harga;
  String? keterangan;

  AuditModel({
    this.audit_id,
    required this.kelurahan_id,
    this.kelurahan,
    required this.date,
    required this.kelompok_id,
    this.kelompok,
    this.komoditas_id,
    this.komoditas,
    this.date_tanam,
    this.luas_vol_tanam,
    this.date_panen,
    this.luas_vol_panen,
    this.provitas_panen,
    this.produksi_panen,
    this.date_pengolahan,
    this.vol_pengolahan,
    this.total_nilai_harga,
    this.keterangan,
  });

  AuditModel copy(
          {int? audit_id,
          int? kelurahan_id,
          KelurahanModel? kelurahan,
          String? date,
          int? kelompok_id,
          KelompokModel? kelompok,
          List<int>? komoditas_id,
          List<KomoditasModel>? komoditas,
          String? date_tanam,
          String? luas_vol_tanam,
          String? date_panen,
          String? luas_vol_panen,
          String? provitas_panen,
          String? produksi_panen,
          String? date_pengolahan,
          String? vol_pengolahan,
          String? total_nilai_harga,
          String? keterangan}) =>
      AuditModel(
        audit_id: audit_id ?? this.audit_id,
        kelurahan_id: kelurahan_id ?? this.kelurahan_id,
        kelurahan: kelurahan ?? this.kelurahan,
        date: date ?? this.date,
        kelompok_id: kelompok_id ?? this.kelompok_id,
        kelompok: kelompok ?? this.kelompok,
        komoditas_id: komoditas_id ?? this.komoditas_id,
        komoditas: komoditas ?? this.komoditas,
        date_tanam: date_tanam ?? this.date_tanam,
        luas_vol_tanam: luas_vol_tanam ?? this.luas_vol_tanam,
        date_panen: date_panen ?? this.date_panen,
        luas_vol_panen: luas_vol_panen ?? this.luas_vol_panen,
        provitas_panen: provitas_panen ?? this.provitas_panen,
        produksi_panen: produksi_panen ?? this.produksi_panen,
        date_pengolahan: date_pengolahan ?? this.date_pengolahan,
        vol_pengolahan: vol_pengolahan ?? this.vol_pengolahan,
        total_nilai_harga: total_nilai_harga ?? this.total_nilai_harga,
        keterangan: keterangan ?? this.keterangan,
      );

  factory AuditModel.formJson(Map<String, dynamic> jsonData) {
    return AuditModel(
      audit_id: jsonData['audit_id'] as int?,
      kelurahan_id: jsonData['kelurahan_id'] as int,
      kelurahan: (jsonData['tb_kelurahan'] != null)
          ? KelurahanModel.formJson(
              jsonData['tb_kelurahan'] as Map<String, dynamic>)
          : null,
      date: jsonData['date'] as String,
      kelompok_id: jsonData['kelompok_id'] as int,
      kelompok: (jsonData['tb_kelompok'] != null)
          ? KelompokModel.formJson(
              jsonData['tb_kelompok'] as Map<String, dynamic>)
          : null,
      komoditas_id: (jsonData['komoditas_id'] != null)
          ? json.decode(jsonData['komoditas_id'].toString()).cast<int>()
          : null,
      komoditas: (jsonData['tb_komoditas'] != null)
          ? _parseKomoditasToList(jsonData['tb_komoditas'] as List)
          : null,
      date_tanam: jsonData['date_tanam'] as String?,
      luas_vol_tanam: jsonData['luas_vol_tanam'] as String?,
      date_panen: jsonData['date_panen'] as String?,
      luas_vol_panen: jsonData['luas_vol_panen'] as String?,
      provitas_panen: jsonData['provitas_panen'] as String?,
      produksi_panen: jsonData['produksi_panen'] as String?,
      date_pengolahan: jsonData['date_pengolahan'] as String?,
      vol_pengolahan: jsonData['vol_pengolahan'] as String?,
      total_nilai_harga: jsonData['total_nilai_harga'] as String?,
      keterangan: jsonData['keterangan'] as String?,
    );
  }

  static List<KomoditasModel> _parseKomoditasToList(List list) {
    return list.map<KomoditasModel>((e) => KomoditasModel.formJson(e)).toList();
  }

  Map<String, Object> toMap() => {
        AuditFields.kelurahan_id: kelurahan_id.toString(),
        AuditFields.date: date,
        AuditFields.kelompok_id: kelompok_id.toString(),
        AuditFields.komoditas_id: komoditas_id!.toString(),
        AuditFields.date_tanam: date_tanam!,
        AuditFields.luas_vol_tanam: luas_vol_tanam!,
        AuditFields.date_panen: date_panen!,
        AuditFields.luas_vol_panen: luas_vol_panen!,
        AuditFields.provitas_panen: provitas_panen!,
        AuditFields.produksi_panen: produksi_panen!,
        AuditFields.date_pengolahan: date_pengolahan!,
        AuditFields.vol_pengolahan: vol_pengolahan!,
        AuditFields.total_nilai_harga: total_nilai_harga!,
        AuditFields.keterangan: keterangan!,
      };
}
