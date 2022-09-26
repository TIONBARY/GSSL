import 'dart:async';

import 'package:flutter/material.dart';


class WalkTimer extends StatefulWidget {
  final started;
  final startTime;

  const WalkTimer(this.started, this.startTime);
  @override
  State<WalkTimer> createState() => _WalkTimerState();
}

class _WalkTimerState extends State<WalkTimer> {
  Timer? timer;
  DateTime realStartTime = DateTime.now();
  DateTime realEndTime = DateTime.now();

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

    if (!widget.started) {
      realEndTime = DateTime.now();
      // debugPrint("종료 시간");
      // debugPrint(widget.startTime.toString());
      // debugPrint(realEndTime.toString());
    } else {
      // debugPrint("종료중");
      // debugPrint(realStartTime.toString());
    }

    return Container(
      child: Container(
    width: 80,
    height: 60,
          child: Text(_walkFormatDateTime(widget.startTime, realEndTime,  widget.started),
          ),
    ),
    );
  }
}

String _walkFormatDateTime(DateTime startTime, realEndTime, bool started) {
  // return DateFormat('MM/dd/yyyy hh:mm:ss').format(dateTime);

  var runningTimer = DateTime.now().difference(startTime).toString().substring(0,10);
  if (started) {
    runningTimer = realEndTime.difference(startTime).toString().substring(0,10);
  }
  return runningTimer;
}

