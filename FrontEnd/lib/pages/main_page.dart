import 'package:GSSL/constants.dart';
import 'package:GSSL/pages/bogam_page.dart';
import 'package:GSSL/pages/diary_page.dart';
import 'package:GSSL/pages/signup_pet_page.dart';
import 'package:GSSL/pages/walk_map.dart';

import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter/services.dart';
import 'package:geolocator/geolocator.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';

import '../components/bottomNavBar.dart';
import '../components/main/main_function_box.dart';

void main() {
  SystemChrome.setSystemUIOverlayStyle(SystemUiOverlayStyle(
    systemNavigationBarColor: Colors.black,// navigation bar color
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
      title: 'Flutter Demo',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: const MainPage(),
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
        color: Color(0xFFFFFDF4),
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
      bottomNavigationBar: bottomNavBar(
          back_com : pColor,
          back_home : sColor,
          back_loc : pColor,
          icon_color_com: btnColor,
          icon_color_home: Color(0xFFFFFDF4),
          icon_color_loc: btnColor),
    );
  }
}

class UserBar extends StatelessWidget {
  const UserBar({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.fromLTRB(0, 30, 0, 0),
      // padding: EdgeInsets.fromLTRB(0, 10, 0, 10),
      decoration: BoxDecoration(
          // borderRadius: BorderRadius.circular(45),
          // color: Color(0xFFFFE6BC),
          ),
      child: Row(
        children: [
          Flexible(
              child: Container(
            margin: EdgeInsets.fromLTRB(30, 0, 0, 0),
            child: SizedBox(
              width: 80.0,
              height: 80.0,
              child: GestureDetector(
                onTap: () => print('이미지 클릭'),
                child: CircleAvatar(
                  backgroundColor: btnColor,
                  // backgroundImage: NetworkImage(widget.user.photoUrl),
                ),
              ),
            ),
          )),
          Flexible(
            child: Container(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Flexible(
                    child: Container(
                      child: Container(
                        padding: EdgeInsets.fromLTRB(20, 10, 0, 10),
                        child: Text(
                          "주인의 멍멍이",
                          style: TextStyle(color: btnColor),
                        ),
                        width: double.infinity,
                        height: double.infinity,
                      ),
                    ),
                    flex: 1,
                  ),
                  // Flexible(
                  //   child: Container(
                  //     child: Container(
                  //       padding: EdgeInsets.fromLTRB(0, 10, 0, 10),
                  //       child: Text(
                  //         "건강하자",
                  //         style: TextStyle(
                  //           color: Color(0xFF483434),
                  //         ),
                  //       ),
                  //       width: double.infinity,
                  //       height: double.infinity,
                  //     ),
                  //   ),
                  //   flex: 1,
                  // ),
                ],
              ),
            ),
            flex: 3,
          ),
          Flexible(
            child: Container(
              child: Container(
                child: IconButton(
                  icon: Icon(Icons.wifi_protected_setup),
                  color: btnColor,
                  onPressed: () {
                    showModalBottomSheet<void>(
                      context: context,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(25.0),
                      ),
                      builder: (BuildContext context) {
                        return Container(
                          height: 275,
                          decoration: new BoxDecoration(
                            color: pColor,
                            borderRadius: new BorderRadius.only(
                              topLeft: const Radius.circular(25.0),
                              topRight: const Radius.circular(25.0),
                            ),
                          ),
                          child: Center(
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              // mainAxisSize: MainAxisSize.min,
                              children: <Widget>[
                                Row(
                                  children: [
                                    // petmodal 함수적용
                                    Flexible(
                                        child: Container(
                                      margin: EdgeInsets.fromLTRB(20, 0, 20, 0),
                                      child: SizedBox(
                                        width: 65.0,
                                        height: 65.0,
                                        child: GestureDetector(
                                          onTap: () => print('이미지 클릭'),
                                          child: CircleAvatar(
                                              // backgroundImage: NetworkImage(widget.user.photoUrl),
                                              ),
                                        ),
                                      ),
                                    )),
                                    // Flexible(
                                    //     child: Container(
                                    //       margin: EdgeInsets.fromLTRB(20, 0, 20, 0),
                                    //       child: SizedBox(
                                    //         width: 65.0,
                                    //         height: 65.0,
                                    //         child: GestureDetector(
                                    //           onTap: () => print('이미지 클릭'),
                                    //           child: CircleAvatar(
                                    //             // backgroundImage: NetworkImage(widget.user.photoUrl),
                                    //           ),
                                    //         ),
                                    //       ),
                                    //     )),
                                  ],
                                ),
                                Container(
                                  margin: EdgeInsets.fromLTRB(0, 10, 0, 10),
                                  child: SizedBox(
                                    child: IconButton(
                                      icon: Icon(Icons.add),
                                      iconSize: 50,
                                      color: btnColor,
                                      onPressed: () => Navigator.push(
                                        context,
                                        MaterialPageRoute(builder: (context) => SignUpPetScreen()),
                                      ),
                                    ),
                                  ),
                                )
                              ],
                            ),
                          ),
                        );
                      },
                    );
                  },
                ),
                width: double.infinity,
                height: double.infinity,
              ),
            ),
            flex: 1,
          ),
        ],
      ),
    );
  }
}

class behavior_diagnosis extends StatelessWidget {
  const behavior_diagnosis({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return function_box(
      title: '견민정음',
      box_color: Color(0x80DFB45B),
      paddings: EdgeInsets.fromLTRB(30, 30, 30, 15),
      nextPage: GalleryApp(),
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
      paddings: EdgeInsets.fromLTRB(30, 15, 30, 15),
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
  @override
  Widget build(BuildContext context) {
    return function_box(
      title: '견중일기',
      box_color: Color(0x80C66952),
      paddings: EdgeInsets.fromLTRB(30, 15, 30, 30),
      nextPage: GalleryApp(),
    );
  }
}
