import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

import '../constants.dart';

class Logo extends StatelessWidget {
  const Logo({
    Key? key,
    required this.heights,
  }) : super(key: key);
  final heights;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        SizedBox(height: heights),
        Row(
          children: [
            const Spacer(),
            Expanded(
              flex: 8,
              child: SvgPicture.asset("assets/icons/mainlogo2.svg"),
            ),
            const Spacer(),
          ],
        ),
        SizedBox(height: heights),
      ],
    );
  }
}