import 'package:flutter/material.dart';

import '../../constants.dart';
import '../../pages/signup_pet_page.dart';

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
            // 아이디
            keyboardType: TextInputType.emailAddress,
            textInputAction: TextInputAction.next,
            cursorColor: btnColor,
            onSaved: (id) {},
            decoration: InputDecoration(
              hintText: "아이디",
              hintStyle: TextStyle(color: sColor),
              prefixIcon: Padding(
                padding: const EdgeInsets.all(defaultPadding),
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
            // 비밀번호
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
          TextFormField(
            // 닉네임
            keyboardType: TextInputType.emailAddress,
            textInputAction: TextInputAction.next,
            cursorColor: btnColor,
            onSaved: (id) {},
            decoration: InputDecoration(
              hintText: "닉네임",
              hintStyle: TextStyle(color: sColor),
              prefixIcon: Padding(
                padding: const EdgeInsets.all(defaultPadding),
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
            // 성별
            padding: const EdgeInsets.symmetric(vertical: defaultPadding),
            child: TextFormField(
              textInputAction: TextInputAction.done,
              obscureText: true,
              cursorColor: btnColor,
              decoration: InputDecoration(
                hintText: "성별",
                hintStyle: TextStyle(color: sColor),
                prefixIcon: Padding(
                  padding: const EdgeInsets.all(defaultPadding),
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
          TextFormField(
            // 전화번호
            keyboardType: TextInputType.emailAddress,
            textInputAction: TextInputAction.next,
            cursorColor: btnColor,
            onSaved: (id) {},
            decoration: InputDecoration(
              hintText: "전화번호",
              hintStyle: TextStyle(color: sColor),
              prefixIcon: Padding(
                padding: const EdgeInsets.all(defaultPadding),
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
            // 이메일
            padding: const EdgeInsets.symmetric(vertical: defaultPadding),
            child: TextFormField(
              textInputAction: TextInputAction.done,
              obscureText: true,
              cursorColor: btnColor,
              decoration: InputDecoration(
                hintText: "이메일",
                hintStyle: TextStyle(color: sColor),
                prefixIcon: Padding(
                  padding: const EdgeInsets.all(defaultPadding),
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
          TextFormField(
            // 프로필 사진
            keyboardType: TextInputType.emailAddress,
            textInputAction: TextInputAction.next,
            cursorColor: btnColor,
            onSaved: (id) {},
            decoration: InputDecoration(
              hintText: "프로필 사진 (선택)",
              hintStyle: TextStyle(color: sColor),
              prefixIcon: Padding(
                padding: const EdgeInsets.all(defaultPadding),
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
            // 자기소개
            padding: const EdgeInsets.symmetric(vertical: defaultPadding),
            child: TextFormField(
              textInputAction: TextInputAction.done,
              obscureText: true,
              cursorColor: btnColor,
              decoration: InputDecoration(
                hintText: "자기소개 (선택)",
                hintStyle: TextStyle(color: sColor),
                prefixIcon: Padding(
                  padding: const EdgeInsets.all(defaultPadding),
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
                tag: "next_btn",
                child: ElevatedButton(
                  onPressed: () {
                  },
                  style: ElevatedButton.styleFrom(
                      backgroundColor: btnColor,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(25.0),
                      )),
                  child: Text(
                    "회원가입".toUpperCase(),
                  ),
                ),
              ),
            ),
          ),
          const SizedBox(height: defaultPadding / 2),
        ],
      ),
    );
  }
}

