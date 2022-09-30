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
    return Container(
        color: const Color(0xffd0cece),
        width: MediaQuery.of(context).size.width,
        height: MediaQuery.of(context).size.width,
        child: Center(
            child: _image == null
                ? Text('이미지를 촬영/선택 해주세요')
                : Image.file(File(_image!.path))));
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
                    getImage(ImageSource.camera);
                  },
                  backgroundColor: btnColor,
                ),

                // 갤러리에서 이미지를 가져오는 버튼
                FloatingActionButton(
                  child: Icon(Icons.wallpaper),
                  tooltip: 'pick Iamge',
                  onPressed: () {
                    getImage(ImageSource.gallery);
                  },
                  backgroundColor: btnColor,
                ),
              ],
            ),
            Padding(padding: EdgeInsets.all(7.h)),
            FloatingActionButton(
                child: Icon(Icons.search),
                tooltip: 'diagnose',
                backgroundColor: btnColor,
                onPressed: () {
                  if (_image == null) {
                    print('사진을 선택해주세요');
                  } else {
                    _diagnosis();
                    loadingDialog();
                    Future.delayed(const Duration(milliseconds: 40000), () {
                      showModalBottomSheet<void>(
                        context: context,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(25.0),
                        ),
                        builder: (BuildContext context) {
                          return Container(
                            height: 250.h,
                            decoration: new BoxDecoration(
                              color: pColor,
                              borderRadius: new BorderRadius.only(
                                topLeft: const Radius.circular(25.0),
                                topRight: const Radius.circular(25.0),
                              ),
                            ),
                            padding: EdgeInsets.fromLTRB(30.w, 0, 30.w, 0),
                            child: Column(
                              children: <Widget>[
                                Padding(padding: EdgeInsets.all(10)),
                                Text('해당 질병이 의심됩니다'),
                                Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    Text(diagnosisResult.elementAt(0)),
                                    Text('${diagnosisPercent.elementAt(0)}%'),
                                    IconButton(
                                        onPressed: () async {
                                          Uri _url = Uri.parse(
                                              'https://search.naver.com/search.naver?where=nexearch&sm=top_hty&fbm=0&ie=utf8&query=' +
                                                  diagnosisResult.elementAt(0));
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
                                    Text('${diagnosisPercent.elementAt(1)}%'),
                                    IconButton(
                                        onPressed: () async {
                                          Uri _url = Uri.parse(
                                              'https://search.naver.com/search.naver?where=nexearch&sm=top_hty&fbm=0&ie=utf8&query=' +
                                                  diagnosisResult.elementAt(1));
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
                                    Text('${diagnosisPercent.elementAt(2)}%'),
                                    IconButton(
                                        onPressed: () async {
                                          Uri _url = Uri.parse(
                                              'https://search.naver.com/search.naver?where=nexearch&sm=top_hty&fbm=0&ie=utf8&query=' +
                                                  diagnosisResult.elementAt(2));
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
                  "사진은 이렇게 찍어주세요.",
                ),
                Image.asset("assets/images/1.png")
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
          Future.delayed(Duration(milliseconds: 40000), () {
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
                    Padding(padding: EdgeInsets.all(7.h)),
                    Text('조금만 기다려주세요.'),
                    Text('40초 가량 소요됩니다.')
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
