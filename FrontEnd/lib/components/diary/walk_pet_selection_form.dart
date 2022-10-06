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
  bool loading = true;

  List<Pets> petList = [];

  // 비동기 처리
  Future<void> _future() async {
    getAllPet allPet = await ApiPet().getAllPetApi();
    getWalkDetail walk = await apiWalk.getWalk(widget.walkId);
    List<PetsList> petsList = walk.detail!.petsList!;
    print("future");
    selectedPets = [];

    for (PetsList pl in petsList) {
      selectedPets.add(pl.petId!);
    }
    setState(() {
      loading = false;
      init = false;
      petList = allPet!.pets!;
    });
  }

  void selectArticle(int petId) {
    if (selectedPets.contains(petId)) {
      setState(() {
        selectedPets.remove(petId);
      });
    } else {
      setState(() {
        selectedPets.add(petId);
      });
    }
    setState(() {
      selectedPets = selectedPets;
    });
    // 새로고침
    setState(() {});
  }

  @override
  void initState() {
    super.initState();
    _future();
  }

  @override
  Widget build(BuildContext context) {
    // debugPrint(snapshot.data); Container(
    // child: Text(snapshot.data),
    BuildContext outerContext = context;
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
                    children: <Widget>[
              Expanded(
                child: Container(
                  padding: EdgeInsets.fromLTRB(15.w, 15.h, 15.w, 15.h),
                  decoration: BoxDecoration(
                    color: nWColor,
                  ),
                  child: Stack(children: [
                    GridView.builder(
                      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
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
                                    image: (petList[index].animalPic == null ||
                                            petList[index].animalPic!.length ==
                                                0)
                                        ? Image(image: basic_image).image
                                        : NetworkImage(S3Address +
                                            petList[index].animalPic!),
                                    fit: BoxFit.cover,
                                  ),
                                ),
                              ),
                              Theme(
                                child: Checkbox(
                                  activeColor: btnColor,
                                  shape: const RoundedRectangleBorder(
                                      borderRadius: BorderRadius.all(
                                          Radius.circular(5.0))),
                                  // Rounded Checkbox
                                  value:
                                      selectedPets.contains(petList[index].id!),
                                  onChanged: (inputValue) {
                                    setState(() {});
                                  },
                                ),
                                data: Theme.of(context).copyWith(
                                  unselectedWidgetColor: nWColor,
                                ),
                              ),
                              Positioned(
                                right: 0.w,
                                bottom: 0.h,
                                child: Text(
                                  petList[index].name!,
                                  textAlign: TextAlign.right,
                                  style: TextStyle(
                                    fontSize: 15.sp,
                                    color: btnColor,
                                    fontFamily: 'Sub',
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
                      onPressed: () async {
                        await apiWalk.modifyWalk(widget.walkId, selectedPets);
                        Navigator.pop(context);
                      },
                      style: TextButton.styleFrom(
                        padding: EdgeInsets.symmetric(vertical: 10.h),
                        foregroundColor: btnColor,
                        backgroundColor: btnColor,
                      ),
                      child: Text(
                        '저장',
                        style: TextStyle(
                            color: nWColor, fontFamily: "Sub", fontSize: 15.sp),
                      ),
                    ),
                  ),
                  Expanded(
                    child: TextButton(
                      onPressed: () {
                        Navigator.pop(context);
                      },
                      style: TextButton.styleFrom(
                        padding: EdgeInsets.symmetric(vertical: 10.h),
                        foregroundColor: sColor,
                        backgroundColor: sColor,
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
              )
            ])));
      } else {
        return Scaffold(
            body: Container(
                height: MediaQuery.of(context).size.height,
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Padding(
                      padding: EdgeInsets.symmetric(
                          horizontal: 8.0.w, vertical: 200.h),
                      child: Text(
                        '등록한 반려견이 없습니다.',
                        textAlign: TextAlign.center,
                        softWrap: true,
                        style: TextStyle(fontFamily: "Sub", fontSize: 20),
                      ),
                    ),
                    Row(
                      children: [
                        Expanded(
                          child: TextButton(
                            onPressed: () {
                              Navigator.pop(context);
                            },
                            style: TextButton.styleFrom(
                              padding: EdgeInsets.symmetric(vertical: 10.h),
                              foregroundColor: sColor,
                              backgroundColor: sColor,
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
                    )
                  ],
                )));
      }
    }
  }
}
