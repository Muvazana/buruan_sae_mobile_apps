import 'dart:convert';

import 'package:buruan_sae_apps/model/notif_msg.dart';
import 'package:buruan_sae_apps/model/penyuluhan.dart';
import 'package:buruan_sae_apps/model/perkembangan.dart';
import 'package:buruan_sae_apps/utils/shared_pref.dart';
import 'package:data_connection_checker/data_connection_checker.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

import '../constants.dart';

class AuditAPI {
  static Future<NotifMessageModel> createAuditReportsToServer(
      AuditModel auditModel) async {
    NotifMessageModel notifMessageModel;
    if (await DataConnectionChecker().hasConnection) {
      var url = Uri.parse(
          Constants.BASE_URL + "/audit/create?api_token=" + //Constants.TOKEN
          await SharedPref.readString(Constants.LOGINTOKEN)!
          );
      var data = auditModel.toMap();
      // Map data = {
      //   'kelurahan_id': auditModel.kelurahan_id.toString(),
      //   'date': auditModel.date,
      //   'kelompok_id': auditModel.kelompok_id.toString(),
      //   'date_tanam': auditModel.date_tanam,
      //   'luas_vol_tanam': auditModel.luas_vol_tanam,
      //   'date_panen': auditModel.date_panen,
      //   'luas_vol_panen': auditModel.luas_vol_panen,
      //   'provitas_panen': auditModel.provitas_panen,
      //   'produksi_panen': auditModel.produksi_panen,
      //   'date_pengolahan': auditModel.date_pengolahan,
      //   'vol_pengolahan': auditModel.vol_pengolahan,
      //   'total_nilai_harga': auditModel.total_nilai_harga,
      //   'keterangan': auditModel.keterangan,
      // };
      for (var i = 0; i < auditModel.komoditas_id!.length; i++) {
        data['list_komoditas[${i.toString()}]'] =
            auditModel.komoditas_id![i].toString();
      }
      try {
        var responses = await http.post(url, body: data);
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

  static Future<NotifMessageModel> getAuditReportsFromServer() async {
    NotifMessageModel notifMessageModel;
    if (await DataConnectionChecker().hasConnection) {
      var url = Uri.parse(
          Constants.BASE_URL + "/audit/show?api_token=" + //Constants.TOKEN
          await SharedPref.readString(Constants.LOGINTOKEN)!
          );
      try {
        final responses = await http.get(url);
        if (responses.statusCode == 200) {
          var jsonStatus = json.decode(responses.body);
          List<AuditModel>? list = _parseList(jsonStatus['data']);
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

  static List<AuditModel>? _parseList(dynamic response) {
    final parsed = response.cast<Map<String, dynamic>>();
    return parsed.map<AuditModel>((json) => AuditModel.formJson(json)).toList();
  }
}
