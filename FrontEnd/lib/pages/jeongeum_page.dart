import 'dart:convert';
import 'dart:io';

import 'package:GSSL/api/api_jeongeum.dart';
import 'package:GSSL/components/util/custom_dialog.dart';
import 'package:GSSL/constants.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:image_picker/image_picker.dart';
import 'package:video_player/video_player.dart';

String diagnosisResult = "";
ApiJeongeum apiJeongeum = ApiJeongeum();
XFile? _video;
final picker = ImagePicker();
bool _loading = true;

BuildContext? loadingContext;

VideoPlayerController? _controller;
Future<void>? _initializeVideoPlayerFuture;

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

    _controller = VideoPlayerController.file(
      File(_video!.path),
    );
    _initializeVideoPlayerFuture = _controller!.initialize();
    _controller!.addListener(() {
      setState(() {});
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
              child: _controller == null
                  ? Text(
                      '동영상을 촬영 또는 선택 해주세요',
                      style: TextStyle(
                          fontFamily: "Daehan",
                          fontSize: 20.sp,
                          color: btnColor),
                    )
                  : Stack(
                      children: [
                        VideoPlayer(
                          _controller!,
                        ),
                        Center(
                            child: GestureDetector(
                          onTap: () async {
                            await createVideo();
                          },
                          child: Visibility(
                            visible: true,
                            child: CircleAvatar(
                              radius: 30,
                              backgroundColor: Colors.white60,
                              child: Icon(
                                  _controller!.value.isPlaying == true
                                      ? Icons.pause
                                      : Icons.play_arrow,
                                  size: 26,
                                  color: Colors.blue),
                            ),
                          ),
                        ))
                      ],
                    ),
            )));
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

  Future<void> createVideo() async {
    if (_controller == null) {
      return;
    } else {
      if (_controller!.value.isPlaying) {
        _controller!.pause();
        setState(() {});
      } else {
        _controller!.initialize();
        await _controller!.play();
        setState(() {});
      }
    }
  }

  void guideDialog() {
    showDialog(
        context: context,
        builder: (BuildContext context) {
          Future.delayed(Duration(seconds: 5), () {
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
                  "강아지가 가운데 오도록 찍어주세요.\n동영상 길이는 5초 이내로 해주세요.",
                  style: TextStyle(fontFamily: "Daehan", color: btnColor),
                ),
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
            // RoundedRectangleBorder - Dialog 화면 모서리 둥글게 조절
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
    String result = await apiJeongeum.diagnosis(_video);
    if (json.decode(result)['emotion'] != null) {
      diagnosisResult = json.decode(result)['emotion'];
      print(diagnosisResult);
      setState(() {
        _loading = false;
      });
      diagnosisResult = diagnosisResult.replaceAll("_", " 또는 ");
      if (!_loading) {
        Navigator.pop(loadingContext!);
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
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  Text('강아지는 현재'),
                  Padding(padding: EdgeInsets.all(10)),
                  Text('${diagnosisResult}', style: TextStyle(fontSize: 24)),
                  Padding(padding: EdgeInsets.all(10)),
                  Text('한 상태입니다.')
                  // FloatingActionButton(
                  //   child: Icon(Icons.save_alt_outlined),
                  //   tooltip: 'save',
                  //   onPressed: () {},
                  //   backgroundColor: btnColor,
                  // ),
                ],
              ),
            );
          },
        );
      }
    } else {
      Navigator.pop(loadingContext!);
      showDialog(
          context: context,
          builder: (BuildContext context) {
            return CustomDialog("분석에 실패했습니다.", null);
          });
    }
  }
}
