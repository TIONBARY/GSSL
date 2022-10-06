import 'package:GSSL/constants.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import 'card_widget.dart';
import 'my_box_widget.dart';

class ContentItemWidget extends StatelessWidget {
  final String name;
  final String? profileImage;
  final String nickname;
  final String? photo;
  ContentItemWidget(
      {required this.name,
      this.profileImage,
      required this.nickname,
      this.photo});

  String S3Address = "https://a204drdoc.s3.ap-northeast-2.amazonaws.com/";

  AssetImage basic_image = AssetImage("assets/images/user.png");

  @override
  Widget build(BuildContext context) {
    return CardWidget(
      pa: 0,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: EdgeInsets.all(10.h),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Container(
                  height: 50.h,
                  width: 50.w,
                  margin: EdgeInsets.fromLTRB(0, 0, 15.w, 0),
                  decoration: new BoxDecoration(
                      color: sColor,
                      borderRadius: new BorderRadius.all(Radius.circular(50))),
                  child: profileImage == null || profileImage!.length! == 0
                      ? CircleAvatar(radius: 50, backgroundImage: basic_image)
                      : CircleAvatar(
                          radius: 50,
                          backgroundImage:
                              NetworkImage(S3Address + profileImage!)),
                ),
                MyBoxWidget(),
                Text(
                  nickname,
                  style: TextStyle(fontSize: 20.sp, fontFamily: "Sub"),
                ),
                MyBoxWidget(),
                // Text(
                //   body,
                // ),
                // MyBoxWidget(),
              ],
            ),
          ),
          Container(
            child: ClipRRect(
              child: photo == null || photo == ''
                  ? Container()
                  : CachedNetworkImage(
                      maxWidthDiskCache: 250,
                      maxHeightDiskCache: 250,
                      height: 200.h,
                      width: double.infinity,
                      fit: BoxFit.cover,
                      imageUrl: S3Address + photo!,
                      errorWidget: (context, str, err) {
                        return const Icon(
                          Icons.photo,
                          size: 100,
                        );
                      },
                      placeholder: (context, str) {
                        return const Center(
                          child: Text("..."),
                        );
                      },
                    ),
            ),
          ),
          Padding(
            padding: EdgeInsets.fromLTRB(15.w, 5.h, 15.w, 0.h),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Text(
                  name,
                  style: TextStyle(fontSize: 20.sp, fontFamily: "Sub"),
                ),
                MyBoxWidget(),
                // Text(
                //   body,
                // ),
                // MyBoxWidget(),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
