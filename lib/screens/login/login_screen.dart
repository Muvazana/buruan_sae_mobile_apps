import 'package:buruan_sae_mobile_apps/screens/gen_components/pg_loading.dart';
import 'package:buruan_sae_mobile_apps/screens/gen_components/widgets/custom_rounded_button.dart';
import 'package:buruan_sae_mobile_apps/screens/login/componens/rounded_input_field_v1.dart';
import 'package:buruan_sae_mobile_apps/utils/const_color.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

class LoginScreen extends StatefulWidget {
  static const routeName = '/';
  @override
  _LoginScreenState createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final _formkey = GlobalKey<FormState>();
  TextEditingController? emailController;
  TextEditingController? passwordController;

  bool _autoValidate = false;
  // bool _rememberUser = false;

  String? _errMessage = "";

  bool _isKeyboardVisible() {
    return (MediaQuery.of(context).viewInsets.bottom == 0.0);
  }

  @override
  void initState() {
    super.initState();
    emailController = TextEditingController();
    passwordController = TextEditingController();
  }

  @override
  void dispose() {
    super.dispose();
    emailController!.dispose();
    passwordController!.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final _size = MediaQuery.of(context).size;
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
                    height: _size.height * 0.2,
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
                    fontSize: _size.width * 0.035,
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
                      RoundedInputFieldLogin(
                        labelText: "Email",
                        controller: emailController,
                        keyboardType: TextInputType.emailAddress,
                        validator: (String? value) {
                          if (value!.isEmpty) {
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
                      RoundedInputFieldLogin(
                        labelText: "Password",
                        controller: passwordController,
                        isPassword: true,
                        validator: (String? value) {
                          if (value!.isEmpty) {
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
                          // final form = _formkey.currentState!;
                          // form.save();
                          // if (form.validate()) {
                          //   FocusScope.of(context).unfocus();
                          //   // _loginProcess(emailController!.text,
                          //   //     passwordController!.text);
                          // }
                          // setState(() {
                          //   _autoValidate = true;
                          // });
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
                  fontSize: _size.width * 0.035,
                  fontWeight: FontWeight.bold,
                ),
              ),
            )
          ]),
        ),
      ),
    );
  }
}
