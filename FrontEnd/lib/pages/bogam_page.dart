import 'dart:io';

import 'package:GSSL/api/api_bogam.dart';
import 'package:GSSL/constants.dart';
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
List<String> diagnosisResult = ['1등', '2등', '3등'];
List<int> diagnosisPercent = [50, 50, 50];
ApiBogam apiBogam = ApiBogam();
XFile? _image;
final picker = ImagePicker();

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
                          Future.delayed(const Duration(milliseconds: 40000),
                              () {
                            showModalBottomSheet<void>(
                              context: context,
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(25.0),
                              ),
                              builder: (BuildContext context) {
                                return Container(
                                  height: 250,
                                  decoration: new BoxDecoration(
                                    color: pColor,
                                    borderRadius: new BorderRadius.only(
                                      topLeft: const Radius.circular(25.0),
                                      topRight: const Radius.circular(25.0),
                                    ),
                                  ),
                                  padding: EdgeInsets.fromLTRB(30, 0, 30, 0),
                                  child: Column(
                                    children: <Widget>[
                                      Padding(padding: EdgeInsets.all(10)),
                                      Text('해당 질병이 의심됩니다'),
                                      Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.spaceBetween,
                                        children: [
                                          Text(diagnosisResult.elementAt(0)),
                                          Text(
                                              '${diagnosisPercent.elementAt(0)}%'),
                                          IconButton(
                                              onPressed: () async {
                                                Uri _url = Uri.parse(
                                                    'https://search.naver.com/search.naver?where=nexearch&sm=top_hty&fbm=0&ie=utf8&query=' +
                                                        diagnosisResult
                                                            .elementAt(0));
                                                if (!await launchUrl(_url)) {
                                                  throw 'Could not launch $_url';
                                                }
                                              },
                                              icon: Icon(Icons.help_outline))
                                        ],
                                      ),
                                      Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.spaceBetween,
                                        children: [
                                          Text(diagnosisResult.elementAt(1)),
                                          Text(
                                              '${diagnosisPercent.elementAt(1)}%'),
                                          IconButton(
                                              onPressed: () async {
                                                Uri _url = Uri.parse(
                                                    'https://search.naver.com/search.naver?where=nexearch&sm=top_hty&fbm=0&ie=utf8&query=' +
                                                        diagnosisResult
                                                            .elementAt(1));
                                                if (!await launchUrl(_url)) {
                                                  throw 'Could not launch $_url';
                                                }
                                              },
                                              icon: Icon(Icons.help_outline))
                                        ],
                                      ),
                                      Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.spaceBetween,
                                        children: [
                                          Text(diagnosisResult.elementAt(2)),
                                          Text(
                                              '${diagnosisPercent.elementAt(2)}%'),
                                          IconButton(
                                              onPressed: () async {
                                                Uri _url = Uri.parse(
                                                    'https://search.naver.com/search.naver?where=nexearch&sm=top_hty&fbm=0&ie=utf8&query=' +
                                                        diagnosisResult
                                                            .elementAt(2));
                                                if (!await launchUrl(_url)) {
                                                  throw 'Could not launch $_url';
                                                }
                                              },
                                              icon: Icon(Icons.help_outline))
                                        ],
                                      ),
                                      FloatingActionButton(
                                        child: Icon(Icons.save_alt_outlined),
                                        tooltip: 'save',
                                        onPressed: () {},
                                        backgroundColor: btnColor,
                                      ),
                                    ],
                                  ),
                                );
                              },
                            );
                          });
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
          Future.delayed(Duration(milliseconds: 50000), () {
            Navigator.pop(context);
          });

          return AlertDialog(
            shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(15.0)),
            //Dialog Main Title
            content: SizedBox(
                height: 277.h,
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
                          '40초 가량 소요됩니다.',
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
    print('진단중');
    Map<String, dynamic> result = await apiBogam.diagnosis(_image);
    for (String key in result.keys) {
      diagnosisResult[index++] = key;
      if (index == 3) break;
    }
    index = 0;
    for (int value in result.values) {
      diagnosisPercent[index++] = value;
      if (index == 3) break;
    }
  }
}
