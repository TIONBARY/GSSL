import 'package:flutter/material.dart';
import 'package:GSSL/constants.dart';

class DontHaveAnAccount extends StatelessWidget {
  final bool login;
  final Function? press;
  const DontHaveAnAccount({
    Key? key,
    this.login = true,
    required this.press,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: <Widget>[
        Text(
          login ? " 계정이 없으신가요? " : "Already have an Account ? ",
          style: const TextStyle(color: btnColor),
        ),
        GestureDetector(
          onTap: press as void Function()?,
          child: Text(
            login ? " 회원가입 " : "Sign In",
            style: const TextStyle(
              color: btnColor,
              fontWeight: FontWeight.bold,
            ),
          ),
        )
      ],
    );
  }
}
