import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class WalkDetailsPage extends StatelessWidget {
  final String imagePath;
  final String title;
  final String petNames;
  final String distance;
  final int index;
  WalkDetailsPage(
      {required this.imagePath,
      required this.title,
      required this.petNames,
      required this.distance,
      required this.index});
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        child: Column(
          children: <Widget>[
            Expanded(
              child: Hero(
                tag: 'logo$index',
                child: Container(
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.only(
                        bottomLeft: Radius.circular(30),
                        bottomRight: Radius.circular(30)),
                    image: File(imagePath).existsSync()
                        ? DecorationImage(
                            image: FileImage(File(imagePath)),
                            fit: BoxFit.cover,
                          )
                        : DecorationImage(
                            image: AssetImage("assets/images/basic_dog.png"),
                            fit: BoxFit.contain,
                          ),
                  ),
                ),
              ),
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
                            padding: EdgeInsets.symmetric(vertical: 1.h),
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
                      SizedBox(
                        width: 0,
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
