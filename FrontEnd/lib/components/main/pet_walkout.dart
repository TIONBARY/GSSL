import 'package:GSSL/api/api_walk.dart';
import 'package:GSSL/constants.dart';
import 'package:GSSL/model/response_models/get_walk_total.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../api/api_pet.dart';
import '../../api/api_user.dart';
import '../../model/response_models/get_pet_detail.dart';
import '../../model/response_models/get_walk_done.dart';
import '../../model/response_models/user_info.dart';

class pet_walkout extends StatefulWidget {
  const pet_walkout({Key? key}) : super(key: key);

  @override
  State<pet_walkout> createState() => _pet_walkoutState();
}

class _pet_walkoutState extends State<pet_walkout> {
  Pet? mainPet;
  TotalInfo? walkInfo;
  bool done = false;
  User? user;

  ApiUser apiUser = ApiUser();
  ApiPet apiPet = ApiPet();
  ApiWalk apiWalk = ApiWalk();

  bool _loadingPet = true;
  bool _loadingInfo = true;
  bool _loadingDone = true;

  Future<void> getUser() async {
    userInfo? userInfoResponse = await apiUser.getUserInfo();
    if (userInfoResponse.statusCode == 200) {
      setState(() {
        user = userInfoResponse.user;
      });
      getMainPet();
      getTotalInfo();
      getIsDone();
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
    }
  }

  Future<void> getTotalInfo() async {
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
    getWalkDone? getWalkDoneResponse = await apiWalk.getIsDone(user!.petId!);
    if (getWalkDoneResponse.statusCode == 200) {
      setState(() {
        done = getWalkDoneResponse.done!;
        _loadingDone = false;
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
    if (_loadingPet || _loadingInfo || _loadingDone) {
      return Container(
          margin: EdgeInsets.fromLTRB(0, 10.h, 0, 10.h),
          child: Column(children: [
            Padding(
                padding: const EdgeInsets.symmetric(vertical: defaultPadding),
                child: Center(
                    child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Image.asset("assets/images/loadingDog.gif",
                        width: 120.w, height: 100.h, fit: BoxFit.fill),
                  ],
                ))),
          ]));
    } else {
      return Container(
          width: double.infinity,
          height: 130.h,
          // color: Colors.grey,
          child: Column(
            children: [
              Container(
                padding: EdgeInsets.all(10.h),
                child: Text(
                    style: TextStyle(
                      fontFamily: "Sub",
                      fontSize: 25.sp,
                    ),
                    done ? "오늘은 산책을 다녀왔어요!" : "아직 산책을 못했어요.."),
              ),
              Text(
                  style: TextStyle(
                    // fontFamily: "Sub",
                    fontSize: 15.sp,
                  ),
                  "${mainPet?.name}와 이만큼 산책했어요."),
              Padding(
                padding: EdgeInsets.fromLTRB(0, 10.h, 0, 10.h),
                child: Text(
                    style: TextStyle(
                      fontFamily: "Sub",
                      fontSize: 20.sp,
                    ),
                    "${walkInfo?.distance_sum}m, ${(walkInfo!.time_passed! / 60).round()}분"),
              ),
            ],
          ));
    }
  }
}
