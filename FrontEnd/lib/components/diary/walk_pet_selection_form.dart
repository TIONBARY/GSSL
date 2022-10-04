import 'package:GSSL/api/api_pet.dart';
import 'package:GSSL/api/api_walk.dart';
import 'package:GSSL/constants.dart';
import 'package:GSSL/model/response_models/get_all_pet.dart';
import 'package:GSSL/model/response_models/get_walk_detail.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

String S3Address = "https://a204drdoc.s3.ap-northeast-2.amazonaws.com/";
AssetImage basic_image = AssetImage("assets/images/basic_dog.png");
ApiWalk apiWalk = ApiWalk();
// ApiUser apiUser = ApiUser();
ApiPet apiPet = ApiPet();
List<int> selectedPets = [];
bool init = true;

class WalkPetSelectionPage extends StatefulWidget {
  const WalkPetSelectionPage({Key? key, required this.walkId})
      : super(key: key);

  final int walkId;

  @override
  State<WalkPetSelectionPage> createState() => WalkPetSelectionPageState();
}

class WalkPetSelectionPageState extends State<WalkPetSelectionPage> {
  @override
  Widget build(BuildContext context) {
    int walkId = widget.walkId;

    // 비동기 처리
    Future _future() async {
      getAllPet allPet = await ApiPet().getAllPetApi();
      getWalkDetail walk = await apiWalk.getWalk(walkId);
      List<PetsList> petsList = walk.detail!.petsList!;
      if (init) {
        selectedPets = [];
        for (PetsList pl in petsList) {
          selectedPets.add(pl.petId!);
        }
        init = false;
      }
      return allPet.pets;
    }

    void selectArticle(int petId) {
      if (selectedPets.contains(petId)) {
        selectedPets.remove(petId);
        print(petId);
      } else {
        selectedPets.add(petId);
      }
      setState(() {
        selectedPets = selectedPets;
      });
      // 새로고침
      setState(() {});
    }

    return FutureBuilder(
        future: _future(),
        builder: (BuildContext context, AsyncSnapshot snapshot) {
          //해당 부분은 data를 아직 받아 오지 못했을 때 실행되는 부분
          if (snapshot.hasData == false) {
            return Scaffold(
                body: SafeArea(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Expanded(
                      child: Container(
                    padding: EdgeInsets.fromLTRB(10.w, 10.h, 10.w, 10.h),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      image: DecorationImage(
                          fit: BoxFit.contain,
                          image: AssetImage("assets/images/loadingDog.gif")),
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
            // debugPrint(snapshot.data); Container(
            // child: Text(snapshot.data),
            List<Pets> petList = snapshot.data;
            if (petList.isNotEmpty) {
              // Pets a = Pets();
              // a.name;
              // a.animalPic;
              // a.userId;
              // a.id;
              // print(a.name);

              return Scaffold(
                  body: SafeArea(
                      child: Column(
                          mainAxisSize: MainAxisSize.min,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                    Expanded(
                      child: Container(
                        padding: EdgeInsets.fromLTRB(5.w, 5.h, 5.w, 5.h),
                        decoration: BoxDecoration(
                          color: Colors.white,
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
                              return RawMaterialButton(
                                onPressed: () {
                                  selectArticle(petList[index].id!);
                                },
                                child: Hero(
                                  tag: 'pet$index',
                                  child: Stack(children: [
                                    Container(
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
                                          image: (petList[index].animalPic ==
                                                      null ||
                                                  petList[index]
                                                          .animalPic!
                                                          .length ==
                                                      0)
                                              ? Image(image: basic_image).image
                                              : NetworkImage(S3Address +
                                                  petList[index].animalPic!),
                                          fit: BoxFit.cover,
                                        ),
                                      ),
                                    ),
                                    Checkbox(
                                      shape: const RoundedRectangleBorder(
                                          borderRadius: BorderRadius.all(
                                              Radius.circular(5.0))),
                                      // Rounded Checkbox
                                      value: selectedPets
                                          .contains(petList[index].id!),
                                      onChanged: (inputValue) {
                                        // setState(() {});
                                      },
                                    ),
                                    Positioned(
                                      top: 90.w,
                                      left: 70.w,
                                      child: Text(
                                        petList[index].name!,
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
                            itemCount: petList.length,
                          ),
                        ]),
                      ),
                    ),
                    Row(
                      children: <Widget>[
                        Expanded(
                          child: TextButton(
                            onPressed: () {
                              apiWalk.modifyWalk(walkId, selectedPets);
                              Navigator.pop(context);
                            },
                            style: TextButton.styleFrom(
                              padding: EdgeInsets.symmetric(vertical: 0.h),
                              foregroundColor: Colors.lightBlueAccent,
                              backgroundColor: Colors.lightBlueAccent,
                            ),
                            child: Text(
                              '저장',
                              style: TextStyle(
                                color: Colors.white,
                              ),
                            ),
                          ),
                        ),
                        Expanded(
                          child: TextButton(
                            onPressed: () {
                              Navigator.pop(context);
                            },
                            style: TextButton.styleFrom(
                              padding: EdgeInsets.symmetric(horizontal: 1.h),
                              foregroundColor: Colors.grey,
                              backgroundColor: Colors.grey,
                            ),
                            child: Text(
                              '뒤로가기',
                              style: TextStyle(
                                color: Colors.white,
                              ),
                            ),
                          ),
                        ),
                      ],
                    )
                  ])));
            } else {
              return Container(
                  child: Column(
                children: [
                  Padding(
                    padding: EdgeInsets.symmetric(
                        horizontal: 8.0.w, vertical: 80.0.h),
                    child: Text('반려동물 없음',
                        textAlign: TextAlign.center, softWrap: true),
                  ),
                  TextButton(
                    onPressed: () {
                      Navigator.pop(context);
                    },
                    style: TextButton.styleFrom(
                      padding: EdgeInsets.symmetric(horizontal: 0.h),
                      foregroundColor: Colors.grey,
                      backgroundColor: Colors.grey,
                    ),
                    child: Text(
                      '뒤로가기',
                      style: TextStyle(
                        color: Colors.white,
                      ),
                    ),
                  ),
                ],
              ));
            }
          }
        });
  }
}
