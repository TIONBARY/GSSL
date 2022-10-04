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
                  top: 440.h,
                  left: 300.w,
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
                  top: 440.h,
                  left: 240.w,
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
              height: 150.h,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: <Widget>[
                  Padding(
                    padding: EdgeInsets.fromLTRB(15.w, 10.h, 15.w, 10.h),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: <Widget>[
                        Text(
                          '$title',
                          style: TextStyle(
                            color: Colors.lightBlueAccent,
                            fontSize: 20,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                        Text(
                          '$petNames',
                          style: TextStyle(
                            fontSize: 10,
                          ),
                        ),
                        Text(
                          '이동거리: $distance',
                          style: TextStyle(
                            color: Colors.redAccent,
                            fontSize: 8,
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
                        child: TextButton(
                          onPressed: () {
                            Navigator.pop(context);
                          },
                          style: TextButton.styleFrom(
                            padding: EdgeInsets.symmetric(vertical: 0.h),
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
                  )
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
