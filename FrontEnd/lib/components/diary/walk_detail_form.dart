import 'dart:io';

import 'package:GSSL/components/diary/walk_pet_selection_form.dart';
import 'package:GSSL/components/util/custom_dialog_function.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class WalkDetailsPage extends StatefulWidget {
  final String imagePath;
  final String title;
  final String petNames;
  final String distance;
  final int walkId;

  WalkDetailsPage(
      {required this.imagePath,
      required this.title,
      required this.petNames,
      required this.distance,
      required this.walkId});

  @override
  State<WalkDetailsPage> createState() => _WalkDetailsPageState();
}

class _WalkDetailsPageState extends State<WalkDetailsPage> {
  @override
  Widget build(BuildContext context) {
    int walkId = widget.walkId;
    String imagePath = widget.imagePath;
    String title = widget.title;
    String petNames = widget.petNames;
    String distance = widget.distance;

    return Scaffold(
      body: Container(
        child: Column(
          children: <Widget>[
            Expanded(
              child: Stack(children: [
                Hero(
                  tag: 'WalkDetail$walkId',
                  child: Container(
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.only(
                          bottomLeft: Radius.circular(30),
                          bottomRight: Radius.circular(30)),
                      image: File(imagePath).existsSync()
                          ? DecorationImage(
                              image: FileImage(File(imagePath)),
                              fit: BoxFit.cover)
                          : DecorationImage(
                              image: AssetImage("assets/images/basic_dog.png"),
                              fit: BoxFit.contain,
                            ),
                    ),
                  ),
                ),
                Positioned(
                  top: 0.65.sh,
                  left: 0.85.sw,
                  child: FloatingActionButton(
                      child: Icon(Icons.delete),
                      elevation: 5,
                      hoverElevation: 10,
                      tooltip: "삭제",
                      backgroundColor: Colors.red,
                      mini: true,
                      onPressed: () {
                        showDialog(
                            context: context,
                            builder: (BuildContext context) {
                              return CustomDialogWithFunction("정말로 삭제하시겠습니까?",
                                  () {
                                // 스크린샷 삭제
                                if (File(imagePath).existsSync()) {
                                  File(imagePath).deleteSync();
                                }
                                // 삭제 요청 전송
                                apiWalk.deleteWalk(walkId);
                                // 뒤로가기
                                Navigator.pop(context);
                              });
                            }).then((value) {
                          // 뒤로가기
                          Navigator.pop(context);
                          setState(() {});
                        });
                      }),
                ),
                Positioned(
                  top: 0.65.sh,
                  left: 0.70.sw,
                  child: FloatingActionButton(
                      child: Icon(Icons.edit),
                      elevation: 5,
                      hoverElevation: 10,
                      tooltip: "수정",
                      backgroundColor: Colors.grey,
                      mini: true,
                      onPressed: () {
                        // debugPrint("삭제");{
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) =>
                                WalkPetSelectionPage(walkId: walkId),
                          ),
                        );
                        // Navigator.pop(context);
                      }),
                )
              ]),
            ),
            Container(
              height: 0.21.sh,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: <Widget>[
                  Padding(
                    padding:
                        EdgeInsets.fromLTRB(0.05.sw, 0.025.sh, 0.05.sw, 0.0.sh),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: <Widget>[
                        Text(
                          '$title',
                          style: TextStyle(
                            color: Colors.lightBlueAccent,
                            fontSize: 11.sp,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                        Text(
                          '$petNames',
                          style: TextStyle(
                            fontSize: 24.sp,
                          ),
                        ),
                        Text(
                          '이동거리: $distance',
                          style: TextStyle(
                            color: Colors.redAccent,
                            fontSize: 16.sp,
                            fontWeight: FontWeight.w400,
                          ),
                        ),
                        // SizedBox(
                        //   height: 10,
                        // ),
                        // Text(
                        //   '$index',
                        //   style: TextStyle(
                        //     fontSize: 14,
                        //   ),
                        // ),
                      ],
                    ),
                  ),
                  Row(
                    children: <Widget>[
                      Expanded(
                        flex: 1,
                        child: TextButton(
                          onPressed: () {
                            Navigator.pop(context);
                          },
                          style: TextButton.styleFrom(
                            foregroundColor: Colors.lightBlueAccent,
                            backgroundColor: Colors.lightBlueAccent,
                          ),
                          child: Text(
                            '뒤로가기',
                            style: TextStyle(
                              color: Colors.white,
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
