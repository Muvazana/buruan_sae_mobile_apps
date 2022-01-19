import 'dart:convert';

import 'package:buruan_sae_apps/model/kelompok.dart';
import 'package:buruan_sae_apps/model/komoditas.dart';
import 'package:buruan_sae_apps/model/penyuluhan.dart';
import 'package:buruan_sae_apps/model/perkembangan.dart';
import 'package:buruan_sae_apps/model/wilayah.dart';
import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';
import 'package:flutter/material.dart';

class BuruanSaeDatabase {
  static final BuruanSaeDatabase instance = BuruanSaeDatabase._init();

  static Database? _database;

  BuruanSaeDatabase._init();

  Future<Database> get database async {
    if (_database != null) return _database!;

    _database = await _initDB('buruan_sae.db');
    return _database!;
  }

  Future<Database> _initDB(String filePath) async {
    final dbPath = await getDatabasesPath();
    final path = join(dbPath, filePath);
    // print('db location : ' + path);

    return await openDatabase(path, version: 1, onCreate: _createDB);
  }

  Future _createDB(Database db, int version) async {
    final idType = 'INTEGER PRIMARY KEY AUTOINCREMENT';
    final idTypeNonAI = 'INTEGER PRIMARY KEY';
    final textNullType = 'TEXT NULL';
    final textNotNullType = 'TEXT NOT NULL';
    // final blobNotNullType = 'BLOB NOT NULL';
    final integerNotNullType = 'INTEGER NOT NULL';

    await db.execute('''
    CREATE TABLE $tableKecamatan( 
      ${KecamatanFields.kecamatan_id} $idTypeNonAI,
      ${KecamatanFields.nama_kecamatan} $textNotNullType
    )
    ''');
    await db.execute('''
    CREATE TABLE $tableKelurahan(
      ${KelurahanFields.kelurahan_id} $idTypeNonAI,
      ${KelurahanFields.nama_kelurahan} $textNotNullType,
      ${KelurahanFields.kecamatan_id} $integerNotNullType
    )
    ''');
    await db.execute('''
    CREATE TABLE $tableKelompok(
      ${KelompokFields.kelompok_id} $idTypeNonAI,
      ${KelompokFields.nama_kelompok} $textNotNullType,
      ${KelompokFields.rt_rw} $textNotNullType,
      ${KelompokFields.kelurahan_id} $integerNotNullType
    )
    ''');
    await db.execute('''
    CREATE TABLE $tableKomoditas(
      ${KomoditasFields.komoditas_id} $idTypeNonAI,
      ${KomoditasFields.type} $textNullType,
      ${KomoditasFields.nama_komoditas} $textNullType
    )
    ''');
    await db.execute('''
    CREATE TABLE $tablePenyuluhan(
      ${PeyuluhanFields.penyuluhan_id} $idType,
      ${PeyuluhanFields.kelurahan_id} $integerNotNullType,
      ${PeyuluhanFields.date} $textNotNullType,
      ${PeyuluhanFields.kelompok_id} $integerNotNullType,
      ${PeyuluhanFields.jumlah_anggota} $integerNotNullType,
      ${PeyuluhanFields.kegiatan} $textNotNullType,
      ${PeyuluhanFields.teknis} $textNullType,
      ${PeyuluhanFields.sosial} $textNullType,
      ${PeyuluhanFields.ekonomi} $textNullType,
      ${PeyuluhanFields.masalah} $textNullType,
      ${PeyuluhanFields.pemecahan_masalah} $textNullType
    )
    ''');
    await db.execute('''
    CREATE TABLE $tableAudit(
      ${AuditFields.audit_id} $idType,
      ${AuditFields.kelurahan_id} $integerNotNullType,
      ${AuditFields.date} $textNotNullType,
      ${AuditFields.kelompok_id} $integerNotNullType,
      ${AuditFields.komoditas_id} $textNullType,
      ${AuditFields.date_tanam} $textNullType,
      ${AuditFields.luas_vol_tanam} $textNullType,
      ${AuditFields.date_panen} $textNullType,
      ${AuditFields.luas_vol_panen} $textNullType,
      ${AuditFields.provitas_panen} $textNullType,
      ${AuditFields.produksi_panen} $textNullType,
      ${AuditFields.date_pengolahan} $textNullType,
      ${AuditFields.vol_pengolahan} $textNullType,
      ${AuditFields.total_nilai_harga} $textNullType,
      ${AuditFields.keterangan} $textNullType
    )
    ''');
  }

  Future closeDB() async {
    final db = await instance.database;

    db.close();
  }

  // Create CRUD for Kecamatan
  //
  //
  //
  Future<KecamatanModel> createKecamatan(KecamatanModel kecamatanModel) async {
    final db = await instance.database;

    await db.insert(tableKecamatan, kecamatanModel.toMap());
    return kecamatanModel;
  }

