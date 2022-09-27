import 'dart:async';

import 'package:flutter/material.dart';
import "package:stop_watch_timer/stop_watch_timer.dart";

class WalkTimer extends StatefulWidget {
  final _stopWatchTimer;

  const WalkTimer(this._stopWatchTimer);
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
  void initState() {
    super.initState();
  }

  @override
  void dispose() async {
    super.dispose();
    await widget._stopWatchTimer.dispose(); // Need to call dispose function.
  }

  @override
  Widget build(BuildContext context) {
    initTimer();

    return StreamBuilder<int>(
      stream: widget._stopWatchTimer.rawTime,
      initialData: 0,
      builder: (context, snap) {
        final value = snap.data!;
        final displayTime = StopWatchTimer.getDisplayTime(value);
        return Column(
          children: <Widget>[
            Padding(
              padding: const EdgeInsets.all(8),
              child: Text(
                displayTime,
                style: TextStyle(
                    fontSize: 40,
                    fontFamily: 'Helvetica',
                    fontWeight: FontWeight.bold),
              ),
            ),
          ],
        );
      },
    );
  }
}
