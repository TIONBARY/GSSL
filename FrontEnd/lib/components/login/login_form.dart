import 'package:GSSL/components/bottomNavBar.dart';
import 'package:GSSL/model/request_models/login.dart';
import 'package:GSSL/model/response_models/login_post.dart';
import 'package:GSSL/pages/main_page.dart';
import 'package:flutter/material.dart';

import '../dont_have_an_Account.dart';
import '../../constants.dart';
import '../../pages/signup_page.dart';

import '../../api/api_login.dart';

class LoginForm extends StatefulWidget {
  const LoginForm({
    Key? key,
  }) : super(key: key);

  @override
  State<LoginForm> createState() => _LoginFormState();
}

class _LoginFormState extends State<LoginForm> {
  final loginFormKey = GlobalKey<FormState>();

  String id = '';
  String pw = '';
  Future<LoginResponseModel>? loginAuth;
  ApiLogin apiLogin = ApiLogin();

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Form(
      key: this.loginFormKey,
      child: Column(
        children: [
          renderTextFormField(
              label: '아이디',
              icon: Icon(Icons.person, color: sColor),
              onSaved: (val) {
                id = val;
              }),
          Padding(
              padding: const EdgeInsets.symmetric(vertical: defaultPadding),
              child: renderTextFormField(
                  label: '비밀번호',
                  icon: Icon(Icons.lock, color: sColor),
                  onSaved: (val) {
                    pw = val;
                  })),
          Padding(
            padding: const EdgeInsets.symmetric(vertical: defaultPadding),
            child: Container(
              height: 48,
              width: double.maxFinite,
              child: Hero(
                tag: "login_btn",
                child: ElevatedButton(
                  onPressed: () async {
                    if (mounted) {
                      loginFormKey.currentState?.save();
                      loginAuth = apiLogin
                          .login(LoginRequestModel(id: id, password: pw));
                      Navigator.push(context,
                          MaterialPageRoute(builder: (context) => BottomNavBar()));
                    }
                  },
                  style: ElevatedButton.styleFrom(
                      backgroundColor: btnColor,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(25.0),
                      )),
                  child: Text(
                    "로그인".toUpperCase(),
                  ),
                ),
              ),
            ),
          ),
          const SizedBox(height: defaultPadding),
          DontHaveAnAccount(
            press: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) {
                    return SignUpScreen();
                  },
                ),
              );
            },
          ),
        ],
      ),
    );
  }
}

renderTextFormField({
  required String label,
  required Icon icon,
  required FormFieldSetter onSaved,
}) {
  assert(label != null);
  assert(onSaved != null);

  return TextFormField(
    keyboardType: TextInputType.text,
    textInputAction: TextInputAction.next,
    cursorColor: btnColor,
    onSaved: onSaved,
    decoration: InputDecoration(
      hintText: label,
      hintStyle: TextStyle(color: sColor),
      prefixIcon: Padding(
        padding: const EdgeInsets.all(defaultPadding),
        child: icon,
      ),
      enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.all(Radius.circular(10)),
          borderSide: BorderSide(color: Colors.white)),
      filled: true,
      fillColor: Colors.white,
      focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.all(Radius.circular(10)),
          borderSide: BorderSide(color: btnColor)),
    ),
  );
}
