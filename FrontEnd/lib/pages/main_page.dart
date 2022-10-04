import 'package:GSSL/api/api_pet.dart';
import 'package:GSSL/api/api_user.dart';
import 'package:GSSL/components/main/main_profile_bar.dart';
import 'package:GSSL/constants.dart';
import 'package:GSSL/model/response_models/get_pet_detail.dart';
import 'package:GSSL/model/response_models/user_info.dart';
import 'package:GSSL/pages/bogam_page.dart';
import 'package:GSSL/pages/diary_page.dart';
import 'package:GSSL/pages/jeongeum_page.dart';
import 'package:carousel_slider/carousel_slider.dart';
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
    return ListView(
      children: [
        UserBar(),
        pet_walkout(),
        diagnosis(),
        health_magazine(),
        pet_boast(),
        recent_board(),
      ],
    );
  }
}

//기존 코드, 클릭시 열림
//Scaffold(
//       resizeToAvoidBottomInset: false,
//       appBar: AppBar(
//         toolbarHeight: 0,
//       ),
//       body: Container(
//         color: nWColor,
//         child: Column(
//           children: [
//             Flexible(
//               child: UserBar(),
//               flex: 2,
//             ),
//             Flexible(
//               child: Container(
//                 color: Colors.grey,
//               ),
//               flex: 1,
//             ),
//             Flexible(
//               child: behavior_diagnosis(),
//               flex: 3,
//             ),
//             Flexible(
//               child: health_diagnosis(),
//               flex: 3,
//             ),
//             Flexible(
//               child: diary(),
//               flex: 3,
//             ),
//           ],
//         ),
//       ),
//     );

class UserBar extends StatelessWidget {
  const UserBar({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
        width: double.infinity,
        height: 90.h,
        margin: EdgeInsets.fromLTRB(0, 15.h, 0, 0),
        // padding: EdgeInsets.fromLTRB(0, 10, 0, 10),
        decoration: BoxDecoration(
            // borderRadius: BorderRadius.circular(45),
            // color: Color(0xFFFFE6BC),
            ),
        child: MainHeaderBar());
  }
}

class pet_walkout extends StatefulWidget {
  const pet_walkout({Key? key}) : super(key: key);

  @override
  State<pet_walkout> createState() => _pet_walkoutState();
}

class _pet_walkoutState extends State<pet_walkout> {
  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      height: 60.h,
      color: Colors.grey,
    );
  }
}

class diagnosis extends StatelessWidget {
  const diagnosis({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return CarouselSlider(
      options: CarouselOptions(height: 250.0),
      items: [
        behavior_diagnosis(),
        health_diagnosis(),
        diary(),
      ].map((i) {
        return Builder(
          builder: (BuildContext context) {
            return Container(
              width: double.infinity,
              margin: EdgeInsets.symmetric(horizontal: 5.0),
              decoration: BoxDecoration(color: Colors.white),
              child: i,
            );
          },
        );
      }).toList(),
    );
  }
}

class health_magazine extends StatelessWidget {
  const health_magazine({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 230.h,
      width: double.infinity,
      padding: EdgeInsets.all(5.h),
      color: Colors.red,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: [
          Column(
            children: [
              Container(
                width: 130.w,
                height: 80.h,
                padding: EdgeInsets.all(5.h),
                margin: EdgeInsets.all(10.h),
                color: Colors.blue,
              ),
              Container(
                width: 130.w,
                height: 80.h,
                padding: EdgeInsets.all(5.h),
                margin: EdgeInsets.all(10.h),
                color: Colors.black,
              ),
            ],
          ),
          Column(
            children: [
              Container(
                width: 130.w,
                height: 80.h,
                padding: EdgeInsets.all(5.h),
                margin: EdgeInsets.all(10.h),
                color: Colors.grey,
              ),
              Container(
                width: 130.w,
                height: 80.h,
                padding: EdgeInsets.all(5.h),
                margin: EdgeInsets.all(10.h),
                color: Colors.white,
              ),
            ],
          )
        ],
      ),
    );
  }
}

class recent_board extends StatelessWidget {
  const recent_board({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      height: 150.h,
      color: Colors.green,
    );
  }
}