  Future<KecamatanModel> readKecamatanRecordById(int id) async {
    final db = await instance.database;

    final maps = await db.query(
      tableKecamatan,
      columns: KecamatanFields.values,
      where: '${KecamatanFields.kecamatan_id} = ?',
      whereArgs: [id],
    );

    if (maps.isNotEmpty) {
      return KecamatanModel.formJson(maps.first);
    }
    throw Exception('ID $id not found!');
  }

  Future<int> deleteKecamatanRecords() async {
    final db = await instance.database;
    return await db.delete(tableKecamatan);
  }

  Future<List<KecamatanModel>> showAllKecamatan() async {
    final db = await instance.database;
    final orderBy = '${KecamatanFields.nama_kecamatan} ASC';
    final result = await db.query(tableKecamatan, orderBy: orderBy);

    return result.map((json) => KecamatanModel.formJson(json)).toList();
  }

  // Create CRUD for Kelurahan
  //
  //
  //
  Future<KelurahanModel> createKelurahan(KelurahanModel kelurahanModel) async {
    final db = await instance.database;

    await db.insert(tableKelurahan, kelurahanModel.toMap());
    return kelurahanModel;
  }

  Future<KelurahanModel> readKelurahanRecordById(int id) async {
    final db = await instance.database;

    final maps = await db.query(
      tableKelurahan,
      columns: KelurahanFields.values,
      where: '${KelurahanFields.kelurahan_id} = ?',
      whereArgs: [id],
    );

    if (maps.isNotEmpty) {
      return KelurahanModel.formJson(maps.first);
    }
    throw Exception('ID $id not found!');
  }

  Future<int> deleteKelurahanRecords() async {
    final db = await instance.database;
    return await db.delete(tableKelurahan);
  }

  Future<List<KelurahanModel>> showAllKelurahanById(int id) async {
    final db = await instance.database;
    final orderBy = '${KelurahanFields.nama_kelurahan} ASC';
    final result = await db.query(
      tableKelurahan,
      columns: KelurahanFields.values,
      where: '${KelurahanFields.kecamatan_id} = ?',
      whereArgs: [id],
      orderBy: orderBy,
    );

    return result.map((json) => KelurahanModel.formJson(json)).toList();
  }

  // Create CRUD for Kelompok
  //
  //
  //
  Future<KelompokModel> createKelompok(KelompokModel kelompokModel) async {
    final db = await instance.database;

    await db.insert(tableKelompok, kelompokModel.toMap());
    return kelompokModel;
  }

  Future<KelompokModel> readKelompokRecordById(int id) async {
    final db = await instance.database;

    final maps = await db.query(
      tableKelompok,
      columns: KelompokFields.values,
      where: '${KelompokFields.kelompok_id} = ?',
      whereArgs: [id],
    );

    if (maps.isNotEmpty) {
      return KelompokModel.formJson(maps.first);
    }
    throw Exception('ID $id not found!');
  }

  Future<int> deleteKelompokRecords() async {
    final db = await instance.database;
    return await db.delete(tableKelompok);
  }

  Future<List<KelompokModel>> showAllKelompokById(int id) async {
    final db = await instance.database;
    final orderBy = '${KelompokFields.nama_kelompok} ASC';
    final result = await db.query(
      tableKelompok,
      columns: KelompokFields.values,
      where: '${KelompokFields.kelurahan_id} = ?',
      whereArgs: [id],
      orderBy: orderBy,
    );

    return result.map((json) => KelompokModel.formJson(json)).toList();
  }

  // Create CRUD for Komoditas
  //
  //
  //
  Future<KomoditasModel> createKomoditas(KomoditasModel komoditasModel) async {
    final db = await instance.database;

    await db.insert(tableKomoditas, komoditasModel.toMap());
    return komoditasModel;
  }

  Future<KomoditasModel> readKomoditasRecordById(int id) async {
    final db = await instance.database;

    final maps = await db.query(
      tableKomoditas,
      columns: KomoditasFields.values,
      where: '${KomoditasFields.komoditas_id} = ?',
      whereArgs: [id],
    );

    if (maps.isNotEmpty) {
      return KomoditasModel.formJson(maps.first);
    }
    throw Exception('ID $id not found!');
  }

  Future<int> deleteKomoditasRecords() async {
    final db = await instance.database;
    return await db.delete(tableKomoditas);
  }

  Future<List<KomoditasModel>> showAllKomoditasFromSqflite() async {
    final db = await instance.database;
    final orderBy = '${KomoditasFields.type} ASC';
    final result = await db.query(
      tableKomoditas,
      columns: KomoditasFields.values,
      orderBy: orderBy,
    );

    return result.map((json) => KomoditasModel.formJson(json)).toList();
  }

  // Create CRUD for Penyuluhan
  //
  //
  //
  Future<PenyuluhanModel> createPenyuluhanRecord(
      PenyuluhanModel penyuluhanModel) async {
    final db = await instance.database;

    final id = await db.insert(tablePenyuluhan, penyuluhanModel.toMap());
    return penyuluhanModel.copy(penyuluhan_id: id);
  }

