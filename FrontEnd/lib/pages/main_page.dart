import 'package:GSSL/api/api_pet.dart';
import 'package:GSSL/api/api_user.dart';
import 'package:GSSL/api/api_walk.dart';
import 'package:GSSL/components/main/main_boast_area.dart';
import 'package:GSSL/components/main/pet_walkout.dart';
import 'package:GSSL/components/util/custom_dialog.dart';
import 'package:GSSL/constants.dart';
import 'package:GSSL/model/response_models/general_response.dart';
import 'package:GSSL/model/response_models/get_all_pet.dart';
import 'package:GSSL/model/response_models/get_pet_detail.dart';
import 'package:GSSL/model/response_models/get_walk_done.dart';
import 'package:GSSL/model/response_models/get_walk_total.dart';
import 'package:GSSL/model/response_models/user_info.dart';
import 'package:GSSL/pages/bogam_page.dart';
import 'package:GSSL/pages/diary_page.dart';
import 'package:GSSL/pages/jeongeum_page.dart';
import 'package:GSSL/pages/login_page.dart';
import 'package:GSSL/pages/pet_detail_page.dart';
import 'package:GSSL/pages/signup_pet_page.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../components/bottomNavBar.dart';
import '../components/main/health_magazine.dart';
import '../components/main/main_function_box.dart';
import '../components/main/main_question_area.dart';

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
  String S3Address = "https://a204drdoc.s3.ap-northeast-2.amazonaws.com/";
  String? nickname;
  Pet? mainPet;
  User? user;
  List<Pets>? pets;
  AssetImage basic_image = AssetImage("assets/images/basic_dog.png");

  ApiUser apiUser = ApiUser();
  ApiPet apiPet = ApiPet();
  ApiWalk apiWalk = ApiWalk();

  TotalInfo? walkInfo;
  bool done = false;

  bool _loadingPet = true;
  bool _loadingInfo = true;
  bool _loadingDone = true;

  @override
  void initState() {
    super.initState();
    getUser();
  }

  Future<void> getUser() async {
    userInfo? userInfoResponse = await apiUser.getUserInfo();
    if (userInfoResponse.statusCode == 200) {
      setState(() {
        user = userInfoResponse.user;
        nickname = user?.nickname;
      });
      if (user?.petId != 0) {
        getMainPet();
        getTotalInfo();
        getIsDone();
      }
      getAllPetList();
    } else if (userInfoResponse.statusCode == 401) {
      showDialog(
          context: context,
          builder: (BuildContext context) {
            return CustomDialog("로그인이 필요합니다.", (context) => LoginScreen());
          });
    } else {
      showDialog(
          context: context,
          builder: (BuildContext context) {
            return CustomDialog(
                userInfoResponse.message == null
                    ? "알 수 없는 오류가 발생했습니다."
                    : userInfoResponse.message!,
                (context) => MainPage());
          });
    }
  }

  Future<void> getMainPet() async {
    getPetDetail? getMainPetResponse =
        await apiPet.getPetDetailApi(user?.petId);
    if (getMainPetResponse.statusCode == 200) {
      setState(() {
        mainPet = getMainPetResponse.pet;
        _loadingPet = false;
      });
    } else if (getMainPetResponse.statusCode == 401) {
      showDialog(
          context: context,
          builder: (BuildContext context) {
            return CustomDialog("로그인이 필요합니다.", (context) => LoginScreen());
          });
    } else {
      showDialog(
          context: context,
          builder: (BuildContext context) {
            return CustomDialog(
                getMainPetResponse.message == null
                    ? "알 수 없는 오류가 발생했습니다."
                    : getMainPetResponse.message!,
                (context) => MainPage());
          });
    }
  }

  Future<void> getAllPetList() async {
    if (!mounted) {
      return;
    }
    getAllPet? getAllPetResponse = await apiPet.getAllPetApi();
    if (getAllPetResponse.statusCode == 200) {
      setState(() {
        pets = getAllPetResponse.pets;
      });
    } else if (getAllPetResponse.statusCode == 401) {
      showDialog(
          context: context,
          builder: (BuildContext context) {
            return CustomDialog("로그인이 필요합니다.", (context) => LoginScreen());
          });
    } else {
      showDialog(
          context: context,
          builder: (BuildContext context) {
            return CustomDialog(
                getAllPetResponse.message == null
                    ? "알 수 없는 오류가 발생했습니다."
                    : getAllPetResponse.message!,
                (context) => MainPage());
          });
    }
  }

  Future<void> getTotalInfo() async {
    if (!mounted) {
      return;
    }
    getWalkTotalInfo? getWalkTotalInfoResponse =
        await apiWalk.getTotalInfo(user!.petId!);
    if (getWalkTotalInfoResponse.statusCode == 200) {
      setState(() {
        walkInfo = getWalkTotalInfoResponse.totalInfo;
        _loadingInfo = false;
      });
    }
  }

  Future<void> getIsDone() async {
    if (!mounted) {
      return;
    }
    getWalkDone? getWalkDoneResponse = await apiWalk.getIsDone(user!.petId!);
    debugPrint(getWalkDoneResponse.message);
    if (getWalkDoneResponse.statusCode == 200) {
      setState(() {
        done = getWalkDoneResponse.done!;
        _loadingDone = false;
      });
    } else if (getWalkDoneResponse.statusCode == 400 &&
        getWalkDoneResponse.message == "해당 반려동물의 산책기록이 없습니다.") {
      setState(() {
        done = false;
        _loadingDone = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return RefreshIndicator(
      onRefresh: () async {
        getUser();
      },
      child: ListView(
        children: [
          _loadingPet
              ? Container(
                  // color: Colors.black,
                  margin: EdgeInsets.fromLTRB(0, 10.h, 0, 10.h),
                  child: Column(children: [
                    Padding(
                        padding: const EdgeInsets.symmetric(
                            vertical: defaultPadding),
                        child: Center(
                            child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Image.asset("assets/images/loadingDog.gif",
                                width: 80.w, height: 60.h, fit: BoxFit.fill),
                          ],
                        ))),
                  ]))
              : Container(
                  width: double.infinity,
                  height: 90.h,
                  // margin: EdgeInsets.fromLTRB(0, 15.h, 0, 0),
                  // padding: EdgeInsets.fromLTRB(0, 10, 0, 10),
                  decoration: BoxDecoration(
                      // borderRadius: BorderRadius.circular(45),
                      // color: Color(0xFFFFE6BC),
                      ),
                  child: Container(
                    padding: EdgeInsets.symmetric(horizontal: 25.w),
                    decoration: new BoxDecoration(
                      color: nWColor,
                      borderRadius: new BorderRadius.all(Radius.circular(5)),
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Flexible(
                            child: Container(
                              child: SizedBox(
                                width: 65.w,
                                height: 65.h,
                                child: GestureDetector(
                                  onTap: () {
                                    Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                          builder: (context) =>
                                              PetDetailScreen()),
                                    );
                                  },
                                  child: mainPet?.animalPic == null ||
                                          mainPet?.animalPic!.length == 0
                                      ? CircleAvatar(
                                          backgroundImage: basic_image,
                                        )
                                      : CircleAvatar(
                                          backgroundImage: NetworkImage(
                                              S3Address + mainPet!.animalPic!),
                                          radius: 150.0),
                                ),
                              ),
                            ),
                            flex: 2),
                        Container(
                          child: Flexible(
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.start,
                              children: [
                                Flexible(
                                  child: Container(
                                    child: Text(
                                      textScaleFactor: 1.25.sp,
                                      mainPet?.name == null
                                          ? "등록된 반려견이 없습니다."
                                          : nickname! + "의 " + mainPet!.name!,
                                      overflow: TextOverflow.ellipsis,
                                      style: TextStyle(
                                          fontWeight: FontWeight.w900,
                                          color: btnColor,
                                          fontFamily: "Sub"),
                                    ),
                                  ),
                                ),
                              ],
                            ),
                            flex: 4,
                          ),
                        ),
                        Container(
                          child: Flexible(
                            child: SizedBox(
                              width: 40.w,
                              height: double.infinity,
                              child: IconButton(
                                padding: EdgeInsets.zero,
                                icon: Icon(
                                  Icons.arrow_drop_down,
                                  size: 40.sp,
                                ),
                                color: btnColor,
                                onPressed: () {
                                  // 모달창
                                  showModalBottomSheet<void>(
                                    context: context,
                                    shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(25.0),
                                    ),
                                    builder: (BuildContext context) {
                                      return Container(
                                        padding: EdgeInsets.fromLTRB(
                                            20.w, 20.h, 20.w, 0),
                                        height: 225.h,
                                        decoration: new BoxDecoration(
                                          color: pColor,
                                          borderRadius: new BorderRadius.only(
                                            topLeft:
                                                const Radius.circular(25.0),
                                            topRight:
                                                const Radius.circular(25.0),
                                          ),
                                        ),
                                        child: Center(
                                          child: Column(
                                            mainAxisAlignment:
                                                MainAxisAlignment.center,
                                            // mainAxisSize: MainAxisSize.min,
                                            children: <Widget>[
                                              pets == null || pets!.length == 0
                                                  ? Text("등록된 반려견이 없습니다.")
                                                  : Expanded(
                                                      child: GridView.count(
                                                        // Create a grid with 2 columns. If you change the scrollDirection to
                                                        // horizontal, this produces 2 rows.
                                                        crossAxisCount: 4,
                                                        // Generate 100 widgets that display their index in the List.
                                                        children: List.generate(
                                                            pets!.length,
                                                            (index) {
                                                          Pets pet = pets!
                                                              .elementAt(index);
                                                          return Container(
                                                              margin: EdgeInsets
                                                                  .fromLTRB(0,
                                                                      0, 0, 0),
                                                              child: Column(
                                                                  children: [
                                                                    SizedBox(
                                                                      width:
                                                                          50.w,
                                                                      height:
                                                                          50.h,
                                                                      child: GestureDetector(
                                                                          onTap: () async {
                                                                            generalResponse
                                                                                res =
                                                                                await apiUser.modifyUserPetAPI(pet.id!);
                                                                            if (res.statusCode ==
                                                                                200) {
                                                                              await getUser();
                                                                              await getMainPet();
                                                                              Navigator.pop(context);
                                                                            }
                                                                          },
                                                                          child: pet.animalPic == null || pet.animalPic!.length == 0 ? CircleAvatar(backgroundImage: basic_image, radius: 100.0) : CircleAvatar(backgroundImage: NetworkImage(S3Address + pet.animalPic!), radius: 100.0)),
                                                                    ),
                                                                    Text(
                                                                      pet.name!,
                                                                      style: TextStyle(
                                                                          fontFamily:
                                                                              "Sub",
                                                                          color:
                                                                              btnColor),
                                                                    )
                                                                  ]));
                                                        }),
                                                      ),
                                                    ),
                                              Container(
                                                child: IconButton(
                                                  icon: Icon(Icons.add),
                                                  iconSize: 37.5.h,
                                                  color: btnColor,
                                                  onPressed: () =>
                                                      Navigator.push(
                                                    context,
                                                    MaterialPageRoute(
                                                        builder: (context) =>
                                                            SignUpPetScreen()),
                                                  ),
                                                ),
                                              ),
                                            ],
                                          ),
                                        ),
                                      );
                                    },
                                  );
                                },
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  )),
          PetWorkout(
            user: user,
            mainPet: mainPet,
            walkInfo: walkInfo,
            loadingPet: _loadingPet,
            loadingInfo: _loadingInfo,
            loadingDone: _loadingDone,
            done: done,
          ),
          diagnosis(mainPetName: mainPet?.name),
          blockTitle(
            title: "견생실록 꿀팁 매거진",
          ),
          health_magazine(),
          blockTitle(title: "견생실록 내새끼 자랑하기"),
          MainBoastArea(),
          blockTitle(
            title: "최근 질문 게시글",
          ),
          MainQuestionArea(),
        ],
      ),
    );
  }
}

class blockTitle extends StatelessWidget {
  const blockTitle({Key? key, required this.title}) : super(key: key);

  final title;

  @override
  Widget build(BuildContext context) {
    return Container(
      color: nWColor,
      child: Padding(
        padding: EdgeInsets.fromLTRB(0, 25.h, 0, 0),
        child: Container(
            color: nWColor,
            padding: EdgeInsets.fromLTRB(13.w, 8.h, 0, 0),
            margin: EdgeInsets.fromLTRB(0, 0, 0, 13.h),
            width: 40.w,
            height: 35.h,
            child: Text(
              title,
              style: TextStyle(
                fontSize: 20.sp,
                fontWeight: FontWeight.bold,
                fontFamily: "Sub",
              ),
            )),
      ),
    );
  }
}

class diagnosis extends StatelessWidget {
  const diagnosis({Key? key, this.mainPetName}) : super(key: key);

  final String? mainPetName;

  @override
  Widget build(BuildContext context) {
    return CarouselSlider(
      options: CarouselOptions(height: 0.25.sh),
      items: [
        behavior_diagnosis(mainPetName: mainPetName),
        health_diagnosis(mainPetName: mainPetName),
        diary(mainPetName: mainPetName),
      ].map((i) {
        return Builder(
          builder: (BuildContext context) {
            return Container(
              width: double.infinity,
              decoration: BoxDecoration(color: nWColor),
              child: i,
            );
          },
        );
      }).toList(),
    );
  }
}

class behavior_diagnosis extends StatelessWidget {
  const behavior_diagnosis({Key? key, this.mainPetName}) : super(key: key);

  final String? mainPetName;

  @override
  Widget build(BuildContext context) {
    return function_box(
      title: '견민정음',
      box_color: Color(0x30C66952),
      paddings: EdgeInsets.fromLTRB(0.035.sw, 0.015.sh, 0.015.sw, 0.035.sh),
      description:
          "${mainPetName == null ? '강아지' : mainPetName}의 속마음, \nAI 영상 분석을 통해 알려드릴게요.",
      nextPage: JeongeumPage(),
    );
  }
}

class health_diagnosis extends StatelessWidget {
  const health_diagnosis({Key? key, this.mainPetName}) : super(key: key);

  final String? mainPetName;

  @override
  Widget build(BuildContext context) {
    return function_box(
      title: '견의보감',
      box_color: Color(0x30506274),
      paddings: EdgeInsets.fromLTRB(0.035.sw, 0.015.sh, 0.015.sw, 0.035.sh),
      description:
          "${mainPetName == null ? '강아지' : mainPetName}의 건강이 걱정 되시나요?\nAI를 통해 1차 진단을 받을 수 있어요.",
      nextPage: BogamPage(),
    );
  }
}

class diary extends StatelessWidget {
  const diary({Key? key, this.mainPetName}) : super(key: key);

  final String? mainPetName;

  @override
  Widget build(BuildContext context) {
    return function_box(
      title: '견중일기',
      box_color: Color(0x30DFB45B),
      paddings: EdgeInsets.fromLTRB(0.035.sw, 0.015.sh, 0.015.sw, 0.035.sh),
      description:
          "${mainPetName == null ? '강아지' : mainPetName}의 지금까지의 진단 기록을 볼 수 있어요.",
      nextPage: GalleryApp(),
    );
  }
}
