import 'package:GSSL/api/api_pet.dart';
import 'package:GSSL/api/api_user.dart';
import 'package:GSSL/components/bottomNavBar.dart';
import 'package:GSSL/constants.dart';
import 'package:GSSL/model/response_models/general_response.dart';
import 'package:GSSL/model/response_models/get_pet_detail.dart';
import 'package:GSSL/model/response_models/get_pet_kind.dart';
import 'package:GSSL/model/response_models/user_info.dart';
import 'package:GSSL/pages/login_page.dart';
import 'package:GSSL/pages/modify_pet_page.dart';
import 'package:flutter/material.dart';

import '../util/custom_dialog.dart';

class PetDetail extends StatefulWidget {
  const PetDetail({
    Key? key,
  }) : super(key: key);

  @override
  State<PetDetail> createState() => _PetDetailState();
}

class _PetDetailState extends State<PetDetail> {
  final RegisterPetFormKey = GlobalKey<FormState>();
  String S3Address = "https://a204drdoc.s3.ap-northeast-2.amazonaws.com/";
  AssetImage basic_image = AssetImage("assets/images/basic_dog.png");
  Pet? pet;
  User? user;
  String? kindName;
  TextEditingController dateinput = TextEditingController();
  ApiUser apiUser = ApiUser();
  ApiPet apiPet = ApiPet();

