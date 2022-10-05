import 'dart:async';

import 'package:GSSL/constants.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class WalkLength extends StatefulWidget {
  final totalWalkLength;

  const WalkLength(this.totalWalkLength);

  @override
  State<WalkLength> createState() => _WalkLengthState();
}

class _WalkLengthState extends State<WalkLength> {
  Timer? timer;

  void initTimer() {
    if (timer != null && timer!.isActive) return;

    timer = Timer.periodic(const Duration(seconds: 1), (timer) {
      //job
      setState(() {});
    });
  }

  @override
  void dispose() {
    timer?.cancel();
    super.dispose();
  }

  String convertMeters(length) {
    if (length > 1000) {
      return (length / 1000).toString() + " (km)";
    } else {
      return length.toString() + " (m)";
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      child: Column(
        children: <Widget>[
          Padding(
            padding: EdgeInsets.fromLTRB(0, 25.h, 0, 0),
            child: Container(
              width: 87.w,
              height: 50.h,
              child: Text(
                convertMeters(widget.totalWalkLength),
                style: TextStyle(
                  fontSize: 25.sp,
                  color: btnColor,
                  fontFamily: 'Title',
                ),
                textAlign: TextAlign.center,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