  Future<PenyuluhanModel> readPenyuluhanRecordById(int id) async {
    final db = await instance.database;

    final maps = await db.query(
      tablePenyuluhan,
      columns: PeyuluhanFields.values,
      where: '${PeyuluhanFields.penyuluhan_id} = ?',
      whereArgs: [id],
    );

    if (maps.isNotEmpty) {
      final data = PenyuluhanModel.formJson(maps.first);
      final kelompok = await readKelompokRecordById(data.kelompok_id);
      final kelurahan = await readKelurahanRecordById(data.kelurahan_id);
      final kecamatan = await readKecamatanRecordById(kelurahan.kecamatan_id!);
      return data.copy(
        kelompok: kelompok,
        kelurahan: kelurahan.copy(kecamatan: kecamatan),
      );
    }
    throw Exception('ID $id not found!');
  }

  Future<int> updatePenyuluhanRecord(PenyuluhanModel penyuluhanModel) async {
    final db = await instance.database;
    return await db.update(
      tablePenyuluhan,
      penyuluhanModel.toMap(),
      where: '${PeyuluhanFields.penyuluhan_id} = ?',
      whereArgs: [penyuluhanModel.penyuluhan_id],
    );
  }

  Future<int> deletePenyuluhanRecordById(int id) async {
    final db = await instance.database;
    return await db.delete(
      tablePenyuluhan,
      where: '${PeyuluhanFields.penyuluhan_id} = ?',
      whereArgs: [id],
    );
  }

  Future<List<PenyuluhanModel>> showAllPenyuluhanFromSqflite() async {
    final db = await instance.database;
    final rawData = await db.query(
      tablePenyuluhan,
      columns: PeyuluhanFields.values,
    );
    var result = rawData.map((json) => PenyuluhanModel.formJson(json)).toList();

    for (var i = 0; i < result.length; i++) {
      final kelompok = await readKelompokRecordById(result[i].kelompok_id);
      final kelurahan = await readKelurahanRecordById(result[i].kelurahan_id);
      final kecamatan = await readKecamatanRecordById(kelurahan.kecamatan_id!);
      result[i] = result[i].copy(
        kelompok: kelompok,
        kelurahan: kelurahan.copy(kecamatan: kecamatan),
      );
    }
    return result;
  }

  // Create CRUD for Perkembangan
  //
  //
  //
  Future<AuditModel> createAuditRecord(AuditModel auditModel) async {
    final db = await instance.database;
    final id = await db.insert(tableAudit, auditModel.toMap());
    return auditModel.copy(audit_id: id);
  }

  // Future<PenyuluhanModel> readPenyuluhanRecordById(int id) async {
  //   final db = await instance.database;

  //   final maps = await db.query(
  //     tablePenyuluhan,
  //     columns: PeyuluhanFields.values,
  //     where: '${PeyuluhanFields.penyuluhan_id} = ?',
  //     whereArgs: [id],
  //   );

  //   if (maps.isNotEmpty) {
  //     final data = PenyuluhanModel.formJson(maps.first);
  //     final kelompok = await readKelompokRecordById(data.kelompok_id);
  //     final kelurahan = await readKelurahanRecordById(data.kelurahan_id);
  //     final kecamatan = await readKecamatanRecordById(kelurahan.kecamatan_id!);
  //     return data.copy(
  //       kelompok: kelompok,
  //       kelurahan: kelurahan.copy(kecamatan: kecamatan),
  //     );
  //   }
  //   throw Exception('ID $id not found!');
  // }

  Future<int> updateAuditRecord(AuditModel auditModel) async {
    final db = await instance.database;
    return await db.update(
      tableAudit,
      auditModel.toMap(),
      where: '${AuditFields.audit_id} = ?',
      whereArgs: [auditModel.audit_id],
    );
  }

  Future<int> deleteAuditRecordById(int id) async {
    final db = await instance.database;
    return await db.delete(
      tableAudit,
      where: '${AuditFields.audit_id} = ?',
      whereArgs: [id],
    );
  }

  Future<List<AuditModel>> showAllAuditFromSqflite() async {
    final db = await instance.database;
    final rawData = await db.query(
      tableAudit,
      columns: AuditFields.values,
    );
    var result = rawData.map((json) => AuditModel.formJson(json)).toList();

    for (var i = 0; i < result.length; i++) {
      final kelompok = await readKelompokRecordById(result[i].kelompok_id);
      final kelurahan = await readKelurahanRecordById(result[i].kelurahan_id);
      final kecamatan = await readKecamatanRecordById(kelurahan.kecamatan_id!);
      List<KomoditasModel>? listKomoditas = [];
      for (var i in result[i].komoditas_id!) {
        listKomoditas.add(await readKomoditasRecordById(i));
      }
      result[i] = result[i].copy(
        kelompok: kelompok,
        kelurahan: kelurahan.copy(kecamatan: kecamatan),
        komoditas: listKomoditas,
      );
    }
    return result;
  }
}
