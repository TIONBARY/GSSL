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
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../util/custom_dialog.dart';

class PetDetail extends StatefulWidget {
  const PetDetail({
    Key? key,
  }) : super(key: key);

  @override
  State<PetDetail> createState() => _PetDetailState();
}

final RegisterPetFormKey = GlobalKey<FormState>();
String S3Address = "https://a204drdoc.s3.ap-northeast-2.amazonaws.com/";
AssetImage basic_image = AssetImage("assets/images/basic_dog.png");
Pet? pet;
User? user;
String? kindName;
TextEditingController dateinput = TextEditingController();
ApiUser apiUser = ApiUser();
ApiPet apiPet = ApiPet();

class _PetDetailState extends State<PetDetail> {
  bool _loading = true;

  Future<void> getUser() async {
    userInfo? userInfoResponse = await apiUser.getUserInfo();
    if (userInfoResponse.statusCode == 200) {
      setState(() {
        user = userInfoResponse.user;
      });
      if (user?.petId != 0)
        getMainPet();
      else {
        showDialog(
            context: context,
            builder: (BuildContext context) {
              return CustomDialog("반려동물을 등록해주세요.", (context) => BottomNavBar());
            });
      }
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
        _loading = false;
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
    if (_loading) {
      return Container(
          margin: EdgeInsets.fromLTRB(0, 130.h, 0, 0),
          child: Column(children: [
            Padding(
                padding: const EdgeInsets.symmetric(vertical: defaultPadding),
                child: Center(
                    child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Image.asset("assets/images/loadingDog.gif"),
                  ],
                ))),
          ]));
    } else {
      return Container(
        margin: EdgeInsets.fromLTRB(0, 25.h, 0, 0),
        child: Column(
          children: [
            petPic(),
            petName(),
            infoTitle(title: "기본 정보"),
            basicInfoBox(),
            infoTitle(title: "건강 정보"),
            healthInfoBox(),
            petIntro(),
            Row(mainAxisAlignment: MainAxisAlignment.spaceAround, children: [
              Padding(
                padding: EdgeInsets.fromLTRB(0, 0, 0, 0),
                child: Container(
                  height: 35.h,
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
                      "수정".toUpperCase(),
                      style: TextStyle(
                        fontFamily: "Sub",
                      ),
                    ),
                  ),
                ),
              ),
              Padding(
                padding: EdgeInsets.fromLTRB(0, 0, 0, 0),
                child: Container(
                  height: 35.h,
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
                                height: 110.h,
                                child: Padding(
                                  padding: EdgeInsets.fromLTRB(
                                      12.0.w, 12.0.h, 12.0.w, 3.0.h),
                                  child: Column(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    crossAxisAlignment:
                                        CrossAxisAlignment.center,
                                    children: [
                                      Title(
                                        color: Colors.black,
                                        child: Text("정말 삭제하시겠습니까?",
                                            style: TextStyle(fontSize: 17.sp)),
                                      ),
                                      Container(
                                          width: 150.0.w,
                                          margin: EdgeInsets.fromLTRB(
                                              0, 15.h, 0, 0),
                                          child: Row(
                                              mainAxisAlignment:
                                                  MainAxisAlignment.spaceAround,
                                              children: [
                                                ElevatedButton(
                                                  onPressed: () {
                                                    deletePet();
                                                  },
                                                  style:
                                                      ElevatedButton.styleFrom(
                                                          backgroundColor:
                                                              Colors.red),
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
                                                  style:
                                                      ElevatedButton.styleFrom(
                                                          backgroundColor:
                                                              Colors.white),
                                                  child: Text(
                                                    "취소",
                                                    style: TextStyle(
                                                        color: Colors.black),
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
                      "삭제".toUpperCase(),
                      style: TextStyle(
                        fontFamily: "Sub",
                      ),
                    ),
                  ),
                ),
              ),
            ]),
            const SizedBox(height: defaultPadding),
          ],
        ),
      );
    }
  }
}

class petPic extends StatefulWidget {
  const petPic({Key? key}) : super(key: key);

  @override
  State<petPic> createState() => _petPicState();
}

class _petPicState extends State<petPic> {
  @override
  Widget build(BuildContext context) {
    return Container(
      width: 100.w,
      height: 100.h,
      child: Center(
        child: pet?.animalPic == null || pet?.animalPic!.length == 0
            ? CircleAvatar(backgroundImage: basic_image, radius: 200.0)
            : CircleAvatar(
                backgroundImage: NetworkImage(S3Address + pet!.animalPic!),
                radius: 200.0),
      ),
      decoration: BoxDecoration(color: Colors.black, shape: BoxShape.circle),
    );
  }
}

class petName extends StatefulWidget {
  const petName({Key? key}) : super(key: key);

  @override
  State<petName> createState() => _petNameState();
}

class _petNameState extends State<petName> {
  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.symmetric(vertical: defaultPadding / 2),
      child: RichText(
          text: pet?.name == null
              ? TextSpan(children: [
                  TextSpan(
                      style: TextStyle(color: btnColor, fontFamily: "Daehan"),
                      text: "등록된 반려견이 없습니다.")
                ])
              : TextSpan(children: [
                  TextSpan(
                      style: TextStyle(
                          color: btnColor, fontFamily: "Sub", fontSize: 25.sp),
                      text: pet!.name!),
                ])),
    );
  }
}

class petType extends StatefulWidget {
  const petType({Key? key}) : super(key: key);

