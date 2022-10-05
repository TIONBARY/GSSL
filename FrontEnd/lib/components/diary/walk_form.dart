import 'dart:io';

import 'package:GSSL/api/api_pet.dart';
import 'package:GSSL/api/api_user.dart';
import 'package:GSSL/api/api_walk.dart';
import 'package:GSSL/components/diary/walk_detail_form.dart';
import 'package:GSSL/components/util/custom_dialog_function.dart';
import 'package:GSSL/constants.dart';
import 'package:GSSL/model/response_models/get_walk_detail.dart';
import 'package:GSSL/model/response_models/get_walk_list.dart';
import 'package:GSSL/pages/walk_map.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

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
  List<int> selectedArticles = [];
  List<int> selectedWalkIds = [];
  bool selectionMode = false;

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
                        padding: EdgeInsets.fromLTRB(10.w, 10.h, 10.w, 10.h),
                        decoration: BoxDecoration(
                          color: Colors.white,
                          image: DecorationImage(
                              fit: BoxFit.contain,
                              image:
                                  AssetImage("assets/images/loadingDog.gif")),
                        ),
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
                          padding: EdgeInsets.fromLTRB(15.w, 15.h, 15.w, 15.h),
                          decoration: BoxDecoration(
                            color: nWColor,
                          ),
                          child: Stack(children: [
                            GridView.builder(
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
                                        formatDateTime(infoList[index]
                                            .endTime
                                            .toString()) +
                                        ".png";
                                  }
                                }
                                return RawMaterialButton(
                                  onLongPress: () {
                                    if (selectionMode) {
                                      enterIntoArticle(
                                          infoList, index, _imgPath);
                                    } else {
                                      selectArticle(infoList, index);
                                    }
                                  },
                                  onPressed: () {
                                    if (!selectionMode) {
                                      enterIntoArticle(
                                          infoList, index, _imgPath);
                                    } else {
                                      selectArticle(infoList, index);
                                    }
                                  },
                                  child: Hero(
                                    tag: 'walkThumb$index',
                                    child: Stack(children: [
                                      Container(
                                        decoration: BoxDecoration(
                                          borderRadius:
                                              BorderRadius.circular(10),
                                          boxShadow: [
                                            BoxShadow(
                                              color:
                                                  Colors.grey.withOpacity(0.7),
                                              blurRadius: 7,
                                              offset: Offset(3, 3),
                                            ),
                                          ],
                                          image: File(_imgPath).existsSync()
                                              ? DecorationImage(
                                                  image:
                                                      FileImage(File(_imgPath)),
                                                  fit: BoxFit.cover,
                                                )
                                              : DecorationImage(
                                                  image: AssetImage(
                                                      "assets/images/basic_dog.png"),
                                                  fit: BoxFit.contain,
                                                ),
                                        ),
                                      ),
                                      (selectionMode)
                                          ? Checkbox(
                                              shape:
                                                  const RoundedRectangleBorder(
                                                      borderRadius:
                                                          BorderRadius.all(
                                                              Radius.circular(
                                                                  5.0))),
                                              // Rounded Checkbox
                                              value: selectedArticles
                                                  .contains(index),
                                              onChanged: (inputValue) {
                                                setState(() {
                                                  // selectedArticles = [];
                                                });
                                              },
                                            )
                                          : Container(),
                                      Positioned(
                                        top: 100.h,
                                        left: 75.w,
                                        child: Text(
                                          toMonth(infoList[index].endTime!),
                                          textAlign: TextAlign.right,
                                          style: TextStyle(
                                            fontSize: 10.sp,
                                            color: btnColor,
                                            fontFamily: 'Daehan',
                                          ),
                                        ),
                                      ),
                                    ]),
                                  ),
                                );
                              },
                              itemCount: infoList.length,
                            ),
                            Positioned(
                              top: 445.h,
                              left: 280.w,
                              child: (selectedArticles.isNotEmpty)
                                  ? FloatingActionButton(
                                      child: Icon(Icons.delete),
                                      elevation: 5,
                                      hoverElevation: 10,
                                      tooltip: "선택된 항목 삭제",
                                      backgroundColor: Colors.red,
                                      onPressed: () {
                                        showDialog(
                                            context: context,
                                            builder: (BuildContext context) {
                                              return CustomDialogWithFunction(
                                                  "정말로 " +
                                                      selectedArticles.length
                                                          .toString() +
                                                      "개의 산책기록을 삭제하시겠습니까?", () {
                                                // 삭제 요청 전송;
                                                selectedArticles.forEach((e) =>
                                                    selectedWalkIds.add(
                                                        infoList[e].walkId!));
                                                apiWalk.deleteAllWalk(
                                                    selectedWalkIds);
                                                // 선택 리스트 비우기
                                                setState(() {
                                                  selectedArticles = [];
                                                  selectedWalkIds = [];
                                                  selectionMode = false;
                                                });
                                                // 뒤로가기
                                                Navigator.pop(context);
                                              });
                                            }).then((value) {
                                          // 새로고침
                                          setState(() {});
                                        });
                                      })
                                  : Container(),
                            ),
                          ]),
                        ),
                      ),
                    ])));
              }
            });
  }

  @override
  void initState() {
    super.initState();
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
          // print(info.walkId.toString());
          result.add(new Detail(
              walkId: info.walkId,
              startTime: info.startTime,
              endTime: info.endTime,
              petsList: info.petsList,
              distance: info.distance));
        });
      }
      return result;
    }
    return null;
  }

  void getWalkInfo() async {
    getWalkDetail response = await apiWalk.getWalk(90);
    // debugPrint("단일");
    Detail? info = response.detail;
    if (info != null) {
      // debugPrint(info.endTime.toString());
    }
  }

  String convertMeters(int length) {
    if (length > 1000) {
      return (length / 1000).toString() + " km";
    } else {
      return length.toString() + " m";
    }
  }

  String convertWalkTime(String startTime, String endTime) {
    DateTime st = DateTime.parse(startTime);
    DateTime et = DateTime.parse(endTime);
    int stYear = st.year;
    int stMonth = st.month;
    int stDay = st.day;
    int stHour = st.hour;
    int stMin = st.minute;
    int stSec = st.second;
    int etYear = et.year;
    int etMonth = et.month;
    int etDay = et.day;
    int etHour = et.hour;
    int etMin = et.minute;
    int etSec = et.second;
    String stStr = '$stYear년 $stMonth월 $stDay일 $stHour시 $stMin분 $stSec초';
    String etStr = '$etYear년 $etMonth월 $etDay일 $etHour시 $etMin분 $etSec초';
    return stStr + " ~ " + etStr;
  }

  String toMonth(String endTime) {
    DateTime et = DateTime.parse(endTime);
    int etMonth = et.month;
    int etDay = et.day;
    String etStr = '$etMonth월 $etDay일';
    return etStr;
  }

  String getPetNameString(List<PetsList> list) {
    String nameStr = "";
    list.forEach((PetsList pet) {
      nameStr += pet.name! + " ";
    });
    return nameStr;
  }

  void selectArticle(List infoList, int index) {
    if (selectedArticles.contains(index)) {
      selectedArticles.remove(index);
    } else {
      selectedArticles.add(index);
    }
    setState(() {
      selectedArticles = selectedArticles;
      if (selectedArticles.isNotEmpty) {
        selectionMode = true;
      } else {
        selectionMode = false;
      }
    });
    // 새로고침
    setState(() {});
  }

  void enterIntoArticle(List<Detail> infoList, int index, String _imgPath) {
    Navigator.push(
      context,
      MaterialPageRoute(
        settings:
            RouteSettings(name: "/walk" + infoList[index].walkId!.toString()),
        builder: (context) => WalkDetailsPage(
          walkId: infoList[index].walkId!,
          distance: convertMeters(infoList[index].distance!),
          imagePath: _imgPath,
          title: convertWalkTime(
              infoList[index].startTime!, infoList[index].endTime!),
          petNames: getPetNameString(infoList[index].petsList!),
        ),
      ),
    );
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
