import 'package:GSSL/constants.dart';
import 'package:GSSL/model/response_models/get_walk_total.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../model/response_models/get_pet_detail.dart';
import '../../model/response_models/user_info.dart';

class PetWorkout extends StatelessWidget {
  PetWorkout({
    Key? key,
    this.mainPet,
    this.walkInfo,
    this.done,
    this.user,
    this.loadingPet,
    this.loadingInfo,
    this.loadingDone,
  }) : super(key: key);

  Pet? mainPet;
  TotalInfo? walkInfo;
  bool? done;
  User? user;

  bool? loadingPet;
  bool? loadingInfo;
  bool? loadingDone;

  @override
  Widget build(BuildContext context) {
    if (loadingPet! || loadingInfo! || loadingDone!) {
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
                    done! ? "오늘은 산책을 다녀왔어요!" : "아직 산책을 못했어요.."),
              ),
              Text(
                  style: TextStyle(
                    // fontFamily: "Sub",
                    fontSize: 15.sp,
                  ),
                  "${user?.nickname}님과 ${mainPet?.name}님은 이만큼 산책했어요."),
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
