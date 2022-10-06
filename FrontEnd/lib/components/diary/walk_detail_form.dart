import 'dart:io';

import 'package:GSSL/api/api_walk.dart';
import 'package:GSSL/components/bottomNavBar.dart';
import 'package:GSSL/components/diary/walk_pet_selection_form.dart';
import 'package:GSSL/components/util/custom_dialog.dart';
import 'package:GSSL/constants.dart';
import 'package:GSSL/model/response_models/get_walk_detail.dart';
import 'package:GSSL/pages/login_page.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class WalkDetailsPage extends StatefulWidget {
  final String imagePath;
  final String title;
  final String distance;
  final int walkId;

  WalkDetailsPage(
      {required this.imagePath,
      required this.title,
      required this.distance,
      required this.walkId});

  @override
  State<WalkDetailsPage> createState() => _WalkDetailsPageState();
}

class _WalkDetailsPageState extends State<WalkDetailsPage> {
  ApiWalk apiWalk = ApiWalk();

  String? petNames;

  bool loading = true;

  String getPetNameString(List<PetsList> list) {
    String nameStr = "";
    list.forEach((PetsList pet) {
      nameStr += pet.name! + " ";
    });
    return nameStr;
  }

  Future<void> _getWalkDetail() async {
    setState(() {
      petNames = "";
    });
    getWalkDetail? walkDetailResponse = await apiWalk.getWalk(widget.walkId);
    if (walkDetailResponse.statusCode == 200) {
      setState(() {
        petNames = getPetNameString(walkDetailResponse!.detail!.petsList!);
        loading = false;
      });
    } else if (walkDetailResponse.statusCode == 401) {
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
                walkDetailResponse.message == null
                    ? "알 수 없는 오류가 발생했습니다."
                    : walkDetailResponse.message!,
                (context) => BottomNavBar());
          });
    }
  }

  @override
  @override
  void initState() {
    super.initState();
    _getWalkDetail();
  }

  @override
  Widget build(BuildContext context) {
    if (loading) {
      return Scaffold(
          body: SafeArea(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Expanded(
                child: Container(
              padding: EdgeInsets.fromLTRB(10.w, 10.h, 10.w, 10.h),
              decoration: BoxDecoration(
                color: nWColor,
                image: DecorationImage(
                    fit: BoxFit.contain,
                    image: AssetImage("assets/images/loadingDog.gif")),
              ),
            ))
          ],
        ),
      ));
    } else {
      int walkId = widget.walkId;
      String imagePath = widget.imagePath;
      String title = widget.title;
      String _petNames = petNames!;
      String distance = widget.distance;
      return Scaffold(
        body: Container(
          child: Column(
            children: <Widget>[
              Expanded(
                child: Stack(children: [
                  Hero(
                    tag: 'WalkDetail$walkId',
                    child: Container(
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.only(
                            bottomLeft: Radius.circular(30),
                            bottomRight: Radius.circular(30)),
                        image: File(imagePath).existsSync()
                            ? DecorationImage(
                                image: FileImage(File(imagePath)),
                                fit: BoxFit.cover)
                            : DecorationImage(
                                image:
                                    AssetImage("assets/images/basic_dog.png"),
                                fit: BoxFit.cover,
                              ),
                      ),
                    ),
                  ),
                ]),
              ),
              Stack(
                children: [
                  Container(
                    height: 250.h,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: <Widget>[
                        Padding(
                          padding: EdgeInsets.fromLTRB(20.w, 15.h, 20.w, 0),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.stretch,
                            mainAxisAlignment: MainAxisAlignment.end,
                            children: <Widget>[
                              Text(
                                '$_petNames',
                                style: TextStyle(
                                    color: btnColor,
                                    fontSize: 25.sp,
                                    fontWeight: FontWeight.w500,
                                    fontFamily: "Sub"),
                              ),
                              Text(
                                '$title',
                                style: TextStyle(
                                  fontFamily: "Sub",
                                  color: sColor,
                                  fontSize: 11.sp,
                                ),
                              ),
                              SizedBox(
                                height: 25.h,
                              ),
                              Text(
                                '이동거리: $distance',
                                style: TextStyle(
                                  color: btnColor,
                                  fontSize: 20.sp,
                                  fontFamily: "Sub",
                                ),
                              ),
                              // Text(
                              //   '$index',
                              //   style: TextStyle(
                              //     fontSize: 14,
                              //   ),
                              // ),
                            ],
                          ),
                        ),
                        Row(
                          children: <Widget>[
                            Expanded(
                              flex: 1,
                              child: TextButton(
                                onPressed: () {
                                  Navigator.pop(context);
                                },
                                style: TextButton.styleFrom(
                                  padding:
                                      EdgeInsets.symmetric(vertical: 12.5.h),
                                  foregroundColor: btnColor,
                                  backgroundColor: btnColor,
                                ),
                                child: Text(
                                  '뒤로가기',
                                  style: TextStyle(
                                    color: nWColor,
                                    fontFamily: "Sub",
                                    fontSize: 15.sp,
                                  ),
                                ),
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                  Positioned(
                    right: 5.w,
                    bottom: 55.h,
                    child: FloatingActionButton(
                        child: Icon(Icons.edit),
                        elevation: 5,
                        hoverElevation: 10,
                        tooltip: "수정",
                        backgroundColor: sColor,
                        mini: true,
                        onPressed: () {
                          // debugPrint("삭제");{
                          Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                      builder: (context) =>
                                          WalkPetSelectionPage(walkId: walkId)))
                              .then((res) => _getWalkDetail());
                        }

                        // Navigator.pop(context);
                        ),
                  ),
                ],
              ),
            ],
          ),
        ),
      );
    }
  }
}
