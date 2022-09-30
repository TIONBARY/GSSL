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
    final image = await picker.pickVideo(
      source: imageSource,
    );

    setState(() {
      _video = XFile(image!.path); // 가져온 이미지를 _image에 저장
    });
  }

  // 이미지를 보여주는 위젯
  Widget showImage() {
    return Container(
        color: const Color(0xffd0cece),
        width: MediaQuery.of(context).size.width,
        height: MediaQuery.of(context).size.width,
        child: Center(
            child: _video == null
                ? Text('영상을 촬영/선택 해주세요')
                : Image.file(File(_video!.path))));
  }

  @override
  Widget build(BuildContext context) {
    // 화면 세로 고정
    SystemChrome.setPreferredOrientations(
        [DeviceOrientation.portraitUp, DeviceOrientation.portraitDown]);

    return Scaffold(
        backgroundColor: const Color(0xfff4f3f9),
        body: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            IconButton(
              onPressed: () => guideDialog(),
              icon: Icon(Icons.help_outline),
              color: btnColor,
            ),
            SizedBox(height: 25.0.h),
            showImage(),
            SizedBox(
              height: 50.0.h,
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: <Widget>[
                // 카메라 촬영 버튼
                FloatingActionButton(
                  child: Icon(Icons.add_a_photo),
                  tooltip: 'pick Iamge',
                  onPressed: () {
                    getVideo(ImageSource.camera);
                  },
                  backgroundColor: btnColor,
                ),

                // 갤러리에서 이미지를 가져오는 버튼
                FloatingActionButton(
                  child: Icon(Icons.wallpaper),
                  tooltip: 'pick Iamge',
                  onPressed: () {
                    getVideo(ImageSource.gallery);
                  },
                  backgroundColor: btnColor,
                ),
              ],
            ),
            Padding(padding: EdgeInsets.all(12.h)),
            FloatingActionButton(
                child: Icon(Icons.search),
                tooltip: 'diagnose',
                backgroundColor: btnColor,
                onPressed: () {
                  if (_video == null) {
                    print('사진을 선택해주세요');
                  } else {
                    _diagnosis();
                    loadingDialog();
                    Future.delayed(const Duration(milliseconds: 20000), () {
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
                                Text('강아지는 현재 ${diagnosisResult}한 상태입니다.'),
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
                })
          ],
        ));
  }

  void guideDialog() {
    showDialog(
        context: context,
        //barrierDismissible - Dialog를 제외한 다른 화면 터치 x
        barrierDismissible: false,
        builder: (BuildContext context) {
          return AlertDialog(
            // RoundedRectangleBorder - Dialog 화면 모서리 둥글게 조절
            shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(10.0)),
            //Dialog Main Title
            title: Column(
              children: <Widget>[
                Text("가이드"),
              ],
            ),
            //
            content: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                Text(
                  "강아지가 가운데 오게 찍어주세요.",
                ),
              ],
            ),
            actions: <Widget>[
              TextButton(
                child: Text("확인"),
                onPressed: () {
                  Navigator.pop(context);
                },
              ),
            ],
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
                borderRadius: BorderRadius.circular(10.0)),
            //Dialog Main Title
            content: SizedBox(
                height: 240.h,
                child: Column(
                  children: [
                    Image.asset('assets/images/loadingDog.gif'),
                    Padding(padding: EdgeInsets.all(15)),
                    Text('조금만 기다려주세요.'),
                    Text('20초 가량 소요됩니다.')
                  ],
                )),
          );
        });
  }

  void _diagnosis() async {
    print('진단중');
    String result = await apiJeongeum.diagnosis(_video);
    print(result);
    diagnosisResult = result;
  }
}
