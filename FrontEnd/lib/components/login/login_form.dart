import 'package:flutter/material.dart';

import '../dont_have_an_Account.dart';
import '../../constants.dart';
import '../../pages/signup_page.dart';

class LoginForm extends StatelessWidget {
  const LoginForm({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Form(
      child: Column(
        children: [
          TextFormField(
            keyboardType: TextInputType.emailAddress,
            textInputAction: TextInputAction.next,
            cursorColor: btnColor,
            onSaved: (id) {},
            decoration: InputDecoration(
              hintText: "아이디",
              hintStyle: TextStyle(color: sColor),
              prefixIcon: Padding(
                padding: const EdgeInsets.all(defaultPadding),
                child: Icon(
                  Icons.person,
                  color: sColor,
                ),
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
          ),
          Padding(
            padding: const EdgeInsets.symmetric(vertical: defaultPadding),
            child: TextFormField(
              textInputAction: TextInputAction.done,
              obscureText: true,
              cursorColor: btnColor,
              decoration: InputDecoration(
                hintText: "비밀번호",
                hintStyle: TextStyle(color: sColor),
                prefixIcon: Padding(
                  padding: const EdgeInsets.all(defaultPadding),
                  child: Icon(
                    Icons.lock,
                    color: sColor,
                  ),
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
            ),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(vertical: defaultPadding),
            child: Container(
              height: 48,
              width: double.maxFinite,
              child: Hero(
                tag: "login_btn",
                child: ElevatedButton(
                  onPressed: () {},
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
