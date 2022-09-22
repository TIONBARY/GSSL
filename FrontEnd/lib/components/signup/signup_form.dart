import 'package:flutter/material.dart';

import '../dont_have_an_Account.dart';
import '../../constants.dart';
import '../../pages/login_page.dart';

class SignUpForm extends StatelessWidget {
  const SignUpForm({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Form(
      child: Column(
        children: [
          TextFormField(
            textInputAction: TextInputAction.next,
            cursorColor: kPrimaryColor,
            onSaved: (email) {},
            decoration: InputDecoration(
              hintText: "아이디",
              prefixIcon: Padding(
                padding: const EdgeInsets.all(defaultPadding),
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(),
            child: TextFormField(
              textInputAction: TextInputAction.next,
              obscureText: true,
              cursorColor: kPrimaryColor,
              decoration: InputDecoration(
                hintText: "비밀번호",
                prefixIcon: Padding(
                  padding: const EdgeInsets.all(defaultPadding),
                ),
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(),
            child: TextFormField(
              keyboardType: TextInputType.name,
              textInputAction: TextInputAction.next,
              obscureText: true,
              cursorColor: kPrimaryColor,
              decoration: InputDecoration(
                hintText: "닉네임",
                prefixIcon: Padding(
                  padding: const EdgeInsets.all(defaultPadding),
                ),
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(),
            child: TextFormField(
              textInputAction: TextInputAction.next,
              obscureText: true,
              cursorColor: kPrimaryColor,
              decoration: InputDecoration(
                hintText: "성별",
                prefixIcon: Padding(
                  padding: const EdgeInsets.all(defaultPadding),
                ),
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(),
            child: TextFormField(
              keyboardType: TextInputType.phone,
              textInputAction: TextInputAction.next,
              obscureText: true,
              cursorColor: kPrimaryColor,
              decoration: InputDecoration(
                hintText: "전화번호",
                prefixIcon: Padding(
                  padding: const EdgeInsets.all(defaultPadding),
                ),
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(),
            child: TextFormField(
              keyboardType: TextInputType.emailAddress,
              textInputAction: TextInputAction.next,
              obscureText: true,
              cursorColor: kPrimaryColor,
              decoration: InputDecoration(
                hintText: "이메일",
                prefixIcon: Padding(
                  padding: const EdgeInsets.all(defaultPadding),
                ),
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(),
            child: TextFormField(
              textInputAction: TextInputAction.next,
              obscureText: true,
              cursorColor: kPrimaryColor,
              decoration: InputDecoration(
                hintText: "프로필(선택)",
                prefixIcon: Padding(
                  padding: const EdgeInsets.all(defaultPadding),
                ),
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(),
            child: TextFormField(
              keyboardType: TextInputType.multiline,
              textInputAction: TextInputAction.done,
              obscureText: true,
              cursorColor: kPrimaryColor,
              decoration: InputDecoration(
                hintText: "자기소개(선택)",
                prefixIcon: Padding(
                  padding: const EdgeInsets.all(defaultPadding),
                ),
              ),
            ),
          ),
          
          const SizedBox(height: defaultPadding / 2),
          ElevatedButton(
            onPressed: () {},
            child: Text("회원가입".toUpperCase()),
          ),
          const SizedBox(height: defaultPadding),
        ],
      ),
    );
  }
}