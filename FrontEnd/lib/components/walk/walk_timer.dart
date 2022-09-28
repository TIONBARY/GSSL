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
    Size size = MediaQuery.of(context).size;
    return StreamBuilder<int>(
      stream: widget._stopWatchTimer.rawTime,
      initialData: 0,
      builder: (context, snap) {
        final value = snap.data!;
        final displayTime = StopWatchTimer.getDisplayTime(value);
        return Container(
          child: Column(
            children: <Widget>[
              Padding(
                padding: const EdgeInsets.all(10),
                child: Container(
                  width: 2 * (size.width) / 5,
                  height: 67.5,
                  child: Text(
                    displayTime,
                    style: TextStyle(
                      fontSize: 25,
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
      },
    );
  }
}
