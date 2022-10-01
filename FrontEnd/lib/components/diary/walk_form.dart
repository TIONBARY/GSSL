import 'dart:io';

import 'package:GSSL/api/api_pet.dart';
import 'package:GSSL/api/api_user.dart';
import 'package:GSSL/api/api_walk.dart';
import 'package:GSSL/components/diary/walk_detail_form.dart';
import 'package:GSSL/model/response_models/get_walk_detail.dart';
import 'package:GSSL/model/response_models/get_walk_list.dart';
import 'package:GSSL/pages/walk_map.dart';
import 'package:flutter/material.dart';

ApiWalk apiWalk = ApiWalk();
ApiUser apiUser = ApiUser();
ApiPet apiPet = ApiPet();
String prefix = "";

class WalkPage extends StatefulWidget {
  const WalkPage({Key? key}) : super(key: key);

  @override
  State<WalkPage> createState() => _WalkPageState();
}

class _WalkPageState extends State<WalkPage> {
  @override
  Widget build(BuildContext context) {
    return // 임시 버튼
        FutureBuilder(
            future: getAllWalkInfo(),
            builder: (BuildContext context, AsyncSnapshot snapshot) {
              //해당 부분은 data를 아직 받아 오지 못했을 때 실행되는 부분
              if (snapshot.hasData == false) {
                return Scaffold(
                    body: SafeArea(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      Expanded(
                          child: Container(
                        padding: EdgeInsets.fromLTRB(15, 10, 15, 10),
                        decoration: BoxDecoration(
                          color: Colors.white,
                        ),
                        child: CircularProgressIndicator(),
                      ))
                    ],
                  ),
                )); // CircularProgressIndicator : 로딩 에니메이션
              }

              //error가 발생하게 될 경우 반환하게 되는 부분
              else if (snapshot.hasError) {
                return Text(
                  'Error: ${snapshot.error}', // 에러명을 텍스트에 뿌려줌
                  style: TextStyle(fontSize: 15),
                );
              }

              // 데이터를 정상적으로 받아오게 되면 다음 부분을 실행하게 되는 부분
              else {
                // print(snapshot.data);
                List<Detail> infoList = snapshot.data;
                // List<Widget> articleList = [];
                // infoList.forEach((info) {
                //   print(info.walkId.toString());
                //   articleList.add(new WalkDetailsPage(
                //     index: info.walkId!,
                //     distance: info.distance!,
                //     imagePath: info.endTime.toString(),
                //     startTime: info.startTime!,
                //     endTime: info.endTime!,
                //     petsList: info.petsList!,
                //   ));
                // });

                return Scaffold(
                    body: SafeArea(
                        child: Column(
                            crossAxisAlignment: CrossAxisAlignment.stretch,
                            children: [
                      Expanded(
                        child: Container(
                          padding: EdgeInsets.fromLTRB(15, 10, 15, 10),
                          decoration: BoxDecoration(
                            color: Colors.white,
                          ),
                          child: GridView.builder(
                            gridDelegate:
                                SliverGridDelegateWithFixedCrossAxisCount(
                              crossAxisCount: 3,
                              crossAxisSpacing: 10,
                              mainAxisSpacing: 10,
                            ),
                            itemBuilder: (context, index) {
                              String _imgPath = "";
                              if (prefix != "null") {
                                if (File(prefix +
                                        formatDateTime(infoList[index]
                                            .endTime
                                            .toString()) +
                                        ".png")
                                    .existsSync()) {
                                  _imgPath = prefix +
                                      formatDateTime(
                                          infoList[index].endTime.toString()) +
                                      ".png";
                                }
                              }
                              return RawMaterialButton(
                                onPressed: () {
                                  Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                      builder: (context) => WalkDetailsPage(
                                        index: infoList[index].walkId!,
                                        distance: infoList[index].distance!,
                                        imagePath: _imgPath,
                                        startTime: infoList[index].startTime!,
                                        endTime: infoList[index].endTime!,
                                        petsList: infoList[index].petsList!,
                                      ),
                                    ),
                                  );
                                },
                                child: Hero(
                                  tag: 'logo$index',
                                  child: Container(
                                    decoration: BoxDecoration(
                                      borderRadius: BorderRadius.circular(10),
                                      boxShadow: [
                                        BoxShadow(
                                          color: Colors.grey.withOpacity(0.7),
                                          blurRadius: 7,
                                          offset: Offset(3, 3),
                                        ),
                                      ],
                                      image: DecorationImage(
                                        image: FileImage(File(_imgPath)),
                                        fit: BoxFit.cover,
                                      ),
                                    ),
                                  ),
                                ),
                              );
                            },
                            itemCount: infoList.length,
                          ),
                        ),
                      ),
                    ])));
              }
            });
  }

  Future<List<Detail>?> getAllWalkInfo() async {
    getWalkList response = await apiWalk.getAllWalk();
    String topFolder = await getDirectory();
    prefix = topFolder + "/";
    // debugPrint("목록");
    WalkList? walkList = response.walkList;
    if (walkList != null) {
      List<Detail>? content = walkList.content;
      List<Detail> result = <Detail>[];
      if (content != null) {
        content.forEach((info) {
          print(info.walkId.toString());
          result.add(new Detail(
              walkId: info.walkId,
              startTime: info.startTime,
              endTime: info.endTime,
              petsList: info.petsList,
              distance: info.walkId));
        });
      }
      return result;
    }
    return null;
  }

  void getWalkInfo() async {
    getWalkDetail response = await apiWalk.getWalk(90);
    debugPrint("단일");
    Detail? info = response.detail;
    if (info != null) {
      debugPrint(info.endTime.toString());
    }
  }
}

class ImageDetails {
  final String imagePath;
  final String disease;
  final String date;
  final String title;
  final String details;

  ImageDetails({
    required this.imagePath,
    required this.disease,
    required this.date,
    required this.title,
    required this.details,
  });
}

// children: [
//   CircleAvatar(
//     child:
//         IconButton(onPressed: () {}, icon: Icon(Icons.list)),
//   ),
//   CircleAvatar(
//     child: IconButton(
//         onPressed: () async {
//           getWalkInfo();
//         },
//         icon: Icon(Icons.details)),
//   ),
//   CircleAvatar(
//     child: IconButton(
//         onPressed: () async {
//           getAllPet res = await apiPet.getAllPetApi();
//           List<Pets>? pets = res.pets;
//           if (pets != null) {
//             await apiWalk.modifyWalk(90, [1, 2, 3]);
//           }
//         },
//         icon: Icon(Icons.mode_edit)),
//   ),
//   CircleAvatar(
//     child: IconButton(
//         onPressed: () async {
//           await apiWalk.deleteWalk(77);
//         },
//         icon: Icon(Icons.delete)),
//   ),
//   CircleAvatar(
//     child: IconButton(
//         onPressed: () async {
//           await apiWalk.deleteAllWalk([78, 79]);
//         },
//         icon: Icon(Icons.delete_sweep_rounded)),
//   ),
// ],
