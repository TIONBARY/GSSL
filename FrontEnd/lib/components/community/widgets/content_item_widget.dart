import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';

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
            padding: const EdgeInsets.all(8.0),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Container(
                  height: 50.0,
                  width: 50.0,
                  margin: EdgeInsets.fromLTRB(
                      0, 0, MediaQuery.of(context).size.width / 40, 0),
                  decoration: new BoxDecoration(
                      color: Colors.blue,
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
                  style: TextStyle(fontSize: 17, fontWeight: FontWeight.bold),
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
            decoration: const BoxDecoration(
              borderRadius: BorderRadius.only(
                topLeft: Radius.circular(10),
                topRight: Radius.circular(10),
              ),
            ),
            child: ClipRRect(
              borderRadius: const BorderRadius.only(
                topLeft: Radius.circular(10),
                topRight: Radius.circular(10),
              ),
              child: photo == null || photo == ''
                  ? Container()
                  : CachedNetworkImage(
                      maxWidthDiskCache: 500,
                      maxHeightDiskCache: 500,
                      height: 200,
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
            padding: const EdgeInsets.all(15.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Text(
                  name,
                  style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
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
