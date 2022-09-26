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
  LoginRequestModel? userAuth;

  Future<LoginResponseModel>? loginAuth;

  @override
  void initState(){
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Form(
      key: this.loginFormKey,
      child: Column(
        children: [
          renderTextFormField(label: '아이디', icon: Icon(Icons.person), onSaved: (val){
            this.id = val;
            this.userAuth?.id = val;
          }),
          Padding(
            padding: const EdgeInsets.symmetric(vertical: defaultPadding),
            child: renderTextFormField(label: '비밀번호', icon: Icon(Icons.password), onSaved: (val){
              this.pw = val;
              this.userAuth?.password = val;
            })
          ),
          const SizedBox(height: defaultPadding),
          Hero(
            tag: "login_btn",
            child: ElevatedButton(
              onPressed: () async {
                if(mounted) {
                  loginFormKey.currentState?.save();
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => MainPage())
                  );
              }
              },
              child: Text(
                "로그인".toUpperCase(),
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

renderTextFormField({required String label, required Icon icon, required FormFieldSetter onSaved,})
{
  assert(label != null);
  assert(onSaved != null);

  return TextFormField(
    keyboardType: TextInputType.text,
    textInputAction: TextInputAction.next,
    cursorColor: kPrimaryColor,
    onSaved: onSaved,
    decoration: InputDecoration(
      hintText: label,
      prefixIcon: Padding(
        padding: const EdgeInsets.all(defaultPadding),
        child: icon,
      ),
    ),
  );
}