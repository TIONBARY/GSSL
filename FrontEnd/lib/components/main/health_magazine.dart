import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class health_magazine extends StatelessWidget {
  const health_magazine({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 480.h,
      width: double.infinity,
      padding: EdgeInsets.all(5.h),
      // color: Colors.red,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Column(
            children: [
              magazineBox(),
              magazineBox(),
            ],
          ),
          Column(
            children: [
              magazineBox(),
              magazineBox(),
            ],
          )
        ],
      ),
    );
  }
}

class magazineBox extends StatelessWidget {
  const magazineBox({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
        width: 170.w,
        height: 230.h,
        child: Column(
          children: [
            Image.asset('assets/images/tooth/001.png'),
            Container(
              child: Row(
                children: [
                  Padding(
                    padding: EdgeInsets.fromLTRB(0, 0, 5.w, 0),
                    child: Text(
                        style: TextStyle(
                          color: Color(0xff424242),
                          fontFamily: "sub",
                          fontSize: 15.sp,
                        ),
                        "건강"),
                  ),
                  Padding(
                    padding: EdgeInsets.fromLTRB(0, 8.h, 0, 0),
                    child: Text(
                        style: TextStyle(
                          fontFamily: "sub",
                          fontSize: 15.sp,
                        ),
                        "반짝 반짝 건치를 위한\n양치 꿀팁 대방출!"),
                  ),
                ],
              ),
            )
          ],
        ));
  }
}
