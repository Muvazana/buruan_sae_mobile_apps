import 'dart:async';
import 'dart:convert';

import 'package:buruan_sae_apps/model/notif_msg.dart';
import 'package:buruan_sae_apps/model/user.dart';
import 'package:buruan_sae_apps/screen/components/widgets/custom_snackbar_v1.dart';
import 'package:buruan_sae_apps/screen/login/login_screen.dart';
import 'package:buruan_sae_apps/utils/route_generator.dart';
import 'package:buruan_sae_apps/utils/shared_pref.dart';
import 'package:data_connection_checker/data_connection_checker.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

import '../constants.dart';

class AuthAPI {
  Future<NotifMessageModel> login(
      String txtEmail, String txtPassword, String? txtToken) async {
    NotifMessageModel notifMessageModel;

    if (await DataConnectionChecker().hasConnection) {
      var url = Uri.parse(Constants.BASE_URL +
          "/login" +
          (txtToken != null ? "?ver_token= " + txtToken : ''));

      Map data = {
        'email': txtEmail,
        'password': txtPassword,
      };
      try {
        var responses = await http.post(url, body: data);
        if (responses.statusCode == 200) {
          var jsonStatus = json.decode(responses.body);
          if (txtToken == null) {
            notifMessageModel = NotifMessageModel(
              success: true,
              message: "Harap cek alamat email anda!",
            );
          } else {
            await SharedPref.saveString(
                Constants.LOGINTOKEN, jsonStatus['data']['api_token']);
            await SharedPref.saveString(
                Constants.USER, jsonStatus['data']['user']);
            notifMessageModel = NotifMessageModel(
              success: true,
              message: jsonStatus['message'] as String?,
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
          message: e.toString(),
        );
      }
    } else
      notifMessageModel = NotifMessageModel(
        success: false,
        message: "Tidak ada jaringan Internet!",
      );
    return notifMessageModel;
  }

  // static Future<NotifMessageModel> extendLoginTime() async {
  //   NotifMessageModel notifMessageModel;

  //   if (await DataConnectionChecker().hasConnection) {
  //     var url = Uri.parse(Constants.BASE_URL +
  //         "/login/extend?api_token=" +
  //         await SharedPref.readString(Constants.LOGINTOKEN)!);
  //     try {
  //       var responses = await http.get(url);
  //       var jsonData = json.decode(responses.body);
  //       notifMessageModel = NotifMessageModel(
  //         success: jsonData['success'] as bool,
  //         message: jsonData['message'] as String?,
  //       );
  //     } catch (e) {
  //       debugPrint(e.toString());
  //       notifMessageModel = NotifMessageModel(
  //         success: false,
  //         message: e.toString(),
  //       );
  //     }
  //   } else
  //     notifMessageModel = NotifMessageModel(
  //       success: false,
  //       message: "Tidak ada jaringan Internet!",
  //     );
  //   return notifMessageModel;
  // }

  Future<NotifMessageModel> logout() async {
    NotifMessageModel notifMessageModel;
    if (await DataConnectionChecker().hasConnection) {
      var url = Uri.parse(Constants.BASE_URL +
          "/logout?api_token=" +
          await SharedPref.readString(Constants.LOGINTOKEN));
      try {
        var responses = await http.get(url);
        if (responses.statusCode == 200) {
          await removeLoginSharedPref();
          notifMessageModel = NotifMessageModel(
            success: true,
            message: '',
          );
        } else {
          await removeLoginSharedPref();
          notifMessageModel = NotifMessageModel(
            success: false,
            message: "Kesalahan saat mencoba Logout!",
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

  static removeLoginSharedPref() async {
    await SharedPref.remove(Constants.LOGINTOKEN);
    await SharedPref.remove(Constants.USER);
    await SharedPref.remove(Constants.EMAILSAVED);
    await SharedPref.remove(Constants.PASSSAVED);
    await SharedPref.remove(Constants.REMEMBERME);
  }
}

/// Melakukan request extend waktu login ke server
// class ExtendLoginTime {
//   static BuildContext? context;
//   static Timer? timer;
//   static Duration duration = Duration(seconds: 30);
//   static start() {
//     timer = Timer.periodic(duration, (Timer t) async {
//       if (RouteGenerator.routePosition != LoginScreen.routeName) {
//         final result = await AuthAPI.extendLoginTime();
//         if (!result.getSuccess &&
//             result.getMessage != "Tidak ada jaringan Internet!") {
//           Navigator.of(context!).pushNamedAndRemoveUntil(
//               LoginScreen.routeName, (Route<dynamic> route) => false);
//         }
//       }
//     });
//   }

//   static restart() async {
//     if (timer!.isActive) {
//       timer!.cancel();
//       start();
//     }
//   }

//   static cancel() => timer!.cancel();
//   static dispose() {
//     timer!.cancel();
//     timer = null;
//   }
// }
