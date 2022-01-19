import 'package:buruan_sae_apps/model/wilayah.dart';

final String tableKelompok = 'tb_kelompok';

class KelompokFields {
  static final List<String> values = [
    kelompok_id,
    nama_kelompok,
    rt_rw,
    kelurahan_id
  ];
  static final String kelompok_id = 'kelompok_id';
  static final String nama_kelompok = 'nama_kelompok';
  static final String rt_rw = 'rt_rw';
  static final String kelurahan_id = 'kelurahan_id';
}

class KelompokModel {
  int kelompok_id;
  String nama_kelompok;
  String? rt_rw;
  int? kelurahan_id;
  KelurahanModel? kelurahan;
  // String created_at;
  // String updated_at;

  KelompokModel({
    required this.kelompok_id,
    required this.nama_kelompok,
    this.rt_rw,
    this.kelurahan_id,
    this.kelurahan,
    // this.created_at,
    // this.updated_at,
  });

  factory KelompokModel.formJson(Map<String, dynamic> json) {
    return KelompokModel(
      kelompok_id: json['kelompok_id'] as int,
      nama_kelompok: json['nama_kelompok'] as String,
      rt_rw: json['rt_rw'] as String?,
      kelurahan_id: json['kelurahan_id'] as int?,
      kelurahan: (json['tb_kelurahan'] != null)
          ? KelurahanModel.formJson(
              json['tb_kelurahan'] as Map<String, dynamic>)
          : null,
      // created_at: json['created_at'] as String,
      // updated_at: json['updated_at'] as String,
    );
  }

  Map<String, Object> toMap() => {
        KelompokFields.kelompok_id: kelompok_id,
        KelompokFields.nama_kelompok: nama_kelompok,
        KelompokFields.rt_rw: rt_rw!,
        KelompokFields.kelurahan_id: kelurahan_id!,
      };
}
