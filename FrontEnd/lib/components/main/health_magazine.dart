import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class health_magazine extends StatelessWidget {
  const health_magazine({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 230.h,
      width: double.infinity,
      padding: EdgeInsets.all(5.h),
      color: Colors.red,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: [
          Column(
            children: [
              Container(
                width: 130.w,
                height: 80.h,
                padding: EdgeInsets.all(5.h),
                margin: EdgeInsets.all(10.h),
                color: Colors.blue,
              ),
              Container(
                width: 130.w,
                height: 80.h,
                padding: EdgeInsets.all(5.h),
                margin: EdgeInsets.all(10.h),
                color: Colors.black,
              ),
            ],
          ),
          Column(
            children: [
              Container(
                width: 130.w,
                height: 80.h,
                padding: EdgeInsets.all(5.h),
                margin: EdgeInsets.all(10.h),
                color: Colors.grey,
              ),
              Container(
                width: 130.w,
                height: 80.h,
                padding: EdgeInsets.all(5.h),
                margin: EdgeInsets.all(10.h),
                color: Colors.white,
              ),
            ],
          )
        ],
      ),
    );
  }
}
