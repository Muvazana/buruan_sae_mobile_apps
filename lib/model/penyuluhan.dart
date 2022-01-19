import 'package:buruan_sae_apps/model/kelompok.dart';
import 'package:buruan_sae_apps/model/wilayah.dart';

final String tablePenyuluhan = 'tb_penyuluhan';

class PeyuluhanFields {
  static final List<String> values = [
    penyuluhan_id,
    kelurahan_id,
    date,
    kelompok_id,
    jumlah_anggota,
    kegiatan,
    teknis,
    sosial,
    ekonomi,
    masalah,
    pemecahan_masalah,
  ];

  static final String penyuluhan_id = 'penyuluhan_id';
  static final String kelurahan_id = 'kelurahan_id';
  static final String date = 'date';
  static final String kelompok_id = 'kelompok_id';
  static final String jumlah_anggota = 'jumlah_anggota';
  static final String kegiatan = 'kegiatan';
  static final String teknis = 'teknis';
  static final String sosial = 'sosial';
  static final String ekonomi = 'ekonomi';
  static final String masalah = 'masalah';
  static final String pemecahan_masalah = 'pemecahan_masalah';
}

class PenyuluhanModel {
  int? penyuluhan_id;
  int kelurahan_id;
  KelurahanModel? kelurahan;
  String date;
  int kelompok_id;
  KelompokModel? kelompok;
  int jumlah_anggota;
  String kegiatan;
  String? teknis;
  String? sosial;
  String? ekonomi;
  String? masalah;
  String? pemecahan_masalah;
  // String created_at;
  // String updated_at;

  PenyuluhanModel({
    this.penyuluhan_id,
    required this.kelurahan_id,
    this.kelurahan,
    required this.date,
    required this.kelompok_id,
    this.kelompok,
    required this.jumlah_anggota,
    required this.kegiatan,
    this.teknis,
    this.sosial,
    this.ekonomi,
    this.masalah,
    this.pemecahan_masalah,
    // this.created_at,
    // this.updated_at,
  });

  PenyuluhanModel copy({
    int? penyuluhan_id,
    int? kelurahan_id,
    KelurahanModel? kelurahan,
    String? date,
    int? kelompok_id,
    KelompokModel? kelompok,
    int? jumlah_anggota,
    String? kegiatan,
    String? teknis,
    String? sosial,
    String? ekonomi,
    String? masalah,
    String? pemecahan_masalah,
  }) =>
      PenyuluhanModel(
        penyuluhan_id: penyuluhan_id ?? this.penyuluhan_id,
        kelurahan_id: kelurahan_id ?? this.kelurahan_id,
        kelurahan: kelurahan ?? this.kelurahan,
        date: date ?? this.date,
        kelompok_id: kelompok_id ?? this.kelompok_id,
        kelompok: kelompok ?? this.kelompok,
        jumlah_anggota: jumlah_anggota ?? this.jumlah_anggota,
        kegiatan: kegiatan ?? this.kegiatan,
        teknis: teknis ?? this.teknis,
        sosial: sosial ?? this.sosial,
        ekonomi: ekonomi ?? this.ekonomi,
        masalah: masalah ?? this.masalah,
        pemecahan_masalah: pemecahan_masalah ?? this.pemecahan_masalah,
      );

  factory PenyuluhanModel.formJson(Map<String, dynamic> json) {
    return PenyuluhanModel(
      penyuluhan_id: json['penyuluhan_id'] as int?,
      kelurahan_id: json['kelurahan_id'] as int,
      kelurahan: (json['tb_kelurahan'] != null)
          ? KelurahanModel.formJson(
              json['tb_kelurahan'] as Map<String, dynamic>)
          : null,
      date: json['date'] as String,
      kelompok_id: json['kelompok_id'] as int,
      kelompok: (json['tb_kelompok'] != null)
          ? KelompokModel.formJson(json['tb_kelompok'] as Map<String, dynamic>)
          : null,
      jumlah_anggota: json['jumlah_anggota'] as int,
      kegiatan: json['kegiatan'] as String,
      teknis: json['teknis'] as String?,
      sosial: json['sosial'] as String?,
      ekonomi: json['ekonomi'] as String?,
      masalah: json['masalah'] as String?,
      pemecahan_masalah: json['pemecahan_masalah'] as String?,
      // created_at: json['created_at'] as String,
      // updated_at: json['updated_at'] as String,
    );
  }

  Map<String, Object> toMap() => {
        PeyuluhanFields.kelurahan_id: kelurahan_id.toString(),
        PeyuluhanFields.date: date,
        PeyuluhanFields.kelompok_id: kelompok_id.toString(),
        PeyuluhanFields.jumlah_anggota: jumlah_anggota.toString(),
        PeyuluhanFields.kegiatan: kegiatan,
        PeyuluhanFields.teknis: teknis!,
        PeyuluhanFields.sosial: sosial!,
        PeyuluhanFields.ekonomi: ekonomi!,
        PeyuluhanFields.masalah: masalah!,
        PeyuluhanFields.pemecahan_masalah: pemecahan_masalah!,
      };
}
