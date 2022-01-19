import 'package:buruan_sae_apps/screen/components/widgets/custom_progress_dialog.dart';
import 'package:buruan_sae_apps/screen/components/widgets/custom_snackbar_v1.dart';
import 'package:buruan_sae_apps/screen/dashboard/dashboard.dart';
import 'package:buruan_sae_apps/utils/api/auth.dart';
import 'package:buruan_sae_apps/utils/const_color.dart';
import 'package:buruan_sae_apps/utils/constants.dart';
import 'package:buruan_sae_apps/utils/shared_pref.dart';
import 'package:buruan_sae_apps/utils/size_config.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:modal_progress_hud/modal_progress_hud.dart';
import 'package:rflutter_alert/rflutter_alert.dart';

import 'component/custom_check_box.dart';
import '../components/widgets/custom_rounded_button.dart';
import 'component/rounded_input_field_v1.dart';

class LoginScreen extends StatefulWidget {
  static const routeName = '/';
  @override
  _LoginScreenState createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final _formkey = GlobalKey<FormState>();
  TextEditingController? emailController;
  TextEditingController? passwordController;
  TextEditingController? tokenController;

  bool _autoValidate = false;
  // bool _rememberUser = false;

  String? _errMessage = "";

  bool _isKeyboardVisible() {
    return (MediaQuery.of(context).viewInsets.bottom == 0.0);
  }

  _loginProcess(String email, String password, String? txtToken) async {
    CustomProgressDialog.show();
    final result = await AuthAPI().login(email, password, txtToken);

    if (result.getSuccess) {
      CustomProgressDialog.dismiss();
      if (txtToken == null) {
        _showModalToken();
      } else {
        if (!(await SharedPref.isExist(Constants.EMAILSAVED))) {
          await SharedPref.saveString(Constants.EMAILSAVED, email);
          await SharedPref.saveString(Constants.PASSSAVED, password);
          await SharedPref.saveString(Constants.REMEMBERME, true);
        }
        setState(() {
          _errMessage = "";
        });

        CustomSnackbarV1.showSnackbar(context, result.getMessage);
        Future.delayed(Duration(milliseconds: 500)).then((_) =>
            Navigator.pushReplacementNamed(context, Dashboard.routeName));
      }
    } else {
      if (await SharedPref.isExist(Constants.EMAILSAVED)) {
        await SharedPref.remove(Constants.LOGINTOKEN);
        await SharedPref.remove(Constants.USER);
        await SharedPref.remove(Constants.EMAILSAVED);
        await SharedPref.remove(Constants.PASSSAVED);
        await SharedPref.saveString(Constants.REMEMBERME, false);
      }
      setState(() {
        _errMessage = result.getMessage;
      });
      CustomProgressDialog.dismiss();
    }
  }

  _checkIsUserExist() async {
    if (await SharedPref.isExist(Constants.EMAILSAVED)) {
      Future.delayed(Duration(milliseconds: 500)).then(
          (_) => Navigator.pushReplacementNamed(context, Dashboard.routeName));
    }
  }

  @override
  void initState() {
    super.initState();
    emailController = TextEditingController();
    passwordController = TextEditingController();
    tokenController = TextEditingController();
    _checkIsUserExist();
  }

  @override
  void dispose() {
    super.dispose();
    emailController!.dispose();
    passwordController!.dispose();
    tokenController!.dispose();
  }

  @override
  Widget build(BuildContext context) {
    SizeConfig().init(context);
    return Scaffold(
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Stack(children: <Widget>[
            Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                Visibility(
                  visible: _isKeyboardVisible(),
                  child: Container(
                    height: SizeConfig.getHeightSize(20),
                    child: SvgPicture.asset(
                      "assets/icons/undraw_welcome_cats.svg",
                    ),
                  ),
                ),
                SizedBox(height: 12),
                Text(
                  _errMessage!,
                  style: TextStyle(
                    color: errMessage,
                    fontSize: SizeConfig.getWidthSize(3.5),
                  ),
                ),
                SizedBox(height: 12),
                Form(
                  key: _formkey,
                  autovalidateMode: _autoValidate
                      ? AutovalidateMode.always
                      : AutovalidateMode.disabled,
                  child: Column(
                    children: <Widget>[
                      RoundedInputFieldV1(
                        labelText: "Email",
                        controller: emailController,
                        keyboardType: TextInputType.emailAddress,
                        validator: (String value) {
                          if (value.isEmpty) {
                            return "Form email kosong!";
                          }
                          Pattern pattern =
                              r'^(([^<>()[\]\\.,;:\s@\"]+(\.[^<>()[\]\\.,;:\s@\"]+)*)|(\".+\"))@((\[[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\])|(([a-zA-Z\-0-9]+\.)+[a-zA-Z]{2,}))$';
                          RegExp regex = new RegExp(pattern as String);
                          if (!(regex.hasMatch(value)))
                            return "Format email salah!";
                        },
                      ),
                      SizedBox(height: 12),
                      RoundedInputFieldV1(
                        labelText: "Password",
                        controller: passwordController,
                        isPassword: true,
                        validator: (String value) {
                          if (value.isEmpty) {
                            return "Form password kosong!";
                          }
                        },
                      ),
                      // SizedBox(height: 12),
                      // Align(
                      //   alignment: Alignment.centerLeft,
                      //   child: CustomCheckBox(
                      //     label: "Ingatkan saya",
                      //     width: SizeConfig.getWidthSize(4),
                      //     height: SizeConfig.getWidthSize(4),
                      //     onChange: (value) {
                      //       setState(() {
                      //         _rememberUser = value;
                      //       });
                      //     },
                      //   ),
                      // ),
                      SizedBox(height: 12),
                      CustomRoundedButton(
                        text: "Login",
                        onPressed: () {
                          final form = _formkey.currentState!;
                          form.save();
                          if (form.validate()) {
                            FocusScope.of(context).unfocus();
                            _loginProcess(emailController!.text,
                                passwordController!.text, null);
                          }
                          setState(() {
                            _autoValidate = true;
                          });
                        },
                      ),
                    ],
                  ),
                ),
              ],
            ),
            Align(
              alignment: Alignment.bottomCenter,
              child: Text(
                "Lupa Password?",
                style: TextStyle(
                  color: kPrimaryColor,
                  fontSize: SizeConfig.getWidthSize(3.5),
                  fontWeight: FontWeight.bold,
                ),
              ),
            )
          ]),
        ),
      ),
    );
  }

  _showModalToken() {
    Alert(
        context: context,
        title: "Enter Token",
        content: Column(
          children: <Widget>[
            SizedBox(height: 6),
            RoundedInputFieldV1(
              labelText: "Token",
              controller: tokenController,
              keyboardType: TextInputType.number,
            ),
          ],
        ),
        buttons: [
          DialogButton(
            onPressed: () => {
              Navigator.pop(context),
              _loginProcess(emailController!.text, passwordController!.text,
                  tokenController!.text),
              tokenController!.clear()
            },
            color: kPrimaryColor,
            child: Text(
              "Login",
              style: TextStyle(
                  color: txtPrimaryColor, fontSize: SizeConfig.getWidthSize(5)),
            ),
          )
        ]).show();
  }
}
