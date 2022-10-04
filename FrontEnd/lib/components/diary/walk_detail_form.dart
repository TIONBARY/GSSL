import 'dart:io';

import 'package:GSSL/api/api_walk.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class WalkDetailsPage extends StatelessWidget {
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
  Widget build(BuildContext context) {
    ApiWalk apiWalk = ApiWalk();

    return Scaffold(
      body: Container(
        child: Column(
          children: <Widget>[
            Expanded(
              child: Stack(children: [
                Hero(
                  tag: '$walkId',
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
                        // debugPrint("삭제");
                        // 스크린샷 삭제
                        File(imagePath).deleteSync();

                        // 삭제 요청 전송
                        apiWalk.deleteWalk(walkId);
                        // 뒤로가기
                        Navigator.pop(context);
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
                        // debugPrint("삭제");
                        // Navigator.push(context);
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
