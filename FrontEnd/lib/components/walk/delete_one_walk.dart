import 'dart:io';

import 'package:GSSL/api/api_walk.dart';
import 'package:flutter/material.dart';

class DeleteOneWalk extends StatelessWidget {
  final int walkId;
  final String imagePath;

  DeleteOneWalk({required this.walkId, required this.imagePath});

  @override
  Widget build(BuildContext context) {
    if (File(imagePath).existsSync()) {
      File(imagePath).deleteSync();
    }

    if (!File(imagePath).existsSync()) {
      // 삭제 요청 전송
      ApiWalk().deleteWalk(walkId).then((value) =>
          // 뒤로가기
          Navigator.pop(context));
    }
    // 뒤로가기
    Navigator.pop(context);

    return Scaffold();
  }
}
