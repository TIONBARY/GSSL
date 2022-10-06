import 'package:GSSL/components/community/first_form.dart';
import 'package:GSSL/components/community/second_form.dart';
import 'package:GSSL/components/community/third_form.dart';
import 'package:GSSL/constants.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

void main() => runApp(
    MaterialApp(debugShowCheckedModeBanner: false, home: CommunityApp()));

class CommunityApp extends StatelessWidget {
  const CommunityApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
        length: 3,
        child: Scaffold(
          appBar: AppBar(
            automaticallyImplyLeading: false,
            iconTheme: IconThemeData(
              color: btnColor,
              size: 20,
            ),
            toolbarHeight: 25,
            backgroundColor: pColor,
            bottom: TabBar(
              tabs: [
                Tab(text: '자랑하기', icon: Icon(Icons.favorite)),
                Tab(text: '진단공유', icon: Icon(Icons.share)),
                Tab(text: '질문하기', icon: Icon(Icons.question_mark)),
              ],
              indicatorColor: btnColor,
              unselectedLabelColor: sColor,
              labelColor: btnColor,
              labelStyle: TextStyle(
                fontSize: 15.sp,
                fontFamily: "Daehan",
              ),
            ),
          ),
          body: TabBarView(
            children: [
              FirstPage(),
              SecondPage(),
              ThirdPage(),
            ],
          ),
        ));
  }
}
