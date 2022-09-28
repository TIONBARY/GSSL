import 'package:GSSL/constants.dart';
import 'package:flutter/material.dart';

class WalkLength extends StatefulWidget {
  final totalWalkLength;

  const WalkLength(this.totalWalkLength);

  @override
  State<WalkLength> createState() => _WalkLengthState();
}

class _WalkLengthState extends State<WalkLength> {
  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return Container(
      child: Column(
        children: <Widget>[
          Padding(
            padding: const EdgeInsets.all(10),
            child: Container(
              width: 2 * (size.width) / 5,
              height: 67.5,
              child: Text(
                convertMeters(widget.totalWalkLength),
                style: TextStyle(
                  fontSize: 25,
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

  String convertMeters(length) {
    if (length > 1000) {
      return (length / 1000).toString() + " \n거리(km)";
    } else {
      return length.toString() + " \n거리(m)";
    }
  }
}
