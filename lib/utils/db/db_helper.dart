import 'dart:convert';

import 'package:buruan_sae_apps/model/kelompok.dart';
import 'package:buruan_sae_apps/model/komoditas.dart';
import 'package:buruan_sae_apps/model/wilayah.dart';
import 'package:buruan_sae_apps/utils/db/buruan_sae_database.dart';
import 'package:buruan_sae_apps/utils/api/general_api.dart';
import 'package:flutter/material.dart';

class DBHelper {
  static Future<Null> setDataKecamatanToSqflite() async {
    try {
      var data = await GeneralAPI.getKecamatanFromServer();
      if (data.getSuccess) {
        final nilai = await BuruanSaeDatabase.instance.deleteKecamatanRecords();
        debugPrint("Delete KEcamatan : " + nilai.toString());
        final parsed = data.getData.cast<Map<String, dynamic>>();
        for (var value in parsed) {
          var item = KecamatanModel(
              kecamatan_id: value['kecamatan_id'],
              nama_kecamatan: value['nama_kecamatan']);
          await BuruanSaeDatabase.instance.createKecamatan(item);
        }
      }
    } catch (e) {
      throw Exception(e);
    }
  }

  static Future<Null> setDataKelurahanToSqflite() async {
    try {
      var data = await GeneralAPI.getKelurahanFromServer();
      if (data.getSuccess) {
        final nilai = await BuruanSaeDatabase.instance.deleteKelurahanRecords();
        debugPrint("Delete Kelurahan : " + nilai.toString());
        final parsed = data.getData.cast<Map<String, dynamic>>();
        for (var value in parsed) {
          var item = KelurahanModel(
              kelurahan_id: value['kelurahan_id'],
              nama_kelurahan: value['nama_kelurahan'],
              kecamatan_id: value['kecamatan_id']);
          await BuruanSaeDatabase.instance.createKelurahan(item);
        }
      }
    } catch (e) {
      throw Exception(e);
    }
  }

  static Future<Null> setDataKelompokToSqflite() async {
    try {
      var data = await GeneralAPI.getKelompokFromServer();
      if (data.getSuccess) {
        final nilai = await BuruanSaeDatabase.instance.deleteKelompokRecords();
        debugPrint("Delete Kelompok : " + nilai.toString());
        final parsed = data.getData.cast<Map<String, dynamic>>();
        for (var value in parsed) {
          var item = KelompokModel(
              kelompok_id: value['kelompok_id'],
              nama_kelompok: value['nama_kelompok'],
              rt_rw: value['rt_rw'],
              kelurahan_id: value['kelurahan_id']);
          await BuruanSaeDatabase.instance.createKelompok(item);
        }
      }
    } catch (e) {
      throw Exception(e);
    }
  }

  static Future<Null> setDataKomoditasToSqflite() async {
    try {
      var data = await GeneralAPI.getKomoditasFromServer();
      if (data.getSuccess) {
    final nilai = await BuruanSaeDatabase.instance.deleteKomoditasRecords();
    debugPrint("Delete Komoditas : " + nilai.toString());
        final parsed = data.getData.cast<Map<String, dynamic>>();
        for (var value in parsed) {
        var item = KomoditasModel(
            komoditas_id: value['komoditas_id'],
            type: value['type'],
            nama_komoditas: value['nama_komoditas']);
        await BuruanSaeDatabase.instance.createKomoditas(item);
        }
      }
    } catch (e) {
      throw Exception(e);
    }
  }
}
