import 'dart:async';

import 'package:flutter/material.dart';


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

  @override
  Widget build(BuildContext context) {
    initTimer();

    return Container(
      child: Container(
        width: 80,
        height: 60,
        child: Text(convertMeters(widget.totalWalkLength)),
        ),
    );
  }

  String convertMeters(length) {

    if (length > 1000) {
      return (length/1000).toString() + " Km";
    } else {
      return length.toString() + " m";
    }
  }
}