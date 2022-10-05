import 'package:GSSL/api/api_user.dart';
import 'package:GSSL/components/bottomNavBar.dart';
import 'package:GSSL/constants.dart';
import 'package:GSSL/model/response_models/general_response.dart';
import 'package:GSSL/model/response_models/user_info.dart';
import 'package:GSSL/pages/login_page.dart';
import 'package:GSSL/pages/modify_user_page.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../util/custom_dialog.dart';

class UserDetail extends StatefulWidget {
  const UserDetail({
    Key? key,
  }) : super(key: key);

  @override
  State<UserDetail> createState() => _UserDetailState();
}

final UserDetailFormKey = GlobalKey<FormState>();
String S3Address = "https://a204drdoc.s3.ap-northeast-2.amazonaws.com/";
User? user;
ApiUser apiUser = ApiUser();

class _UserDetailState extends State<UserDetail> {
  // final UserDetailFormKey = GlobalKey<FormState>();
  // String S3Address = "https://a204drdoc.s3.ap-northeast-2.amazonaws.com/";
  // User? user;
  // ApiUser apiUser = ApiUser();

  bool _loading = true;

  Future<void> getUser() async {
    userInfo? userInfoResponse = await apiUser.getUserInfo();
    if (userInfoResponse.statusCode == 200) {
      setState(() {
        user = userInfoResponse.user;
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

  @override
  void initState() {
    super.initState();
    getUser();
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
      return Container(
          margin: EdgeInsets.fromLTRB(0, 25.h, 0, 0),
          child: Column(
            children: [
              userPic(),
              userNickName(),
              userInfoTitle(title: "기본 정보"),
              userInfoBox(),
              Padding(
                padding: const EdgeInsets.symmetric(vertical: defaultPadding),
                child: TextFormField(
                  style: TextStyle(fontFamily: "Sub", color: btnColor),
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
                  height: 40.h,
                  width: double.maxFinite,
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
                      "회원정보 수정".toUpperCase(),
                      style: TextStyle(
                        fontWeight: FontWeight.w500,
                        fontFamily: "Sub",
                      ),
                    ),
                  ),
                ),
              ),
              Padding(
                padding:
                    const EdgeInsets.symmetric(vertical: defaultPadding / 2),
                child: Container(
                  height: 40.h,
                  width: double.maxFinite,
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
                      "로그아웃".toUpperCase(),
                      style: TextStyle(
                        fontWeight: FontWeight.w500,
                        fontFamily: "Sub",
                      ),
                    ),
                  ),
                ),
              ),
            ],
          ));
    }
  }
}

class userPic extends StatefulWidget {
  const userPic({Key? key}) : super(key: key);

  @override
  State<userPic> createState() => _userPicState();
}

class _userPicState extends State<userPic> {
  @override
  Widget build(BuildContext context) {
    return Container(
      width: 100.w,
      height: 100.h,
      child: Center(
        child: user?.profilePic == null || user?.profilePic!.length == 0
            ? CircleAvatar(backgroundColor: Colors.black, radius: 200.0)
            : CircleAvatar(
                backgroundImage: NetworkImage(S3Address + user!.profilePic!),
                radius: 200.0),
      ),
      decoration: BoxDecoration(color: Colors.black, shape: BoxShape.circle),
    );
  }
}

class userNickName extends StatefulWidget {
  const userNickName({Key? key}) : super(key: key);

  @override
  State<userNickName> createState() => _userNickNameState();
}

class _userNickNameState extends State<userNickName> {
  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.symmetric(vertical: defaultPadding / 2),
      child: Text(
        user?.nickname == null ? "불러오는 중입니다..." : user!.nickname!,
        style: TextStyle(color: btnColor, fontFamily: "Sub", fontSize: 25.sp),
      ),
    );
  }
}

class userInfoTitle extends StatelessWidget {
  const userInfoTitle({Key? key, required this.title}) : super(key: key);

  final String title;

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.start,
      children: [
        Padding(
          padding: EdgeInsets.fromLTRB(10.w, 10.h, 0, 10.h),
          child: Text(
            title,
            style: TextStyle(
              fontSize: 20.sp,
              fontWeight: FontWeight.bold,
              color: btnColor,
              fontFamily: "Sub",
            ),
          ),
        ),
      ],
    );
  }
}

