import 'dart:io';

import 'package:GSSL/api/api_signup.dart';
import 'package:GSSL/api/api_user.dart';
import 'package:GSSL/components/bottomNavBar.dart';
import 'package:GSSL/model/request_models/update_user.dart';
import 'package:GSSL/model/response_models/general_response.dart';
import 'package:GSSL/model/response_models/user_info.dart';
import 'package:GSSL/pages/login_page.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:http/http.dart';
import 'package:image_picker/image_picker.dart';
import 'package:path_provider/path_provider.dart';

import '../../constants.dart';
import '../util/custom_dialog.dart';

class ModifyForm extends StatefulWidget {
  const ModifyForm({
    Key? key,
  }) : super(key: key);

  @override
  State<ModifyForm> createState() => _ModifyFormState();
}

class _ModifyFormState extends State<ModifyForm> {
  final ModifyFormKey = GlobalKey<FormState>();
  User? user;
  String S3Address = "https://a204drdoc.s3.ap-northeast-2.amazonaws.com/";
  String? member_id = '';
  String? password = '';
  String? nickname = '';
  String? gender = 'M';
  String? phone = '';
  String? email = '';
  File? profileImage;
  String? introduce = '';
  generalResponse? modify;
  TextEditingController nicknameController = TextEditingController();
  ApiSignup apiSignup = ApiSignup();
  ApiUser apiUser = ApiUser();

  bool checkDupId = true;
  bool checkDupNickname = true;

  bool _loading = true;

  final picker = ImagePicker();

  Future<void> chooseImage() async {
    var choosedimage = await picker.pickImage(source: ImageSource.gallery);
    //set source: ImageSource.camera to get image from camera
    setState(() {
      profileImage = File(choosedimage!.path);
    });
  }

  Future<void> getUser() async {
    userInfo? userInfoResponse = await apiUser.getUserInfo();
    if (userInfoResponse.statusCode == 200) {
      setState(() {
        user = userInfoResponse.user;
        member_id = user?.memberId;
        nickname = user?.nickname;
        gender = user?.gender;
        phone = user?.phone;
        email = user?.email;
        introduce = user?.introduce;
        nicknameController = TextEditingController()
          ..text = nickname == null || nickname!.length == 0 ? "" : nickname!;
      });
      if (user?.profilePic == null || user!.profilePic!.length == 0) return;
      final url = S3Address + user!.profilePic!; // <-- 1
      final response = await get(Uri.parse(url)); // <--2
      final documentDirectory = await getApplicationDocumentsDirectory();
      final firstPath = documentDirectory.path + "/images";
      final filePathAndName =
          documentDirectory.path + '/images/' + user!.profilePic!;
      //comment out the next three lines to prevent the image from being saved
      //to the device to show that it's coming from the internet
      await Directory(firstPath).create(recursive: true); // <-- 1
      File file2 = new File(filePathAndName); // <-- 2
      file2.writeAsBytesSync(response.bodyBytes); // <-- 3
      setState(() {
        profileImage = file2;
        _loading = false;
      });
    } else if (userInfoResponse.statusCode == 401) {
      showDialog(
          context: context,
          builder: (BuildContext context) {
            return CustomDialog("로그인이 필요합니다.", (context) => LoginScreen());
          });
    } else {
      showDialog(
          context: context,
          builder: (BuildContext context) {
            return CustomDialog(
                userInfoResponse.message == null
                    ? "알 수 없는 오류가 발생했습니다."
                    : userInfoResponse.message!,
                (context) => BottomNavBar());
          });
    }
  }

  Future<void> quit() async {
    generalResponse? quitResponse = await apiUser.quitAPI();
    if (quitResponse.statusCode == 200) {
      showDialog(
          context: context,
          builder: (BuildContext context) {
            return CustomDialog("회원탈퇴를 완료했습니다.", (context) => LoginScreen());
          });
    } else if (quitResponse.statusCode == 401) {
      showDialog(
          context: context,
          builder: (BuildContext context) {
            return CustomDialog("로그인이 필요합니다.", (context) => LoginScreen());
          });
    } else {
      showDialog(
          context: context,
          builder: (BuildContext context) {
            return CustomDialog(
                quitResponse.message == null
                    ? "알 수 없는 오류가 발생했습니다."
                    : quitResponse.message!,
                null);
          });
    }
  }

