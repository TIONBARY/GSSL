import 'dart:io';

import 'package:GSSL/api/api_bogam.dart';
import 'package:GSSL/api/api_diary.dart';
import 'package:GSSL/api/api_pet.dart';
import 'package:GSSL/api/api_user.dart';
import 'package:GSSL/components/bottomNavBar.dart';
import 'package:GSSL/components/util/custom_dialog.dart';
import 'package:GSSL/constants.dart';
import 'package:GSSL/model/request_models/put_pet_journal.dart';
import 'package:GSSL/model/response_models/general_response.dart';
import 'package:GSSL/model/response_models/get_pet_detail.dart';
import 'package:GSSL/model/response_models/user_info.dart';
import 'package:GSSL/pages/login_page.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:image_picker/image_picker.dart';
import 'package:url_launcher/url_launcher.dart';

final label = [
  '결막염',
  '궤양성각막질환',
  '백내장',
  '비궤양성각막질환',
  '색소침착성각막염',
  '안검내반증',
  '안검염',
  '안검종양',
  '유루증',
  '핵경화'
];
List<String> diagnosisResult = ['', '', ''];
List<int> diagnosisPercent = [0, 0, 0];
ApiBogam apiBogam = ApiBogam();
XFile? _image;
final picker = ImagePicker();
int count = 0;
bool _loading = true;

BuildContext? loadingContext;

class BogamPage extends StatefulWidget {
  const BogamPage({Key? key}) : super(key: key);

  @override
  State<BogamPage> createState() => _BogamPageState();
}

class _BogamPageState extends State<BogamPage> {
  // 비동기 처리를 통해 카메라와 갤러리에서 이미지를 가져온다.
  Future getImage(ImageSource imageSource) async {
    final image = await picker.pickImage(source: imageSource, imageQuality: 50);

    setState(() {
      _image = XFile(image!.path); // 가져온 이미지를 _image에 저장
    });
  }

  ApiDiary apiDiary = ApiDiary();
  ApiUser apiUser = ApiUser();
  ApiPet apiPet = ApiPet();

  User? user;
  Pet? mainPet;

  Future<void> getUser() async {
    userInfo? userInfoResponse = await apiUser.getUserInfo();
    if (userInfoResponse.statusCode == 200) {
      setState(() {
        user = userInfoResponse.user;
      });
      getMainPet();
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

  Future<void> getMainPet() async {
    getPetDetail? getMainPetResponse =
        await apiPet.getPetDetailApi(user?.petId);
    if (getMainPetResponse.statusCode == 200) {
      setState(() {
        mainPet = getMainPetResponse.pet;
      });
    }
  }

  Future<void> _writeJournal() async {
    // set this variable to true when we try to submit
    if (user?.petId == null) {
      showDialog(
          context: context,
          builder: (BuildContext context) {
            return CustomDialog(
                "메인 반려동물을 설정해주세요.", (context) => BottomNavBar());
          });
    }
    generalResponse result = await apiDiary.register(
        _image,
        putPetJournal(
            petId: user!.petId!, part: "눈", result: diagnosisResult[0]));
    if (result.statusCode == 201) {
      showDialog(
          context: context,
          builder: (BuildContext context) {
            return CustomDialog("일지 등록에 성공했습니다.", (context) => BottomNavBar());
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
  }

  @override
  void initState() {
    super.initState();
    getUser();
  }

  // 이미지를 보여주는 위젯
  Widget showImage() {
    return Padding(
      padding: EdgeInsets.fromLTRB(0, 10.h, 0, 25.h),
      child: Container(
          color: const Color(0x1A506274),
          width: MediaQuery.of(context).size.width,
          height: MediaQuery.of(context).size.width,
          child: Center(
              child: _image == null
                  ? Text(
                      '이미지를 촬영 또는 선택 해주세요',
                      style: TextStyle(
                          fontFamily: "Daehan",
                          fontSize: 20.sp,
                          color: btnColor),
                    )
                  : Image.file(File(_image!.path)))),
    );
  }

  @override
  Widget build(BuildContext context) {
    // 화면 세로 고정
    SystemChrome.setPreferredOrientations(
        [DeviceOrientation.portraitUp, DeviceOrientation.portraitDown]);

    return Scaffold(
        backgroundColor: nWColor,
        appBar: AppBar(
            title: Text('견의보감'),
            centerTitle: true,
            titleTextStyle: TextStyle(
              color: nWColor,
              fontFamily: "Daehan",
              fontSize: 25.sp,
            ),
            iconTheme: IconThemeData(
              color: nWColor,
            ),
            backgroundColor: Color(0x80506274)),
        body: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Center(
              child: IconButton(
                onPressed: () => guideDialog(),
                icon: Icon(Icons.help_outline, size: 30.sp),
                color: btnColor,
              ),
            ),
            showImage(),
            Container(
              margin: EdgeInsets.fromLTRB(0, 25.h, 0, 25.h),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: <Widget>[
                  // 카메라 촬영 버튼
                  IconButton(
                    padding: EdgeInsets.zero,
                    icon: Icon(Icons.camera_alt, color: btnColor, size: 40.sp),
                    onPressed: () {
                      getImage(ImageSource.camera);
                    },
                  ),
                  ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        backgroundColor: btnColor,
                        shape: new RoundedRectangleBorder(
                          borderRadius: new BorderRadius.circular(25.0),
                        ), // foreground
                      ),
                      child: Text(
                        '분석',
                        style: TextStyle(
                            fontFamily: "Daehan",
                            fontSize: 20.sp,
                            color: nWColor),
                      ),
                      onPressed: () {
                        if (_image == null) {
                          print('사진을 선택해주세요');
                        } else {
                          _diagnosis();
                          loadingDialog();
                          Future.delayed(
                              const Duration(milliseconds: 40000), () {});
                        }
                      }),
                  // 갤러리에서 이미지를 가져오는 버튼
                  IconButton(
                    padding: EdgeInsets.zero,
                    icon: Icon(Icons.wallpaper, color: btnColor, size: 40.sp),
                    onPressed: () {
                      getImage(ImageSource.gallery);
                    },
                  ),
                ],
              ),
            ),
          ],
        ));
  }

