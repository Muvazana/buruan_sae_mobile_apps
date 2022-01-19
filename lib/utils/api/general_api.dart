import 'dart:convert';

import 'package:buruan_sae_apps/model/notif_msg.dart';
import 'package:buruan_sae_apps/model/wilayah.dart';
import 'package:buruan_sae_apps/utils/shared_pref.dart';
import 'package:data_connection_checker/data_connection_checker.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

import '../constants.dart';

class GeneralAPI {
  // static Future<List<KecamatanModel>?> getWilayahKelompok() async {
  //   var url = Uri.parse(Constants.BASE_URL +
  //           "/wilayah/kecamatan-kelurahan-kelompok?api_token=" +
  //           Constants.TOKEN
  //       // sharedPreferences.getString(Constants.LOGINTOKEN)!
  //       );
  //   try {
  //     final responses = await http.get(url);
  //     if (responses.statusCode == 200) {
  //       List<KecamatanModel>? list =
  //           _parseWilayahKelompokToList(responses.body);
  //       return list;
  //     }
  //   } catch (e) {
  //     throw Exception(e);
  //   }
  // }

  // static List<KecamatanModel>? _parseWilayahKelompokToList(
  //     String responseBody) {
  //   final parsed =
  //       (json.decode(responseBody))['data'].cast<Map<String, dynamic>>();
  //   return parsed
  //       .map<KecamatanModel>((json) => KecamatanModel.formJson(json))
  //       .toList();
  // }

  static Future<NotifMessageModel> getKecamatanFromServer() async {
    NotifMessageModel notifMessageModel;

    if (await DataConnectionChecker().hasConnection) {
      var url = Uri.parse(Constants.BASE_URL +
              "/wilayah/kecamatan?updated_at=" +
              (await SharedPref.readString(Constants.TUKECAMATAN)) +
              "&api_token=" +
              //Constants.TOKEN
          await SharedPref.readString(Constants.LOGINTOKEN)!
          );
      try {
        final responses = await http.get(url);
        if (responses.statusCode == 200) {
          final jsonStatus = json.decode(responses.body);
          if (jsonStatus['success'] as bool) {
            await SharedPref.saveString(
                Constants.TUKECAMATAN, jsonStatus['data']['last_update']);

            notifMessageModel = NotifMessageModel(
              success: true,
              message: jsonStatus['message'] as String?,
              data: jsonStatus['data']['tb_kecamatan'],
            );
          } else {
            notifMessageModel = NotifMessageModel(
              success: false,
              message: jsonStatus['message'] as String?,
              data: '',
            );
          }
        } else {
          var jsonData = json.decode(responses.body);
          notifMessageModel = NotifMessageModel(
            success: false,
            message: jsonData['message'] as String?,
          );
        }
      } catch (e) {
        debugPrint(e.toString());
        notifMessageModel = NotifMessageModel(
          success: false,
          message: "Connection time out! Coba lagi.",
        );
      }
    } else
      notifMessageModel = NotifMessageModel(
        success: false,
        message: "Tidak ada jaringan Internet!",
      );
    return notifMessageModel;
  }

  static Future<NotifMessageModel> getKelurahanFromServer() async {
    NotifMessageModel notifMessageModel;

    if (await DataConnectionChecker().hasConnection) {
      var url = Uri.parse(Constants.BASE_URL +
              "/wilayah/kelurahan?updated_at=" +
              (await SharedPref.readString(Constants.TUKELURAHAN)) +
              "&api_token=" +
              // Constants.TOKEN
          await SharedPref.readString(Constants.LOGINTOKEN)!
          );
      try {
        final responses = await http.get(url);
        if (responses.statusCode == 200) {
          var jsonStatus = json.decode(responses.body);
          if (jsonStatus['success'] as bool) {
            await SharedPref.saveString(
                Constants.TUKELURAHAN, jsonStatus['data']['last_update']);

            notifMessageModel = NotifMessageModel(
              success: true,
              message: jsonStatus['message'] as String?,
              data: jsonStatus['data']['tb_kelurahan'],
            );
          } else {
            notifMessageModel = NotifMessageModel(
              success: false,
              message: jsonStatus['message'] as String?,
              data: '',
            );
          }
        } else {
          var jsonData = json.decode(responses.body);
          notifMessageModel = NotifMessageModel(
            success: false,
            message: jsonData['message'] as String?,
          );
        }
      } catch (e) {
        debugPrint(e.toString());
        notifMessageModel = NotifMessageModel(
          success: false,
          message: "Connection time out! Coba lagi.",
        );
      }
    } else
      notifMessageModel = NotifMessageModel(
        success: false,
        message: "Tidak ada jaringan Internet!",
      );
    return notifMessageModel;
  }