  @override
  void initState() {
    super.initState();
    getUser();
  }

  bool _submitted = false;

  void _submit() async {
    // set this variable to true when we try to submit
    setState(() => _submitted = true);
    if (password == null || password!.length == 0) {
      showDialog(
          context: context,
          builder: (BuildContext context) {
            return CustomDialog("비밀번호를 입력해주세요.", null);
          });
      return;
    }
    if (checkDupId &&
        checkDupNickname &&
        ModifyFormKey.currentState!.validate()) {
      ModifyFormKey.currentState!.save();
      generalResponse result = await apiUser.modify(
          profileImage,
          updateUser(
              memberId: member_id,
              password: password,
              nickname: nickname,
              gender: gender,
              phone: phone,
              email: email,
              introduce: introduce,
              petId: user!.petId!));
      if (result.statusCode == 200) {
        showDialog(
            context: context,
            builder: (BuildContext context) {
              return CustomDialog(
                  "회원정보 수정에 성공했습니다.", (context) => BottomNavBar());
            });
      } else if (result.statusCode == 401) {
        showDialog(
            context: context,
            builder: (BuildContext context) {
              return CustomDialog("로그인이 필요합니다.", (context) => LoginScreen());
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
    if (_loading) {
      return Container(
          margin: EdgeInsets.fromLTRB(0, 130.h, 0, 0),
          child: Column(children: [
            Padding(
                padding: const EdgeInsets.symmetric(vertical: defaultPadding),
                child: Center(
                    child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Image.asset("assets/images/loadingDog.gif"),
                  ],
                ))),
          ]));
    } else {
      return Form(
        key: ModifyFormKey,
        child: Column(
          children: [
            Padding(
              // 비밀번호
              padding: const EdgeInsets.symmetric(vertical: defaultPadding),
              child: TextFormField(
                style: TextStyle(fontFamily: "Sub"),
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
                    return '영문과 숫자, 특수문자를 포함한 8 ~ 16자';
                  }
                  return null;
                },
                decoration: InputDecoration(
                  isCollapsed: true,
                  hintText: "비밀번호",
                  hintStyle: TextStyle(color: sColor, fontFamily: "Sub"),
                  contentPadding: EdgeInsets.fromLTRB(20.w, 17.h, 10.w, 17.h),
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
              style: TextStyle(fontFamily: "Sub"),
              controller: nicknameController,
              keyboardType: TextInputType.text,
              textInputAction: TextInputAction.next,
              cursorColor: btnColor,
              onChanged: (val) {
                final value = TextSelection.collapsed(
                    offset: nicknameController.text.length);
                nicknameController.selection = value;
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
                hintStyle: TextStyle(color: sColor, fontFamily: "Sub"),
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
                    // 닉네임 중복검사
                    setState(() => _submitted = true);
                    if (nickname == null ||
                        nickname!.isEmpty ||
                        nickname!.length > 10) {
                      return;
                    }
                    if (nickname == user!.nickname!) {
                      setState(() => checkDupNickname = true);
                      showDialog(
                          context: context,
                          builder: (BuildContext context) {
                            return CustomDialog("사용 가능한 닉네임입니다.", null);
                          });
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
                      fontFamily: "Sub",
                    ),
                  ),
                ),
              ),
            ),
            Padding(
                // 성별
                padding:
                    const EdgeInsets.symmetric(vertical: defaultPadding / 2),
                child: Column(children: <Widget>[
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    children: [
                      Expanded(
                          child: ListTile(
                        title: const Text(
                          '남자',
                          style: TextStyle(color: btnColor, fontFamily: "Sub"),
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
                          style: TextStyle(color: btnColor, fontFamily: "Sub"),
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
              style: TextStyle(fontFamily: "Sub"),
              controller: TextEditingController()
                ..text = phone == null || phone!.length == 0 ? "" : phone!,
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
                hintText: "전화번호 (01011112222) 형태로 입력",
                hintStyle: TextStyle(color: sColor, fontFamily: "Sub"),
                contentPadding: EdgeInsets.fromLTRB(20.w, 17.h, 10.w, 17.h),
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
                style: TextStyle(fontFamily: "Sub"),
                controller: TextEditingController()
                  ..text = email == null || email!.length == 0 ? "" : email!,
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
                  hintStyle: TextStyle(color: sColor, fontFamily: "Sub"),
                  contentPadding: EdgeInsets.fromLTRB(20.w, 17.h, 10.w, 17.h),
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
                margin: EdgeInsets.fromLTRB(0, 0, 0, 8.h),
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
                            fontFamily: "Sub",
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
                style: TextStyle(fontFamily: "Sub"),
                controller: TextEditingController()
                  ..text = introduce == null || introduce!.length == 0
                      ? ""
                      : introduce!,
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
                  hintStyle: TextStyle(color: sColor, fontFamily: "Sub"),
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
            Padding(
              padding: const EdgeInsets.symmetric(vertical: defaultPadding / 2),
              child: Container(
                height: 40.h,
                width: double.maxFinite,
                child: Hero(
                  tag: "modify_btn",
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
                      "회원정보 수정".toUpperCase(),
                      style: TextStyle(
                        fontFamily: "Sub",
                      ),
                    ),
                  ),
                ),
              ),
            ),
            Padding(
              padding: EdgeInsets.fromLTRB(0, 10.h, 0, 15.h),
              child: Container(
                height: 40.h,
                width: double.maxFinite,
                child: ElevatedButton(
                  onPressed: () {
                    showDialog(
                        context: context,
                        builder: (BuildContext context) {
                          return Dialog(
                            shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(
                                    20.0)), //this right here
                            child: Container(
                              height: 150,
                              child: Padding(
                                padding: const EdgeInsets.fromLTRB(
                                    12.0, 12.0, 12.0, 3.0),
                                child: Column(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  crossAxisAlignment: CrossAxisAlignment.center,
                                  children: [
                                    Title(
                                      color: Colors.black,
                                      child: Text("정말 탈퇴하시겠습니까?",
                                          style: TextStyle(fontSize: 13)),
                                    ),
                                    Title(
                                      color: Colors.black,
                                      child: Text("탈퇴 시 해당 아이디로 로그인할 수 없습니다.",
                                          style: TextStyle(fontSize: 13)),
                                    ),
                                    Container(
                                        width: 150.0,
                                        margin:
                                            EdgeInsets.fromLTRB(0, 15, 0, 0),
                                        child: Row(
                                            mainAxisAlignment:
                                                MainAxisAlignment.spaceAround,
                                            children: [
                                              ElevatedButton(
                                                onPressed: () {
                                                  quit();
                                                },
                                                style: ElevatedButton.styleFrom(
                                                    backgroundColor:
                                                        Colors.red),
                                                child: Text(
                                                  "확인",
                                                  style: TextStyle(
                                                      color: Colors.white),
                                                ),
                                              ),
                                              ElevatedButton(
                                                onPressed: () {
                                                  Navigator.of(context).pop();
                                                },
                                                style: ElevatedButton.styleFrom(
                                                    backgroundColor:
                                                        Colors.white),
                                                child: Text(
                                                  "취소",
                                                  style: TextStyle(
                                                      color: Colors.black),
                                                ),
                                              ),
                                            ]))
                                  ],
                                ),
                              ),
                            ),
                          );
                        });
                  },
                  style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.red,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(25.0),
                      )),
                  child: Text(
                    "회원탈퇴".toUpperCase(),
                    style: TextStyle(
                      fontFamily: "Sub",
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      );
    }
  }
}