  @override
  State<petType> createState() => _petTypeState();
}

class _petTypeState extends State<petType> {
  @override
  Widget build(BuildContext context) {
    return Container(
      child: RichText(
          text: pet == null || pet?.kindId == null || kindName == null
              ? TextSpan(text: "입력하지 않았습니다.")
              : TextSpan(children: [
                  TextSpan(
                      style: TextStyle(
                          color: btnColor, fontSize: 15.sp, fontFamily: "Sub"),
                      text: kindName!)
                ])),
    );
  }
}

class petGender extends StatelessWidget {
  const petGender({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
        child: pet!.gender! == 'M'
            ? Text(
                "남아",
                style: TextStyle(fontFamily: "Sub", color: btnColor),
              )
            : Text(
                "여아",
                style: TextStyle(fontFamily: "Sub", color: btnColor),
              ));
  }
}

class petBirth extends StatefulWidget {
  const petBirth({Key? key}) : super(key: key);

  @override
  State<petBirth> createState() => _petBirthState();
}

class _petBirthState extends State<petBirth> {
  @override
  Widget build(BuildContext context) {
    return RichText(
        text: TextSpan(children: [
      TextSpan(
        style: TextStyle(color: btnColor, fontSize: 15.sp, fontFamily: "Sub"),
        text:
            pet == null || pet?.birth == null ? " " : pet!.birth!.split("T")[0],
      ),
    ]));
  }
}

class petWeight extends StatefulWidget {
  const petWeight({Key? key}) : super(key: key);

  @override
  State<petWeight> createState() => _petWeightState();
}

class _petWeightState extends State<petWeight> {
  @override
  Widget build(BuildContext context) {
    return RichText(
        text: TextSpan(children: [
      TextSpan(
        style: TextStyle(color: btnColor, fontSize: 15.sp, fontFamily: "Sub"),
        text: pet == null || pet?.weight == null || pet!.weight! == 0.0
            ? "기록하지 않음"
            : pet!.weight!.toString() + " kg",
      ),
    ]));
  }
}

class petHealth extends StatefulWidget {
  const petHealth({Key? key}) : super(key: key);

  @override
  State<petHealth> createState() => _petHealthState();
}

class _petHealthState extends State<petHealth> {
  @override
  Widget build(BuildContext context) {
    return RichText(
        text: TextSpan(children: [
      TextSpan(
        style: TextStyle(color: btnColor, fontSize: 15.sp, fontFamily: "Sub"),
        text: pet == null || pet?.diseases == null || pet?.diseases!.length == 0
            ? "없음"
            : pet!.diseases!,
      ),
    ]));
  }
}

class petIntro extends StatefulWidget {
  const petIntro({Key? key}) : super(key: key);

  @override
  State<petIntro> createState() => _petIntroState();
}

class _petIntroState extends State<petIntro> {
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: defaultPadding),
      child: TextFormField(
        style: TextStyle(fontFamily: "Sub", color: btnColor),
        controller: TextEditingController()
          ..text = pet?.description == null || pet?.description!.length == 0
              ? "작성한 반려동물 소개가 없습니다."
              : user!.introduce!,
        keyboardType: TextInputType.multiline,
        maxLines: 4,
        textInputAction: TextInputAction.done,
        cursorColor: btnColor,
        readOnly: true,
        decoration: InputDecoration(
          hintStyle: TextStyle(color: sColor, fontFamily: "Daehan"),
          contentPadding: EdgeInsets.fromLTRB(20.w, 20.h, 20.w, 20.h),
          enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.all(Radius.circular(10)),
              borderSide: BorderSide(color: sColor)),
          filled: true,
          fillColor: Colors.white,
          focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.all(Radius.circular(10)),
              borderSide: BorderSide(color: btnColor)),
        ),
      ),
    );
  }
}

class iconBox extends StatelessWidget {
  const iconBox({Key? key, this.iconName, required this.detail})
      : super(key: key);
  final iconName;
  final String detail;
  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Container(
          child: Text(iconName),
        ),
        Text(
          detail,
          style: TextStyle(fontFamily: "Title"),
        ),
      ],
    );
  }
}

class petNeutralize extends StatefulWidget {
  const petNeutralize({Key? key}) : super(key: key);

