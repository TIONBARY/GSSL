import 'package:GSSL/api/api_pet.dart';
import 'package:GSSL/components/main/main_profile_bar.dart';
import 'package:GSSL/constants.dart';
import 'package:GSSL/model/response_models/get_pet_detail.dart';
import 'package:GSSL/pages/bogam_page.dart';
import 'package:GSSL/pages/diary_page.dart';
import 'package:GSSL/pages/jeongeum_page.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../components/bottomNavBar.dart';
import '../components/main/main_function_box.dart';

void main() {
  SystemChrome.setSystemUIOverlayStyle(SystemUiOverlayStyle(
    systemNavigationBarColor: Colors.black, // navigation bar color
    statusBarColor: pColor, // status bar color
  ));

  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: BottomNavBar(),
    );
  }
}

class MainPage extends StatefulWidget {
  const MainPage({Key? key}) : super(key: key);

  @override
  State<MainPage> createState() => _MainPageState();
}

class _MainPageState extends State<MainPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      appBar: AppBar(
        toolbarHeight: 0,
      ),
      body: Container(
        color: nWColor,
        child: Column(
          children: [
            Flexible(
              child: UserBar(),
              flex: 1,
            ),
            Flexible(
              child: behavior_diagnosis(),
              flex: 2,
            ),
            Flexible(
              child: health_diagnosis(),
              flex: 2,
            ),
            Flexible(
              child: diary(),
              flex: 2,
            ),
          ],
        ),
      ),
    );
  }
}

class UserBar extends StatelessWidget {
  const UserBar({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
        margin: EdgeInsets.fromLTRB(0, 15.h, 0, 0),
        // padding: EdgeInsets.fromLTRB(0, 10, 0, 10),
        decoration: BoxDecoration(
            // borderRadius: BorderRadius.circular(45),
            // color: Color(0xFFFFE6BC),
            ),
        child: MainHeaderBar());
  }
}

class behavior_diagnosis extends StatelessWidget {
  const behavior_diagnosis({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return function_box(
      title: '견민정음',
      box_color: Color(0x80C66952),
      paddings: EdgeInsets.fromLTRB(25.w, 15.h, 25.w, 15.h),
      description: "멍멍이는 지금 어떤 생각을 하고 있을까? 카메라로 찍어보세요!",
      nextPage: JeongeumPage(),
    );
  }
}

class health_diagnosis extends StatelessWidget {
  const health_diagnosis({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return function_box(
      title: '견의보감',
      box_color: Color(0x80506274),
      paddings: EdgeInsets.fromLTRB(25.w, 15.h, 25.w, 15.h),
      description: "혹시 아픈 곳이 있지 않을까? AI를 통해 간이 진단을 해보세요!",
      nextPage: BogamPage(),
    );
  }
}

class diary extends StatefulWidget {
  const diary({Key? key}) : super(key: key);

  @override
  State<diary> createState() => _diaryState();
}

class _diaryState extends State<diary> {
  Pet? pet;
  ApiPet apiPet = ApiPet();

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return function_box(
      title: '견중일기',
      box_color: Color(0x80DFB45B),
      paddings: EdgeInsets.fromLTRB(25.w, 15.h, 25.w, 15.h),
      description: "${pet?.name}의 진단 기록을 볼 수 있어요.",
      nextPage: GalleryApp(),
    );
  }
}
