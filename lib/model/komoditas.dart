final String tableKomoditas = 'tb_komoditas';

class KomoditasFields {
  static final List<String> values = [komoditas_id, type, nama_komoditas];

  static final String komoditas_id = 'komoditas_id';
  static final String type = 'type';
  static final String nama_komoditas = 'nama_komoditas';
}

class KomoditasModel {
  int komoditas_id;
  String? type;
  String? nama_komoditas;

  KomoditasModel({
    required this.komoditas_id,
    this.type,
    this.nama_komoditas,
  });

  factory KomoditasModel.formJson(Map<String, dynamic> json) {
    return KomoditasModel(
      komoditas_id: json['komoditas_id'] as int,
      type: json['type'] as String?,
      nama_komoditas: json['nama_komoditas'] as String?,
    );
  }

  Map<String, Object> toMap() => {
        KomoditasFields.komoditas_id: komoditas_id,
        KomoditasFields.type: type!,
        KomoditasFields.nama_komoditas: nama_komoditas!,
      };
}