  @override
  State<petNeutralize> createState() => _petNeutralizeState();
}

class _petNeutralizeState extends State<petNeutralize> {
  @override
  Widget build(BuildContext context) {
    return Container(
      child: pet!.neutralize!
          ? Text(
              "중성화 완료",
              style: TextStyle(fontFamily: "Sub", color: btnColor),
            )
          : Text(
              "중성화 미완료",
              style: TextStyle(fontFamily: "Sub", color: btnColor),
            ),
    );
  }
}

class petDead extends StatefulWidget {
  const petDead({Key? key}) : super(key: key);

  @override
  State<petDead> createState() => _petDeadState();
}

class _petDeadState extends State<petDead> {
  @override
  Widget build(BuildContext context) {
    return Container(
      child: pet?.death != null && pet!.death!
          ? Container(
              child: Text(
                "무지개 다리를 건넜어요.",
                style: TextStyle(fontFamily: "Sub"),
              ),
            )
          : Text(""),
    );
  }
}

class infoTitle extends StatelessWidget {
  const infoTitle({Key? key, required this.title}) : super(key: key);

  final String title;

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.start,
      children: [
        Padding(
          padding: EdgeInsets.fromLTRB(5.w, 15.h, 0, 5.h),
          child: Text(
            title,
            style: TextStyle(
              fontSize: 20.sp,
              fontWeight: FontWeight.bold,
              color: btnColor,
              fontFamily: "Sub",
            ),
          ),
        ),
      ],
    );
  }
}

class basicInfoBox extends StatelessWidget {
  const basicInfoBox({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.fromLTRB(20.w, 10.h, 20.w, 10.h),
      decoration: BoxDecoration(
          color: Color(0x80C3B091), borderRadius: BorderRadius.circular(15)),
      child: Column(
        children: [
          Padding(
            padding: EdgeInsets.fromLTRB(0, 5.h, 0, 5.h),
            child: Row(
              children: [
                Flexible(
                  child: iconBox(
                    iconName: "🐶",
                    detail: " 견종",
                  ),
                  flex: 3,
                ),
                Flexible(
                  child: petType(),
                  flex: 8,
                ),
              ],
            ),
          ),
          Padding(
            padding: EdgeInsets.fromLTRB(0, 5.h, 0, 5.h),
            child: Row(
              children: [
                Flexible(
                  // child: petGenderIcon(),
                  child: iconBox(
                    iconName: pet!.gender! == 'M' ? "👦" : "🧒",
                    detail: " 성별",
                  ),
                  flex: 3,
                ),
                Flexible(
                  child: petGender(),
                  flex: 8,
                ),
              ],
            ),
          ),
          Padding(
            padding: EdgeInsets.fromLTRB(0, 5.h, 0, 5.h),
            child: Row(
              children: [
                Flexible(
                  child: iconBox(
                    iconName: "🎉",
                    detail: " 생일",
                  ),
                  flex: 3,
                ),
                Flexible(
                  child: petBirth(),
                  flex: 8,
                ),
              ],
            ),
          ),
          Padding(
            padding: EdgeInsets.fromLTRB(0, 5.h, 0, 5.h),
            child: Row(
              children: [
                Flexible(
                  child: iconBox(
                    iconName: "🎛",
                    detail: " 무게",
                  ),
                  flex: 3,
                ),
                Flexible(
                  child: petWeight(),
                  flex: 8,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class healthInfoBox extends StatelessWidget {
  const healthInfoBox({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.fromLTRB(20.w, 10.h, 20.w, 10.h),
      decoration: BoxDecoration(
          color: Color(0x80C3B091), borderRadius: BorderRadius.circular(15)),
      child: Column(
        children: [
          Padding(
            padding: EdgeInsets.fromLTRB(0, 5.h, 0, 5.h),
            child: Row(
              children: [
                Flexible(
                  child: iconBox(
                    iconName: "😢",
                    detail: " 질환",
                  ),
                  flex: 3,
                ),
                Flexible(
                  child: petHealth(),
                  flex: 8,
                ),
              ],
            ),
          ),
          Padding(
            padding: EdgeInsets.fromLTRB(0, 5.h, 0, 5.h),
            child: Row(
              children: [
                Flexible(
                  child: iconBox(
                    iconName: "🖖",
                    detail: " 중성화",
                  ),
                  flex: 3,
                ),
                Flexible(
                  child: petNeutralize(),
                  flex: 8,
                ),
              ],
            ),
          ),
          Padding(
            padding: EdgeInsets.fromLTRB(0, 5.h, 0, 5.h),
            child: Row(
              children: [
                Flexible(
                  child: iconBox(
                    iconName: "👼",
                    detail: " 사망",
                  ),
                  flex: 3,
                ),
                Flexible(
                  child: petDead(),
                  flex: 8,
                ),
              ],
            ),
          ),
        ],
      ),
    );
    ;
  }
}
