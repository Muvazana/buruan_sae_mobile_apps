import 'dart:convert';

import 'package:buruan_sae_apps/model/notif_msg.dart';
import 'package:buruan_sae_apps/model/penyuluhan.dart';
import 'package:buruan_sae_apps/utils/shared_pref.dart';
import 'package:data_connection_checker/data_connection_checker.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

import '../constants.dart';

class PenyuluhanAPI {
  static Future<NotifMessageModel> createPenyuluhanReportsToServer(
      PenyuluhanModel penyuluhanModel) async {
    NotifMessageModel notifMessageModel;
    if (await DataConnectionChecker().hasConnection) {
      var url = Uri.parse(
          Constants.BASE_URL + "/penyuluhan/create?api_token=" + //Constants.TOKEN
          await SharedPref.readString(Constants.LOGINTOKEN)!
          );

      // Map data = {
      //   'kelurahan_id': penyuluhanModel.kelurahan_id.toString(),
      //   'date': penyuluhanModel.date,
      //   'kelompok_id': penyuluhanModel.kelompok_id.toString(),
      //   'jumlah_anggota': penyuluhanModel.jumlah_anggota.toString(),
      //   'kegiatan': penyuluhanModel.kegiatan,
      //   'teknis': penyuluhanModel.teknis,
      //   'sosial': penyuluhanModel.sosial,
      //   'ekonomi': penyuluhanModel.ekonomi,
      //   'masalah': penyuluhanModel.masalah,
      //   'pemecahan_masalah': penyuluhanModel.pemecahan_masalah,
      // };
      try {
        var responses = await http.post(url, body: penyuluhanModel.toMap());
        if (responses.statusCode == 200) {
          var jsonStatus = json.decode(responses.body);
          notifMessageModel = NotifMessageModel(
            success: true,
            message: jsonStatus['message'] as String?,
          );
        } else {
          var jsonStatus = json.decode(responses.body);
          notifMessageModel = NotifMessageModel(
            success: false,
            message: jsonStatus['message'] as String?,
          );
        }
      } catch (e) {
        debugPrint(e.toString());
        notifMessageModel = NotifMessageModel(
          success: false,
          message: 'Connection time out! Coba lagi.',
        );
      }
    } else
      notifMessageModel = NotifMessageModel(
        success: false,
        message: "Tidak ada jaringan Internet!",
      );
    return notifMessageModel;
  }

  static Future<NotifMessageModel> getPenyuluhanReportsFromServer() async {
    NotifMessageModel notifMessageModel;
    if (await DataConnectionChecker().hasConnection) {
      var url = Uri.parse(
          Constants.BASE_URL + "/penyuluhan/show?api_token=" + //Constants.TOKEN
          await SharedPref.readString(Constants.LOGINTOKEN)!
          );
      try {
        final responses = await http.get(url);
        if (responses.statusCode == 200) {
          var jsonStatus = json.decode(responses.body);
          List<PenyuluhanModel>? list = _parseList(jsonStatus['data']);
          notifMessageModel = NotifMessageModel(
            success: true,
            message: jsonStatus['message'] as String?,
            data: list,
          );
        } else {
          var jsonStatus = json.decode(responses.body);
          notifMessageModel = NotifMessageModel(
            success: false,
            message: jsonStatus['message'] as String?,
          );
        }
      } catch (e) {
        debugPrint(e.toString());
        notifMessageModel = NotifMessageModel(
          success: false,
          message: 'Connection time out! Coba lagi.',
        );
      }
    } else
      notifMessageModel = NotifMessageModel(
        success: false,
        message: "Tidak ada jaringan Internet!",
      );
    return notifMessageModel;
  }

  static List<PenyuluhanModel>? _parseList(dynamic response) {
    final parsed = response.cast<Map<String, dynamic>>();
    return parsed
        .map<PenyuluhanModel>((json) => PenyuluhanModel.formJson(json))
        .toList();
  }
}
