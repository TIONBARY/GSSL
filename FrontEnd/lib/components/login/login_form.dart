import 'package:GSSL/components/bottomNavBar.dart';
import 'package:GSSL/components/util/custom_dialog.dart';
import 'package:GSSL/model/request_models/put_login.dart';
import 'package:GSSL/model/response_models/general_response.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../api/api_login.dart';
import '../../constants.dart';
import '../../pages/signup_page.dart';
import '../dont_have_an_Account.dart';

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
  generalResponse? loginAuth;
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
          renderLoginTextFormField(
              hint: '아이디',
              icon: Icon(Icons.person, color: sColor),
              onChanged: (val) {
                id = val;
              },
              obscureText: false),
          Padding(
              padding: const EdgeInsets.symmetric(vertical: defaultPadding),
              child: renderLoginTextFormField(
                  hint: '비밀번호',
                  icon: Icon(Icons.lock, color: sColor),
                  onChanged: (val) {
                    pw = val;
                  },
                  obscureText: true)),
          Padding(
            padding: const EdgeInsets.symmetric(vertical: defaultPadding),
            child: Container(
              height: 40.h,
              width: double.maxFinite,
              child: Hero(
                tag: "login_btn",
                child: ElevatedButton(
                  onPressed: () async {
                    if (mounted) {
                      print(id!);
                      print(pw!);
                      if (id!.length != 0 && pw!.length != 0) {
                        loginFormKey.currentState?.save();
                        loginAuth = await apiLogin
                            .login(LoginRequestModel(id: id, password: pw));
                        if (loginAuth?.statusCode == 200) {
                          Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (context) => BottomNavBar()));
                        } else {
                          showDialog(
                              context: context,
                              builder: (BuildContext context) {
                                return CustomDialog(
                                    loginAuth?.message == null
                                        ? "알 수 없는 오류가 발생했습니다."
                                        : loginAuth!.message!,
                                    null);
                              });
                        }
                      } else {
                        showDialog(
                            context: context,
                            builder: (BuildContext context) {
                              return CustomDialog("아이디 또는 비밀번호를 입력해주세요.", null);
                            });
                      }
                    }
                  },
                  style: ElevatedButton.styleFrom(
                      backgroundColor: btnColor,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(25.0),
                      )),
                  child: Text(
                    "로그인".toUpperCase(),
                    style: TextStyle(
                      fontFamily: "Sub",
                      fontWeight: FontWeight.bold,
                    ),
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

renderLoginTextFormField({
  required String hint,
  required Icon icon,
  required FormFieldSetter onChanged,
  required bool obscureText,
}) {
  assert(hint != null);
  assert(onChanged != null);

  return TextFormField(
    keyboardType: TextInputType.text,
    textInputAction: TextInputAction.next,
    style: TextStyle(fontFamily: "Sub"),
    cursorColor: btnColor,
    onChanged: onChanged,
    obscureText: obscureText,
    decoration: InputDecoration(
      contentPadding: EdgeInsets.all(10.h),
      hintText: hint,
      hintStyle: TextStyle(
        color: sColor,
        fontFamily: "Sub",
      ),
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