class userInfoBox extends StatelessWidget {
  const userInfoBox({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.fromLTRB(20.w, 10.h, 20.w, 10.h),
      decoration: BoxDecoration(
          color: Color(0x80C3B091), borderRadius: BorderRadius.circular(15)),
      child: Column(
        children: [
          Padding(
            padding: EdgeInsets.fromLTRB(0, 5.h, 0, 5.h),
            child: Row(children: [
              Flexible(
                child: Container(
                  child: RichText(
                      text: TextSpan(
                    text: '아이디',
                    style: TextStyle(
                        color: btnColor, fontSize: 15.sp, fontFamily: "Title"),
                  )),
                ),
                flex: 3,
              ),
              const SizedBox(width: defaultPadding),
              Flexible(
                child: Text(
                    user?.memberId == null ? "잠시만 기다려주세요..." : user!.memberId!,
                    style: TextStyle(fontSize: 15.sp, fontFamily: "Sub")),
                flex: 8,
              ),
            ]),
          ),
          Padding(
            padding: EdgeInsets.fromLTRB(0, 5.h, 0, 5.h),
            child: Row(children: [
              Flexible(
                child: Container(
                  child: RichText(
                      text: TextSpan(
                    text: '성별',
                    style: TextStyle(
                        color: btnColor, fontSize: 15.sp, fontFamily: "Title"),
                  )),
                ),
                flex: 3,
              ),
              const SizedBox(width: defaultPadding),
              Flexible(
                child: Text(user!.gender! == 'M' ? "남자" : "여자",
                    style: TextStyle(fontSize: 15.sp, fontFamily: "Sub")),
                flex: 8,
              ),
            ]),
          ),
          Padding(
            padding: EdgeInsets.fromLTRB(0, 5.h, 0, 5.h),
            child: Row(children: [
              Flexible(
                child: Container(
                  child: RichText(
                      text: TextSpan(
                    text: '전화번호',
                    style: TextStyle(
                        color: btnColor, fontSize: 15.sp, fontFamily: "Title"),
                  )),
                ),
                flex: 3,
              ),
              const SizedBox(width: defaultPadding),
              Flexible(
                child: Text(
                    user?.phone == null ? "잠시만 기다려주세요..." : user!.phone!,
                    style: TextStyle(fontSize: 15.sp, fontFamily: "Sub")),
                flex: 8,
              ),
            ]),
          ),
          Padding(
            padding: EdgeInsets.fromLTRB(0, 5.h, 0, 5.h),
            child: Row(children: [
              Flexible(
                child: Container(
                  child: RichText(
                      text: TextSpan(
                    text: '이메일',
                    style: TextStyle(
                        color: btnColor, fontSize: 15.sp, fontFamily: "Title"),
                  )),
                ),
                flex: 3,
              ),
              const SizedBox(width: defaultPadding),
              Flexible(
                child: Text(
                    user?.email == null ? "잠시만 기다려주세요..." : user!.email!,
                    style: TextStyle(fontSize: 15.sp, fontFamily: "Sub")),
                flex: 8,
              ),
            ]),
          ),
          // Padding(
          //   padding: EdgeInsets.fromLTRB(0, 0, 0, 10.h),
          //   child: Row(
          //     children: [
          //       Flexible(
          //         child: iconBox(
          //           iconName: pet!.gender! == 'M'
          //               ? Icon(
          //                   Icons.male,
          //                   color: Colors.blue,
          //                 )
          //               : Icon(
          //                   Icons.female,
          //                   color: Colors.red,
          //                 ),
          //           detail: "성별",
          //         ),
          //         flex: 3,
          //       ),
          //       Flexible(
          //         child: petGender(),
          //         flex: 8,
          //       ),
          //     ],
          //   ),
          // ),
          // Padding(
          //   padding: EdgeInsets.fromLTRB(0, 0, 0, 10.h),
          //   child: Row(
          //     children: [
          //       Flexible(
          //         child: iconBox(
          //           iconName: Icon(Icons.cake),
          //           detail: "생일",
          //         ),
          //         flex: 3,
          //       ),
          //       Flexible(
          //         child: petBirth(),
          //         flex: 8,
          //       ),
          //     ],
          //   ),
          // ),
          // Padding(
          //   padding: EdgeInsets.fromLTRB(0, 0, 0, 10.h),
          //   child: Row(
          //     children: [
          //       Flexible(
          //         child: iconBox(
          //           iconName: Icon(Icons.monitor_weight),
          //           detail: "무게",
          //         ),
          //         flex: 3,
          //       ),
          //       Flexible(
          //         child: petWeight(),
          //         flex: 8,
          //       ),
          //     ],
          //   ),
          // ),
        ],
      ),
    );
  }
}
