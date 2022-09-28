import 'package:flutter/material.dart';
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
    await widget._stopWatchTimer.dispose(); // Need to call dispose function.
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
              padding: const EdgeInsets.all(8),
              child: Text(
                displayTime.split('.')[0],
                style: TextStyle(
                    fontSize: 20,
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
