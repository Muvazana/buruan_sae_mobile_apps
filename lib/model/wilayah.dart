import 'package:buruan_sae_apps/model/kelompok.dart';

final String tableKelurahan = 'tb_kelurahan';

class KelurahanFields {
  static final List<String> values = [
    kelurahan_id,
    nama_kelurahan,
    kecamatan_id
  ];

  static final String kelurahan_id = 'kelurahan_id';
  static final String nama_kelurahan = 'nama_kelurahan';
  static final String kecamatan_id = 'kecamatan_id';
}

class KelurahanModel {
  int kelurahan_id;
  String nama_kelurahan;
  int? kecamatan_id;
  KecamatanModel? kecamatan;
  List<KelompokModel>? kelompok;
  // String created_at;
  // String updated_at;

  KelurahanModel({
    required this.kelurahan_id,
    required this.nama_kelurahan,
    this.kecamatan_id,
    this.kecamatan,
    this.kelompok,
    // this.created_at,
    // this.updated_at,
  });

  KelurahanModel copy({
    int? kelurahan_id,
    String? nama_kelurahan,
    int? kecamatan_id,
    KecamatanModel? kecamatan,
  }) =>
      KelurahanModel(
        kelurahan_id: kelurahan_id ?? this.kelurahan_id,
        nama_kelurahan: nama_kelurahan ?? this.nama_kelurahan,
        kecamatan_id: kecamatan_id ?? this.kecamatan_id,
        kecamatan: kecamatan ?? this.kecamatan,
      );

  factory KelurahanModel.formJson(Map<String, dynamic> json) {
    return KelurahanModel(
      kelurahan_id: json['kelurahan_id'] as int,
      nama_kelurahan: json['nama_kelurahan'] as String,
      kecamatan_id: json['kecamatan_id'] as int?,
      kecamatan: (json['tb_kecamatan'] != null)
          ? KecamatanModel.formJson(
              json['tb_kecamatan'] as Map<String, dynamic>)
          : null,
      kelompok: (json['tb_kelompok'] != null)
          ? parseKelompok(json['tb_kelompok'] as List)
          : null,
      // created_at: json['created_at'] as String,
      // updated_at: json['updated_at'] as String,
    );
  }

  static List<KelompokModel> parseKelompok(List list) {
    return list.map((e) => KelompokModel.formJson(e)).toList();
  }

  Map<String, Object> toMap() => {
        KelurahanFields.kelurahan_id: kelurahan_id,
        KelurahanFields.nama_kelurahan: nama_kelurahan,
        KelurahanFields.kecamatan_id: kecamatan_id!,
      };
}

final String tableKecamatan = 'tb_kecamatan';

class KecamatanFields {
  static final List<String> values = [kecamatan_id, nama_kecamatan];

  static final String kecamatan_id = 'kecamatan_id';
  static final String nama_kecamatan = 'nama_kecamatan';
}

class KecamatanModel {
  int kecamatan_id;
  String nama_kecamatan;
  List<KelurahanModel>? kelurahan;
  // String created_at;
  // String updated_at;

  KecamatanModel({
    required this.kecamatan_id,
    required this.nama_kecamatan,
    this.kelurahan,
    // this.created_at,
    // this.updated_at,
  });

  factory KecamatanModel.formJson(Map<String, dynamic> json) {
    return KecamatanModel(
      kecamatan_id: json['kecamatan_id'] as int,
      nama_kecamatan: json['nama_kecamatan'] as String,
      kelurahan: (json['tb_kelurahan'] != null)
          ? parseKelurahanToList(json['tb_kelurahan'] as List)
          : null,
      // created_at: json['created_at'] as String,
      // updated_at: json['updated_at'] as String,
    );
  }

  static List<KelurahanModel> parseKelurahanToList(List list) {
    return list.map<KelurahanModel>((e) => KelurahanModel.formJson(e)).toList();
  }

  Map<String, Object> toMap() => {
        KecamatanFields.kecamatan_id: kecamatan_id,
        KecamatanFields.nama_kecamatan: nama_kecamatan,
      };
}