  static Future<NotifMessageModel> getKelompokFromServer() async {
    NotifMessageModel notifMessageModel;

    if (await DataConnectionChecker().hasConnection) {
      var url = Uri.parse(Constants.BASE_URL +
              "/kelompok/show?updated_at=" +
              (await SharedPref.readString(Constants.TUKELOMPOK)) +
              "&api_token=" +
              // Constants.TOKEN
          await SharedPref.readString(Constants.LOGINTOKEN)!
          );
      try {
        final responses = await http.get(url);
        if (responses.statusCode == 200) {
          var jsonStatus = json.decode(responses.body);
          if (jsonStatus['success'] as bool) {
            await SharedPref.saveString(
                Constants.TUKELOMPOK, jsonStatus['data']['last_update']);

            notifMessageModel = NotifMessageModel(
              success: true,
              message: jsonStatus['message'] as String?,
              data: jsonStatus['data']['tb_kelompok'],
            );
          } else {
            notifMessageModel = NotifMessageModel(
              success: false,
              message: jsonStatus['message'] as String?,
              data: '',
            );
          }
        } else {
          var jsonData = json.decode(responses.body);
          notifMessageModel = NotifMessageModel(
            success: false,
            message: jsonData['message'] as String?,
          );
        }
      } catch (e) {
        debugPrint(e.toString());
        notifMessageModel = NotifMessageModel(
          success: false,
          message: "Connection time out! Coba lagi.",
        );
      }
    } else
      notifMessageModel = NotifMessageModel(
        success: false,
        message: "Tidak ada jaringan Internet!",
      );
    return notifMessageModel;
  }

  static Future<NotifMessageModel> getKomoditasFromServer() async {
    NotifMessageModel notifMessageModel;

    if (await DataConnectionChecker().hasConnection) {
      var url = Uri.parse(Constants.BASE_URL +
              "/komoditas/show?updated_at=" +
              (await SharedPref.readString(Constants.TUKOMODITAS)) +
              "&api_token=" +
              // Constants.TOKEN
          await SharedPref.readString(Constants.LOGINTOKEN)!
          );
      try {
        final responses = await http.get(url);
        if (responses.statusCode == 200) {
          var jsonStatus = json.decode(responses.body);
          if (jsonStatus['success'] as bool) {
            await SharedPref.saveString(
                Constants.TUKOMODITAS, jsonStatus['data']['last_update']);

            notifMessageModel = NotifMessageModel(
              success: true,
              message: jsonStatus['message'] as String?,
              data: jsonStatus['data']['tb_komoditas'],
            );
          } else {
            notifMessageModel = NotifMessageModel(
              success: false,
              message: jsonStatus['message'] as String?,
              data: '',
            );
          }
        } else {
          var jsonData = json.decode(responses.body);
          notifMessageModel = NotifMessageModel(
            success: false,
            message: jsonData['message'] as String?,
          );
        }
      } catch (e) {
        debugPrint(e.toString());
        notifMessageModel = NotifMessageModel(
          success: false,
          message: "Connection time out! Coba lagi.",
        );
      }
    } else
      notifMessageModel = NotifMessageModel(
        success: false,
        message: "Tidak ada jaringan Internet!",
      );
    return notifMessageModel;
  }
}
