import 'package:GSSL/components/diary/diary_form.dart';
import 'package:GSSL/components/diary/walk_form.dart';
import 'package:GSSL/constants.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class GalleryApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 2,
      child: Scaffold(
        backgroundColor: nWColor,
        appBar: AppBar(
          iconTheme: IconThemeData(
            color: btnColor,
            size: 15.h,
          ),
          toolbarHeight: 20.h,
          backgroundColor: pColor,
          bottom: TabBar(
            tabs: [
              Tab(text: '일지', icon: Icon(Icons.menu_book)),
              Tab(text: '산책', icon: Icon(Icons.pets)),
            ],
            indicatorColor: btnColor,
            unselectedLabelColor: sColor,
            labelColor: btnColor,
            labelStyle: TextStyle(
              fontSize: 14.sp,
              fontFamily: "Sub",
            ),
          ),
        ),
        body: TabBarView(
          children: [
            DiaryPage(),
            WalkPage(),
          ],
        ),
      ),
    );
  }
}
