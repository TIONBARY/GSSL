import 'dart:io';

import 'package:GSSL/api/api_signup.dart';
import 'package:GSSL/model/request_models/signup.dart';
import 'package:GSSL/model/response_models/general_response.dart';
import 'package:GSSL/pages/login_page.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:image_picker/image_picker.dart';

import '../../constants.dart';
import '../util/custom_dialog.dart';

class SignUpForm extends StatefulWidget {
  const SignUpForm({
    Key? key,
  }) : super(key: key);

  @override
  State<SignUpForm> createState() => _SignupFormState();
}

class _SignupFormState extends State<SignUpForm> {
  final SignupFormKey = GlobalKey<FormState>();

  String? member_id = '';
  String? password = '';
  String? nickname = '';
  String? gender = 'M';
  String? phone = '';
  String? email = '';
  XFile? profileImage;
  String? introduce = '';
  generalResponse? signup;
  ApiSignup apiSignup = ApiSignup();

  bool checkDupId = false;
  bool checkDupNickname = false;

  final picker = ImagePicker();

  Future<void> chooseImage() async {
    var choosedimage = await picker.pickImage(source: ImageSource.gallery);
    //set source: ImageSource.camera to get image from camera
    setState(() {
      profileImage = choosedimage;
    });
  }

  @override
  void initState() {
    super.initState();
  }

  bool _submitted = false;

