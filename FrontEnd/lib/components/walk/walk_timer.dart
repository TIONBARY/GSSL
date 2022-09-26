import 'dart:async';

import 'package:flutter/material.dart';


class WalkTimer extends StatefulWidget {
  final started;

  const WalkTimer(this.started);

  @override
  State<WalkTimer> createState() => _WalkTimerState();
}

class _WalkTimerState extends State<WalkTimer> {
  Timer? timer;
  DateTime startTime = DateTime.now();

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

    if (widget.started) {
      startTime = DateTime.now();
    }

    return Container(
      child: Container(
    width: 80,
    height: 60,
          child: Text(_walkFormatDateTime(startTime, widget.started),
          ),
    ),
    );
  }
}

String _walkFormatDateTime(DateTime startTime, started) {
  // return DateFormat('MM/dd/yyyy hh:mm:ss').format(dateTime);

  var result = DateTime.now().difference(startTime).toString().substring(0,10);

  if (started) {
    result = "00:00:00";
  }
  return result;
}
// String _walkFormatDateTime(int elapsedMilliseconds) {
//   // return DateFormat('MM/dd/yyyy hh:mm:ss').format(dateTime);
//   int seconds = int.parse((elapsedMilliseconds/1000).round().toString());
//
//   DateTime newTime =DateTime(seconds = seconds);
//   return DateFormat('hh:mm:ss').format(newTime);
// }