class pet_boast extends StatelessWidget {
  const pet_boast({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return CarouselSlider(
      options: CarouselOptions(height: 300.0),
      items: [1, 2, 3, 4, 5].map((i) {
        return Builder(
          builder: (BuildContext context) {
            return Container(
                width: double.infinity,
                margin: EdgeInsets.symmetric(horizontal: 5.0),
                decoration: BoxDecoration(color: Colors.blue),
                child: Text(
                  'text $i',
                  style: TextStyle(fontSize: 16.sp),
                ));
          },
        );
      }).toList(),
    );
    ;
  }
}

class behavior_diagnosis extends StatefulWidget {
  const behavior_diagnosis({Key? key}) : super(key: key);

  @override
  State<behavior_diagnosis> createState() => _behavior_diagnosisState();
}

class _behavior_diagnosisState extends State<behavior_diagnosis> {
  Pet? mainPet;
  User? user;

  ApiUser apiUser = ApiUser();
  ApiPet apiPet = ApiPet();

  Future<void> getUser() async {
    userInfo? userInfoResponse = await apiUser.getUserInfo();
    if (userInfoResponse.statusCode == 200) {
      setState(() {
        user = userInfoResponse.user;
      });
      getMainPet();
    }
  }

  Future<void> getMainPet() async {
    getPetDetail? getMainPetResponse =
        await apiPet.getPetDetailApi(user?.petId);
    if (getMainPetResponse.statusCode == 200) {
      setState(() {
        mainPet = getMainPetResponse.pet;
      });
    }
  }

  @override
  void initState() {
    super.initState();
    getUser();
  }

  @override
  Widget build(BuildContext context) {
    return function_box(
      title: '견민정음',
      box_color: Color(0x80C66952),
      paddings: EdgeInsets.fromLTRB(25.w, 15.h, 25.w, 15.h),
      description: "${mainPet?.name}의 속마음, \nAI 영상 분석을 통해 알려드릴게요.",
      nextPage: JeongeumPage(),
    );
  }
}

class health_diagnosis extends StatefulWidget {
  const health_diagnosis({Key? key}) : super(key: key);

  @override
  State<health_diagnosis> createState() => _health_diagnosisState();
}

class _health_diagnosisState extends State<health_diagnosis> {
  Pet? mainPet;
  User? user;

  ApiUser apiUser = ApiUser();
  ApiPet apiPet = ApiPet();

  Future<void> getUser() async {
    userInfo? userInfoResponse = await apiUser.getUserInfo();
    if (userInfoResponse.statusCode == 200) {
      setState(() {
        user = userInfoResponse.user;
      });
      getMainPet();
    }
  }

  Future<void> getMainPet() async {
    getPetDetail? getMainPetResponse =
        await apiPet.getPetDetailApi(user?.petId);
    if (getMainPetResponse.statusCode == 200) {
      setState(() {
        mainPet = getMainPetResponse.pet;
      });
    }
  }

  @override
  void initState() {
    super.initState();
    getUser();
  }

  @override
  Widget build(BuildContext context) {
    return function_box(
      title: '견의보감',
      box_color: Color(0x80506274),
      paddings: EdgeInsets.fromLTRB(25.w, 15.h, 25.w, 15.h),
      description: "${mainPet?.name}가 아픈 것 같나요?\nAI를 통해 1차 진단을 받을 수 있어요.",
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
  Pet? mainPet;
  User? user;

  ApiUser apiUser = ApiUser();
  ApiPet apiPet = ApiPet();

  Future<void> getUser() async {
    userInfo? userInfoResponse = await apiUser.getUserInfo();
    if (userInfoResponse.statusCode == 200) {
      setState(() {
        user = userInfoResponse.user;
      });
      getMainPet();
    }
  }

  Future<void> getMainPet() async {
    getPetDetail? getMainPetResponse =
        await apiPet.getPetDetailApi(user?.petId);
    if (getMainPetResponse.statusCode == 200) {
      setState(() {
        mainPet = getMainPetResponse.pet;
      });
    }
  }

  @override
  void initState() {
    super.initState();
    getUser();
  }

  @override
  Widget build(BuildContext context) {
    return function_box(
      title: '견중일기',
      box_color: Color(0x80DFB45B),
      paddings: EdgeInsets.fromLTRB(25.w, 15.h, 25.w, 15.h),
      description: "${mainPet?.name}의 지금까지의 진단 기록을 볼 수 있어요.",
      nextPage: GalleryApp(),
    );
  }
}
