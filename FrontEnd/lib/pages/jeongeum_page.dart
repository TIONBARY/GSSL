import 'dart:io';

import 'package:GSSL/api/api_jeongeum.dart';
import 'package:GSSL/constants.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:image_picker/image_picker.dart';

String diagnosisResult = "";
ApiJeongeum apiJeongeum = ApiJeongeum();
XFile? _video;
final picker = ImagePicker();

class JeongeumPage extends StatefulWidget {
  const JeongeumPage({Key? key}) : super(key: key);

  @override
  State<JeongeumPage> createState() => _JeongeumPageState();
}

class _JeongeumPageState extends State<JeongeumPage> {
  // 비동기 처리를 통해 카메라와 갤러리에서 이미지를 가져온다.
  Future getVideo(ImageSource imageSource) async {
    final video = await picker.pickVideo(
      source: imageSource,
    );

    setState(() {
      _video = XFile(video!.path); // 가져온 이미지를 _image에 저장
    });
  }

  // 이미지를 보여주는 위젯
  Widget showImage() {
    return Padding(
      padding: EdgeInsets.fromLTRB(0, 10.h, 0, 25.h),
      child: Container(
          color: const Color(0xffd0cece),
          width: MediaQuery.of(context).size.width,
          height: MediaQuery.of(context).size.width,
          child: Center(
              child: _video == null
                  ? Text(
                      '이미지를 촬영 또는 선택 해주세요',
                      style: TextStyle(
                          fontFamily: "Daehan", fontSize: 20.sp, color: btnColor),
                    )
                  : Image.file(File(_video!.path)))),
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
            title: Text('견민정음'),
            centerTitle: true,
            titleTextStyle: TextStyle(
              color: nWColor,
              fontFamily: "Daehan",
              fontSize: 25.sp,
            ),
            iconTheme: IconThemeData(
              color: nWColor,
            ),
            backgroundColor: Color(0x80C66952)),
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
                      getVideo(ImageSource.camera);
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
                        if (_video == null) {
                          print('사진을 선택해주세요');
                        } else {
                          _diagnosis();
                          loadingDialog();
                          Future.delayed(const Duration(milliseconds: 20000),
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
                                      Text(
                                          '강아지는 현재 ${diagnosisResult}한 상태입니다.'),
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
                      getVideo(ImageSource.gallery);
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
                  "강아지가 가운데 오도록 찍어주세요.",
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
          Future.delayed(Duration(milliseconds: 20000), () {
            Navigator.pop(context);
          });

          return AlertDialog(
            // RoundedRectangleBorder - Dialog 화면 모서리 둥글게 조절
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
                          '20초 가량 소요됩니다.',
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
    print('진단중');
    String result = await apiJeongeum.diagnosis(_video);
    print(result);
    diagnosisResult = result.substring(11,result.length-1);
  }
}
