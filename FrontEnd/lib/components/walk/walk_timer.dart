import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import "package:stop_watch_timer/stop_watch_timer.dart";

class WalkTimer extends StatefulWidget {
  final _stopWatchTimer;

  const WalkTimer(this._stopWatchTimer);
  @override
  State<WalkTimer> createState() => _WalkTimerState();
}

class _WalkTimerState extends State<WalkTimer> {
  @override
  void initState() {
    super.initState();
  }

  @override
  void dispose() async {
    super.dispose();
    // await widget._stopWatchTimer.onStopTimer(); // Need to call dispose function.
  }

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<int>(
      stream: widget._stopWatchTimer.rawTime,
      initialData: 0,
      builder: (context, snap) {
        final value = snap.data!;
        final displayTime = StopWatchTimer.getDisplayTime(value);
        return Column(
          children: <Widget>[
            Padding(
              padding: EdgeInsets.fromLTRB(0, 25.h, 0, 0),
              child: Container(
                height: 50.h,
                width: MediaQuery.of(context).size.width / 3,
                child: Text(
                  displayTime.split('.')[0],
                  style: TextStyle(
                    fontSize: 25.sp,
                    fontFamily: 'Title',
                  ),
                ),
              ),
            ),
          ],
        );
      },
    );
  }
}