  void _submit() async {
    // set this variable to true when we try to submit
    setState(() => _submitted = true);
    if (checkDupId &&
        checkDupNickname &&
        SignupFormKey.currentState!.validate()) {
      SignupFormKey.currentState!.save();
      generalResponse result = await apiSignup.signup(
          profileImage,
          Signup(
              memberId: member_id,
              password: password,
              nickname: nickname,
              gender: gender,
              phone: phone,
              email: email,
              introduce: introduce));
      if (result.statusCode == 201) {
        showDialog(
            context: context,
            builder: (BuildContext context) {
              return CustomDialog("회원가입에 성공했습니다.", (context) => LoginScreen());
            });
      } else {
        showDialog(
            context: context,
            builder: (BuildContext context) {
              return CustomDialog(result.message!, null);
            });
      }
    } else {
      showDialog(
          context: context,
          builder: (BuildContext context) {
            return CustomDialog("필수 정보를 입력해주세요.", null);
          });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Form(
      key: SignupFormKey,
      child: Column(
        children: [
          Padding(
            padding: const EdgeInsets.fromLTRB(0, 25, 0, 0),
            child: TextFormField(
              // 아이디
              style: TextStyle(fontFamily: "Daehan"),
              keyboardType: TextInputType.text,
              textInputAction: TextInputAction.next,
              cursorColor: btnColor,
              onChanged: (val) {
                member_id = val;
                setState(() => checkDupId = false);
              },
              autovalidateMode: _submitted
                  ? AutovalidateMode.onUserInteraction
                  : AutovalidateMode.disabled,
              validator: (text) {
                if (text == null || text.isEmpty) {
                  return '아이디를 입력해주세요.';
                }
                if (!RegExp(r"^(?=.*[A-Za-z])(?=.*\d)[A-Za-z\d]{5,20}$")
                    .hasMatch(text)) {
                  return '영문과 숫자를 포함해 5 ~ 20자를 입력해주세요.';
                }
                if (!checkDupId) {
                  return '아이디 중복검사를 해주세요.';
                }
                return null;
              },
              decoration: InputDecoration(
                isCollapsed: true,
                hintText: "아이디",
                hintStyle: TextStyle(color: sColor, fontFamily: "Daehan"),
                contentPadding: EdgeInsets.fromLTRB(20.w, 10.h, 10.w, 10.h),
                enabledBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.all(Radius.circular(10)),
                    borderSide: BorderSide(color: sColor)),
                filled: true,
                fillColor: Colors.white,
                focusedBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.all(Radius.circular(10)),
                    borderSide: BorderSide(color: btnColor)),
                suffix: ElevatedButton(
                  onPressed: () async {
                    // 아이디 중복검사
                    print(member_id);
                    setState(() => _submitted = true);
                    if (member_id == null ||
                        member_id!.isEmpty ||
                        !RegExp(r"^(?=.*[A-Za-z])(?=.*\d)[A-Za-z\d]{5,20}$")
                            .hasMatch(member_id!)) {
                      return;
                    }
                    generalResponse result = await apiSignup.checkId(member_id);
                    print(result.statusCode);
                    print(result.message);
                    if (result?.statusCode == 200) {
                      setState(() => checkDupId = true);
                      showDialog(
                          context: context,
                          builder: (BuildContext context) {
                            return CustomDialog("사용 가능한 아이디입니다.", null);
                          });
                    } else {
                      setState(() => checkDupId = false);
                      showDialog(
                          context: context,
                          builder: (BuildContext context) {
                            return CustomDialog(result.message!, null);
                          });
                    }
                  },
                  style: ElevatedButton.styleFrom(
                    padding: EdgeInsets.all(0),
                    backgroundColor: btnColor,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(5.0),
                    ),
                    tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                  ),
                  child: Text(
                    "중복검사".toUpperCase(),
                    style: TextStyle(
                      fontFamily: "Daehan",
                    ),
                  ),
                ),
              ),
            ),
          ),
          Padding(
            // 비밀번호
            padding: const EdgeInsets.symmetric(vertical: defaultPadding),
            child: TextFormField(
              style: TextStyle(fontFamily: "Daehan"),
              keyboardType: TextInputType.text,
              textInputAction: TextInputAction.done,
              obscureText: true,
              cursorColor: btnColor,
              onChanged: (val) {
                password = val;
              },
              autovalidateMode: _submitted
                  ? AutovalidateMode.onUserInteraction
                  : AutovalidateMode.disabled,
              validator: (text) {
                if (text == null || text.isEmpty) {
                  return '비밀번호를 입력해주세요.';
                }
                if (!RegExp(
                        r"^(?=.*[A-Za-z])(?=.*\d)(?=.*[@$!%*?&])[A-Za-z\d@$!%*?&]{8,16}$")
                    .hasMatch(text)) {
                  return '영문과 숫자, 특수문자를 포함해 8 ~ 16자를 입력해주세요.';
                }
                return null;
              },
              decoration: InputDecoration(
                isCollapsed: true,
                hintText: "비밀번호",
                hintStyle: TextStyle(color: sColor, fontFamily: "Daehan"),
                contentPadding: EdgeInsets.fromLTRB(20.w, 10.h, 10.w, 10.h),
                enabledBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.all(Radius.circular(10)),
                    borderSide: BorderSide(color: sColor)),
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
            style: TextStyle(fontFamily: "Daehan"),
            keyboardType: TextInputType.text,
            textInputAction: TextInputAction.next,
            cursorColor: btnColor,
            onChanged: (val) {
              nickname = val;
              setState(() => checkDupNickname = false);
            },
            autovalidateMode: _submitted
                ? AutovalidateMode.onUserInteraction
                : AutovalidateMode.disabled,
            validator: (text) {
              if (text == null || text.isEmpty || text.length > 10) {
                return '닉네임을 10자 이내로 입력해주세요.';
              }
              if (!checkDupNickname) {
                return '닉네임 중복검사를 해주세요.';
              }
              return null;
            },
            decoration: InputDecoration(
              isCollapsed: true,
              hintText: "닉네임",
              hintStyle: TextStyle(color: sColor, fontFamily: "Daehan"),
              contentPadding: EdgeInsets.fromLTRB(20.w, 10.h, 10.w, 10.h),
              enabledBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.all(Radius.circular(10)),
                  borderSide: BorderSide(color: sColor)),
              filled: true,
              fillColor: Colors.white,
              focusedBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.all(Radius.circular(10)),
                  borderSide: BorderSide(color: btnColor)),
              suffix: ElevatedButton(
                onPressed: () async {
                  // 아이디 중복검사
                  print(nickname);
                  setState(() => _submitted = true);
                  if (nickname == null ||
                      nickname!.isEmpty ||
                      nickname!.length > 10) {
                    return;
                  }
                  generalResponse result =
                      await apiSignup.checkNickname(nickname);
                  print(result.statusCode);
                  print(result.message);
                  if (result?.statusCode == 200) {
                    setState(() => checkDupNickname = true);
                    showDialog(
                      context: context,
                      builder: (BuildContext context) {
                        return CustomDialog("사용 가능한 닉네임입니다.", null);
                      },
                    );
                  } else {
                    checkDupNickname = false;
                    showDialog(
                        context: context,
                        builder: (BuildContext context) {
                          return CustomDialog(result.message!, null);
                        });
                  }
                },
                style: ElevatedButton.styleFrom(
                  padding: EdgeInsets.all(0),
                  backgroundColor: btnColor,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(5.0),
                  ),
                  tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                ),
                child: Text(
                  "중복검사".toUpperCase(),
                  style: TextStyle(
                    fontFamily: "Daehan",
                  ),
                ),
              ),
            ),
          ),
          Padding(
              // 성별
              padding: const EdgeInsets.symmetric(vertical: defaultPadding / 2),
              child: Column(children: <Widget>[
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: [
                    Expanded(
                        child: ListTile(
                      title: const Text(
                        '남자',
                        style: TextStyle(color: btnColor, fontFamily: "Daehan"),
                      ),
                      leading: Radio<String>(
                        value: "M",
                        groupValue: gender,
                        fillColor: MaterialStateColor.resolveWith(
                            (states) => btnColor),
                        onChanged: (String? value) {
                          setState(() {
                            gender = value;
                          });
                        },
                      ),
                    )),
                    Expanded(
                        child: ListTile(
                      title: const Text(
                        '여자',
                        style: TextStyle(color: btnColor, fontFamily: "Daehan"),
                      ),
                      leading: Radio<String>(
                        value: "F",
                        groupValue: gender,
                        fillColor: MaterialStateColor.resolveWith(
                            (states) => btnColor),
                        onChanged: (String? value) {
                          setState(() {
                            gender = value;
                          });
                        },
                      ),
                    )),
                  ],
                )
              ])),
          TextFormField(
            // 전화번호
            style: TextStyle(fontFamily: "Daehan"),
            keyboardType: TextInputType.number,
            textInputAction: TextInputAction.next,
            cursorColor: btnColor,
            onChanged: (val) {
              phone = val;
            },
            autovalidateMode: _submitted
                ? AutovalidateMode.onUserInteraction
                : AutovalidateMode.disabled,
            validator: (text) {
              if (text == null ||
                  text.length < 10 ||
                  text.length > 11 ||
                  !RegExp(r'^010?([0-9]{4})?([0-9]{4})$').hasMatch(text)) {
                return '전화번호를 입력해주세요.';
              }
              return null;
            },
            decoration: InputDecoration(
              isCollapsed: true,
              hintText: "전화번호",
              hintStyle: TextStyle(color: sColor, fontFamily: "Daehan"),
              contentPadding: EdgeInsets.fromLTRB(20.w, 10.h, 10.w, 10.h),
              enabledBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.all(Radius.circular(10)),
                  borderSide: BorderSide(color: sColor)),
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
              style: TextStyle(fontFamily: "Daehan"),
              textInputAction: TextInputAction.done,
              keyboardType: TextInputType.emailAddress,
              obscureText: false,
              cursorColor: btnColor,
              onChanged: (val) {
                email = val;
              },
              autovalidateMode: _submitted
                  ? AutovalidateMode.onUserInteraction
                  : AutovalidateMode.disabled,
              validator: (text) {
                if (text == null ||
                    text.isEmpty ||
                    text.length > 50 ||
                    !RegExp(r"^[a-zA-Z0-9.a-zA-Z0-9.!#$%&'*+-/=?^_`{|}~]+@[a-zA-Z0-9]+\.[a-zA-Z]+")
                        .hasMatch(text)) {
                  return '이메일을 입력해주세요.';
                }
                return null;
              },
              decoration: InputDecoration(
                isCollapsed: true,
                hintText: "이메일",
                hintStyle: TextStyle(color: sColor, fontFamily: "Daehan"),
                contentPadding: EdgeInsets.fromLTRB(20.w, 10.h, 10.w, 10.h),
                enabledBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.all(Radius.circular(10)),
                    borderSide: BorderSide(color: sColor)),
                filled: true,
                fillColor: Colors.white,
                focusedBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.all(Radius.circular(10)),
                    borderSide: BorderSide(color: btnColor)),
              ),
            ),
          ),
          Container(
              margin: EdgeInsets.fromLTRB(0, 0, 0, 10),
              child: Divider(color: sColor, thickness: 2.0)),
          Column(
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  Container(
                    // color: const Color(0xffd0cece),
                    width: MediaQuery.of(context).size.width / 5,
                    height: MediaQuery.of(context).size.width / 5,
                    child: Center(
                        child: profileImage == null
                            ? Text('')
                            : new CircleAvatar(
                                backgroundImage:
                                    new FileImage(File(profileImage!.path)),
                                radius: 200.0,
                              )),
                    decoration:
                        BoxDecoration(color: sColor, shape: BoxShape.circle),
                  ),
                  Container(
                    child: ElevatedButton.icon(
                      onPressed: () {
                        chooseImage(); // call choose image function
                      },
                      icon: Icon(Icons.image),
                      style: ElevatedButton.styleFrom(
                          backgroundColor: btnColor,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(5.0),
                          )),
                      label: Text(
                        "프로필 이미지 (선택)",
                        style: TextStyle(
                          fontFamily: "Daehan",
                        ),
                      ),
                    ),
                  ),
                ],
              )
            ],
          ),
          Padding(
            // 자기소개
            padding: const EdgeInsets.symmetric(vertical: defaultPadding),
            child: TextFormField(
              style: TextStyle(fontFamily: "Daehan"),
              keyboardType: TextInputType.multiline,
              maxLines: 4,
              textInputAction: TextInputAction.done,
              cursorColor: btnColor,
              onChanged: (val) {
                introduce = val;
              },
              autovalidateMode: _submitted
                  ? AutovalidateMode.onUserInteraction
                  : AutovalidateMode.disabled,
              validator: (text) {
                if (text == null) {
                  return null;
                }
                if (text.length > 1000) {
                  return '자기소개는 최대 1000자까지 입력할 수 있어요.';
                }
                return null;
              },
              decoration: InputDecoration(
                isCollapsed: true,
                hintText: "자기소개 (선택)",
                hintStyle: TextStyle(color: sColor, fontFamily: "Daehan"),
                contentPadding: EdgeInsets.fromLTRB(20.w, 20.h, 20.w, 20.h),
                enabledBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.all(Radius.circular(10)),
                    borderSide: BorderSide(color: sColor)),
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
                tag: "signUp_btn",
                child: ElevatedButton(
                  onPressed: () {
                    _submit();
                  },
                  style: ElevatedButton.styleFrom(
                      backgroundColor: btnColor,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(25.0),
                      )),
                  child: Text(
                    "회원가입".toUpperCase(),
                    style: TextStyle(
                      fontFamily: "Daehan",
                    ),
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