  Future<void> getUser() async {
    userInfo? userInfoResponse = await apiUser.getUserInfo();
    if (userInfoResponse.statusCode == 200) {
      setState(() {
        user = userInfoResponse.user;
      });
      if (user?.petId != 0) getMainPet();
    } else if (userInfoResponse.statusCode == 401) {
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
                userInfoResponse.message == null
                    ? "알 수 없는 오류가 발생했습니다."
                    : userInfoResponse.message!,
                (context) => BottomNavBar());
          });
    }
  }

  Future<void> getMainPet() async {
    getPetDetail? getMainPetResponse =
        await apiPet.getPetDetailApi(user?.petId);
    if (getMainPetResponse.statusCode == 200) {
      setState(() {
        pet = getMainPetResponse.pet;
      });
      GetPetKind kind = await apiPet.getPetKindOne(pet!.kindId!);
      setState(() {
        kindName = kind?.kind?.name;
      });
    } else if (getMainPetResponse.statusCode == 401) {
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
                getMainPetResponse.message == null
                    ? "알 수 없는 오류가 발생했습니다."
                    : getMainPetResponse.message!,
                (context) => BottomNavBar());
          });
    }
  }

  Future<void> deletePet() async {
    generalResponse deletePetResponse = await apiPet.deletePetAPI(user?.petId);
    if (deletePetResponse.statusCode == 200) {
      await deleteUserPet();
    } else if (deletePetResponse.statusCode == 401) {
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
                deletePetResponse.message == null
                    ? "알 수 없는 오류가 발생했습니다."
                    : deletePetResponse.message!,
                (context) => BottomNavBar());
          });
    }
  }

  Future<void> deleteUserPet() async {
    generalResponse deleteUserPetResponse = await apiUser.modifyUserPetAPI(0);
    if (deleteUserPetResponse.statusCode == 200) {
      showDialog(
          context: context,
          builder: (BuildContext context) {
            return CustomDialog("펫 삭제가 완료되었습니다.", (context) => BottomNavBar());
          });
    } else if (deleteUserPetResponse.statusCode == 401) {
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
                deleteUserPetResponse.message == null
                    ? "알 수 없는 오류가 발생했습니다."
                    : deleteUserPetResponse.message!,
                (context) => BottomNavBar());
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
    return Container(
        margin: EdgeInsets.fromLTRB(
            0, MediaQuery.of(context).size.width / 10, 0, 0),
        child: Column(
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Container(
// color: const Color(0xffd0cece),
                  width: MediaQuery.of(context).size.width / 5,
                  height: MediaQuery.of(context).size.width / 5,
                  child: Center(
                    child: pet?.animalPic == null || pet?.animalPic!.length == 0
                        ? CircleAvatar(
                            backgroundImage: basic_image, radius: 200.0)
                        : CircleAvatar(
                            backgroundImage:
                                NetworkImage(S3Address + pet!.animalPic!),
                            radius: 200.0),
                  ),
                  decoration: BoxDecoration(
                      color: Colors.black, shape: BoxShape.circle),
                ),
              ],
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Container(
                  padding: EdgeInsets.fromLTRB(
                      0,
                      MediaQuery.of(context).size.width / 20,
                      0,
                      MediaQuery.of(context).size.width / 40),
                  child: RichText(
                      text: pet?.name == null
                          ? TextSpan(children: [
                              TextSpan(
                                  style: TextStyle(
                                    color: Colors.black,
                                    fontSize: 18,
                                  ),
                                  text: "등록된 반려견이 없습니다.")
                            ])
                          : TextSpan(children: [
                              TextSpan(
                                  style: TextStyle(
                                    color: Colors.black,
                                    fontSize: 24,
                                  ),
                                  text: user!.nickname! + "의 " + pet!.name!),
                              WidgetSpan(
                                  child: pet!.gender! == 'M'
                                      ? Icon(Icons.male, color: Colors.blue)
                                      : Icon(Icons.female, color: Colors.red)),
                              WidgetSpan(
                                  child: pet!.neutralize!
                                      ? Icon(Icons.cut, color: Colors.brown)
                                      : Text(""))
                            ])),
                ),
                pet?.death != null && pet!.death!
                    ? Container(
                        padding: EdgeInsets.fromLTRB(
                            0,
                            MediaQuery.of(context).size.width / 20,
                            0,
                            MediaQuery.of(context).size.width / 40),
                        child: Image.asset(
                          "assets/images/grave.png",
                          height: 20,
                        ))
                    : Container(),
              ],
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Container(
                  padding: EdgeInsets.fromLTRB(
                      0,
                      MediaQuery.of(context).size.width / 40,
                      0,
                      MediaQuery.of(context).size.width / 40),
                  child: RichText(
                      text:
                          pet == null || pet?.kindId == null || kindName == null
                              ? TextSpan(text: "")
                              : TextSpan(children: [
                                  WidgetSpan(child: Icon(Icons.pets)),
                                  TextSpan(
                                      style: TextStyle(
                                        color: Colors.black,
                                        fontSize: 18,
                                      ),
                                      text: kindName!)
                                ])),
                ),
              ],
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                RichText(
                    text: TextSpan(children: [
                  WidgetSpan(
                    child: Icon(Icons.calendar_today),
                  ),
                  TextSpan(
                    style: TextStyle(
                      color: Colors.black,
                      fontSize: 18,
                    ),
                    text: pet == null || pet?.birth == null
                        ? " "
                        : " 생일 : " + pet!.birth!.split("T")[0],
                  ),
                ])),
              ],
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                RichText(
                    text: TextSpan(children: [
                  WidgetSpan(
                    child: Icon(Icons.monitor_weight),
                  ),
                  TextSpan(
                    style: TextStyle(
                      color: Colors.black,
                      fontSize: 18,
                    ),
                    text: pet == null ||
                            pet?.weight == null ||
                            pet!.weight! == 0.0
                        ? " 몸무게 : 기록하지 않음"
                        : " 몸무게 : " + pet!.weight!.toString() + " kg",
                  ),
                ])),
              ],
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                RichText(
                    text: TextSpan(children: [
                  WidgetSpan(
                    child: Icon(Icons.local_hospital),
                  ),
                  TextSpan(
                    style: TextStyle(
                      color: Colors.black,
                      fontSize: 18,
                    ),
                    text: pet == null ||
                            pet?.diseases == null ||
                            pet?.diseases!.length == 0
                        ? " 질병 : 없음"
                        : " 질병 : " + pet!.diseases!,
                  ),
                ])),
              ],
            ),
            Row(mainAxisAlignment: MainAxisAlignment.center, children: [
              Container(
                height: MediaQuery.of(context).size.height / 5,
                width: MediaQuery.of(context).size.width / 1.3,
                alignment: Alignment.center,
                child: TextFormField(
                  controller: TextEditingController()
                    ..text = pet?.description == null ||
                            pet?.description!.length == 0
                        ? "작성한 반려동물 소개가 없습니다."
                        : pet!.description!,
                  keyboardType: TextInputType.multiline,
                  maxLines: 4,
                  textInputAction: TextInputAction.done,
                  cursorColor: btnColor,
                  readOnly: true,
                  decoration: InputDecoration(
                    hintStyle: TextStyle(color: sColor),
                    contentPadding: EdgeInsets.fromLTRB(20, 25, 25, 15),
                    enabledBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.all(Radius.circular(10)),
                        borderSide: BorderSide(color: Colors.white)),
                    filled: true,
                    fillColor: Colors.white,
                    focusedBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.all(Radius.circular(10)),
                        borderSide: BorderSide(color: btnColor)),
                  ),
                ),
              )
            ]),
            Row(mainAxisAlignment: MainAxisAlignment.center, children: [
              Padding(
                padding: const EdgeInsets.fromLTRB(10, 0, 10, 0),
                child: Container(
                  height: 48,
                  child: ElevatedButton(
                    onPressed: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => ModifyPetScreen()),
                      );
                    },
                    style: ElevatedButton.styleFrom(
                        backgroundColor: btnColor,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(25.0),
                        )),
                    child: Text(
                      "수정하기".toUpperCase(),
                    ),
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.fromLTRB(10, 0, 10, 0),
                child: Container(
                  height: 48,
                  child: ElevatedButton(
                    onPressed: () {
                      showDialog(
                          context: context,
                          builder: (BuildContext context) {
                            return Dialog(
                              shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(
                                      20.0)), //this right here
                              child: Container(
                                height: 150,
                                child: Padding(
                                  padding: const EdgeInsets.fromLTRB(
                                      12.0, 12.0, 12.0, 3.0),
                                  child: Column(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    crossAxisAlignment:
                                        CrossAxisAlignment.center,
                                    children: [
                                      Title(
                                        color: Colors.black,
                                        child: Text("정말 삭제하시겠습니까?",
                                            style: TextStyle(fontSize: 20)),
                                      ),
                                      Container(
                                          width: 150.0,
                                          margin:
                                              EdgeInsets.fromLTRB(0, 15, 0, 0),
                                          child: Row(
                                              mainAxisAlignment:
                                                  MainAxisAlignment.spaceAround,
                                              children: [
                                                ElevatedButton(
                                                  onPressed: () {
                                                    deletePet();
                                                  },
                                                  child: Text(
                                                    "확인",
                                                    style: TextStyle(
                                                        color: Colors.white),
                                                  ),
                                                ),
                                                ElevatedButton(
                                                  onPressed: () {
                                                    Navigator.of(context).pop();
                                                  },
                                                  child: Text(
                                                    "취소",
                                                    style: TextStyle(
                                                        color: Colors.white),
                                                  ),
                                                ),
                                              ]))
                                    ],
                                  ),
                                ),
                              ),
                            );
                          });
                    },
                    style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.red,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(25.0),
                        )),
                    child: Text(
                      "삭제하기".toUpperCase(),
                    ),
                  ),
                ),
              ),
            ])
          ],
        ));
  }
}
