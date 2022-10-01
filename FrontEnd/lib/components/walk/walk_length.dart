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
      return (length / 1000).toString() + " \n거리(km)";
    } else {
      return length.toString() + " \n거리(m)";
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      child: Column(
        children: <Widget>[
          Padding(
            padding: const EdgeInsets.all(10),
            child: Container(
              width: 75.w,
              height: 50.h,
              child: Text(
                convertMeters(widget.totalWalkLength),
                style: TextStyle(
                  fontSize: 20.sp,
                  color: btnColor,
                  fontFamily: 'Helvetica',
                  fontWeight: FontWeight.bold,
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