  void guideDialog() {
    showDialog(
        context: context,
        builder: (BuildContext context) {
          Future.delayed(Duration(seconds: 3), () {
            Navigator.pop(context);
          });
          return AlertDialog(
            backgroundColor: nWColor,
            shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(15.0)),
            //Dialog Main Title
            title: Column(
              children: <Widget>[
                Text(
                  "촬영 가이드",
                  textAlign: TextAlign.center,
                  style: TextStyle(fontFamily: "Daehan", color: btnColor),
                ),
              ],
            ),
            //
            content: Column(
              mainAxisSize: MainAxisSize.min,
              children: <Widget>[
                Text(
                  "해당 사진처럼 가까이 찍어주세요.",
                  style: TextStyle(fontFamily: "Daehan", color: btnColor),
                ),
                Padding(
                  padding: EdgeInsets.fromLTRB(5.w, 10.h, 5.w, 0),
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(10.0),
                    child: Image.asset("assets/images/1.png"),
                  ),
                )
              ],
            ),
            // actions: <Widget>[
            //   Center(
            //     child: ElevatedButton(
            //       child: Text("확인",
            //           style: TextStyle(fontFamily: "Daehan", color: nWColor)),
            //       style: ElevatedButton.styleFrom(
            //           backgroundColor: btnColor,
            //           shape: RoundedRectangleBorder(
            //             borderRadius: BorderRadius.circular(5.0),
            //           )),
            //       onPressed: () {
            //         Navigator.pop(context);
            //       },
            //     ),
            //   ),
            // ],
          );
        });
  }

  void loadingDialog() {
    showDialog(
        context: context,
        //barrierDismissible - Dialog를 제외한 다른 화면 터치 x
        barrierDismissible: false,
        builder: (BuildContext context) {
          loadingContext = context;
          return AlertDialog(
            shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(15.0)),
            //Dialog Main Title
            content: SizedBox(
                height: 333.h,
                child: Column(
                  children: [
                    Padding(
                      padding: EdgeInsets.fromLTRB(0, 0, 0, 20.h),
                      child: Image.asset("assets/images/loadingDog.gif"),
                    ),
                    Column(
                      children: [
                        Text(
                          '잠시만 기다려주세요.',
                          style:
                              TextStyle(fontFamily: "Daehan", color: btnColor),
                        ),
                        Text(
                          '1분 가량 소요됩니다.',
                          style:
                              TextStyle(fontFamily: "Daehan", color: btnColor),
                        ),
                      ],
                    ),
                  ],
                )),
          );
        });
  }

  void _diagnosis() async {
    int index = 0;
    count = 0;
    Map<String, dynamic> result = await apiBogam.diagnosis(_image);
    for (String key in result.keys) {
      diagnosisResult[index++] = key;
      if (index == 3) break;
    }
    index = 0;
    for (int value in result.values) {
      if (value > 50 && count < 3) count++;
      diagnosisPercent[index++] = value;
      if (index == 3) break;
    }
    Navigator.pop(loadingContext!);
    showModalBottomSheet<void>(
      context: context,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(25.0),
      ),
      builder: (BuildContext context) {
        return Container(
          height: 300.h,
          decoration: new BoxDecoration(
            color: pColor,
            borderRadius: new BorderRadius.only(
              topLeft: const Radius.circular(25.0),
              topRight: const Radius.circular(25.0),
            ),
          ),
          padding: EdgeInsets.fromLTRB(30.w, 0, 30.w, 0),
          child: count == 0
              ? Center(
                  child: Text(
                    '${mainPet?.name}는 건강합니다.',
                    style: TextStyle(
                        fontFamily: "Daehan",
                        fontSize: 20.sp,
                        color: Colors.black),
                  ),
                )
              : Column(
                  children: <Widget>[
                    Padding(
                      padding: EdgeInsets.all(15.h),
                      child: Text('해당 질병이 의심됩니다.',
                          style:
                              TextStyle(fontFamily: "Daehan", color: btnColor)),
                    ),
                    for (int i = 0; i < count; i++)
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Container(
                            width: MediaQuery.of(context).size.width / 3,
                            child: Text(diagnosisResult.elementAt(i),
                                style: TextStyle(
                                    fontFamily: "Daehan", color: btnColor)),
                          ),
                          Container(
                            width: MediaQuery.of(context).size.width / 3,
                            child: Text('${diagnosisPercent.elementAt(i)}%',
                                style: TextStyle(
                                    fontFamily: "Daehan", color: btnColor)),
                          ),
                          Container(
                            child: IconButton(
                              onPressed: () async {
                                Uri _url = Uri.parse(
                                    'https://search.naver.com/search.naver?where=nexearch&sm=top_hty&fbm=0&ie=utf8&query=강아지' +
                                        diagnosisResult.elementAt(i));
                                if (!await launchUrl(_url)) {
                                  throw 'Could not launch $_url';
                                }
                              },
                              icon: Icon(Icons.help_outline),
                              color: btnColor,
                            ),
                          )
                        ],
                      ),
                    IconButton(
                      padding: EdgeInsets.all(10.h),
                      icon: Icon(Icons.save_alt_outlined, color: btnColor),
                      onPressed: () {
                        _writeJournal();
                      },
                    ),
                  ],
                ),
        );
      },
    );
  }
}
