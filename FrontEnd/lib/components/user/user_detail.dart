import 'package:GSSL/api/api_user.dart';
import 'package:GSSL/components/bottomNavBar.dart';
import 'package:GSSL/constants.dart';
import 'package:GSSL/model/response_models/general_response.dart';
import 'package:GSSL/model/response_models/user_info.dart';
import 'package:GSSL/pages/login_page.dart';
import 'package:GSSL/pages/modify_user_page.dart';
import 'package:flutter/material.dart';

import '../util/custom_dialog.dart';

class UserDetail extends StatefulWidget {
  const UserDetail({
    Key? key,
  }) : super(key: key);

  @override
  State<UserDetail> createState() => _UserDetailState();
}

class _UserDetailState extends State<UserDetail> {
  final UserDetailFormKey = GlobalKey<FormState>();
  String S3Address = "https://a204drdoc.s3.ap-northeast-2.amazonaws.com/";
  User? user;
  ApiUser apiUser = ApiUser();

  Future<void> getUser() async {
    userInfo? userInfoResponse = await apiUser.getUserInfo();
    if (userInfoResponse.statusCode == 200) {
      setState(() {
        user = userInfoResponse.user;
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

  Future<void> logout() async {
    generalResponse? logoutResponse = await apiUser.logoutAPI();
    if (logoutResponse.statusCode == 200) {
      showDialog(
          context: context,
          builder: (BuildContext context) {
            return CustomDialog("로그아웃을 완료했습니다.", (context) => LoginScreen());
          });
    } else if (logoutResponse.statusCode == 401) {
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
                logoutResponse.message == null
                    ? "알 수 없는 오류가 발생했습니다."
                    : logoutResponse.message!,
                null);
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

  @override
  Widget build(BuildContext context) {
    return Container(
        margin: EdgeInsets.fromLTRB(
            0, MediaQuery.of(context).size.height / 20, 0, 0),
        child: Column(
          children: [
            Container(
              margin: EdgeInsets.fromLTRB(
                  MediaQuery.of(context).size.width / 9, 0, 0, 0),
              child: Row(
                children: [
                  Container(
                    width: MediaQuery.of(context).size.width / 5,
                    height: MediaQuery.of(context).size.width / 5,
                    child: Center(
                      child: user?.profilePic == null ||
                              user?.profilePic!.length == 0
                          ? CircleAvatar(
                              backgroundColor: Colors.black, radius: 200.0)
                          : CircleAvatar(
                              backgroundImage:
                                  NetworkImage(S3Address + user!.profilePic!),
                              radius: 200.0),
                    ),
                    decoration: BoxDecoration(
                        color: Colors.black, shape: BoxShape.circle),
                  ),
                  Container(
                      height: MediaQuery.of(context).size.width / 5,
                      margin: EdgeInsets.fromLTRB(
                          MediaQuery.of(context).size.width / 20, 0, 0, 0),
                      child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                          children: [
                            Text(
                                user?.nickname == null
                                    ? "불러오는 중입니다..."
                                    : user!.nickname!,
                                style: TextStyle(fontSize: 20)),
                            Text(
                                user?.email == null
                                    ? "잠시만 기다려주세요..."
                                    : user!.email!,
                                style: TextStyle(fontSize: 15))
                          ]))
                ],
              ),
            ),
            Row(mainAxisAlignment: MainAxisAlignment.center, children: [
              Container(
                height: MediaQuery.of(context).size.height / 5,
                width: MediaQuery.of(context).size.width / 1.3,
                alignment: Alignment.center,
                child: TextFormField(
                  controller: TextEditingController()
                    ..text =
                        user?.introduce == null || user?.introduce!.length == 0
                            ? "작성한 자기소개가 없습니다."
                            : user!.introduce!,
                  keyboardType: TextInputType.multiline,
                  maxLines: 4,
                  textInputAction: TextInputAction.done,
                  cursorColor: btnColor,
                  readOnly: true,
                  decoration: InputDecoration(
                    hintStyle: TextStyle(color: sColor),
                    contentPadding: EdgeInsets.fromLTRB(20, 25, 25, 15),
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
              )
            ]),
            Padding(
              padding: const EdgeInsets.symmetric(vertical: defaultPadding),
              child: Container(
                height: 48,
                width: MediaQuery.of(context).size.width / 1.3,
                child: ElevatedButton(
                  onPressed: () {
                    logout();
                  },
                  style: ElevatedButton.styleFrom(
                      backgroundColor: btnColor,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(25.0),
                      )),
                  child: Text(
                    "로그아웃",
                  ),
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(vertical: defaultPadding),
              child: Container(
                height: 48,
                width: MediaQuery.of(context).size.width / 1.3,
                child: ElevatedButton(
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) {
                          return ModifyUserScreen();
                        },
                      ),
                    );
                  },
                  style: ElevatedButton.styleFrom(
                      backgroundColor: btnColor,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(25.0),
                      )),
                  child: Text(
                    "회원정보 수정",
                  ),
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(vertical: defaultPadding),
              child: Container(
                height: 48,
                width: MediaQuery.of(context).size.width / 1.3,
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
                                                child: Text(
                                                  "취소",
                                                  style: TextStyle(
                                                      color: Colors.white),
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
                    "회원탈퇴",
                  ),
                ),
              ),
            ),
          ],
        ));
  }
}
