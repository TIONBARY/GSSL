import 'package:GSSL/api/api_pet.dart';
import 'package:GSSL/api/api_user.dart';
import 'package:GSSL/components/util/custom_dialog.dart';
import 'package:GSSL/constants.dart';
import 'package:GSSL/model/response_models/general_response.dart';
import 'package:GSSL/model/response_models/get_all_pet.dart';
import 'package:GSSL/model/response_models/get_pet_detail.dart';
import 'package:GSSL/model/response_models/user_info.dart';
import 'package:GSSL/pages/login_page.dart';
import 'package:GSSL/pages/main_page.dart';
import 'package:GSSL/pages/pet_detail_page.dart';
import 'package:GSSL/pages/signup_pet_page.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class MainHeaderBar extends StatefulWidget {
  const MainHeaderBar({
    Key? key,
  }) : super(key: key);

  @override
  State<MainHeaderBar> createState() => _MainHeaderBarState();
}

class _MainHeaderBarState extends State<MainHeaderBar> {
  final MainHeaderBarFormKey = GlobalKey<FormState>();
  String S3Address = "https://a204drdoc.s3.ap-northeast-2.amazonaws.com/";
  String? nickname;
  Pet? mainPet;
  User? user;
  List<Pets>? pets;
  AssetImage basic_image = AssetImage("assets/images/basic_dog.png");

  ApiUser apiUser = ApiUser();
  ApiPet apiPet = ApiPet();

  @override
  void initState() {
    super.initState();
    getUser();
  }

  Future<void> getUser() async {
    userInfo? userInfoResponse = await apiUser.getUserInfo();
    if (userInfoResponse.statusCode == 200) {
      setState(() {
        user = userInfoResponse.user;
        nickname = user?.nickname;
      });
      if (user?.petId != 0) getMainPet();
      getAllPetList();
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
                (context) => MainPage());
          });
    }
  }

  Future<void> getMainPet() async {
    getPetDetail? getMainPetResponse =
        await apiPet.getPetDetailApi(user?.petId);
    if (getMainPetResponse.statusCode == 200) {
      setState(() {
        mainPet = getMainPetResponse.pet;
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
                (context) => MainPage());
          });
    }
  }

  Future<void> getAllPetList() async {
    getAllPet? getAllPetResponse = await apiPet.getAllPetApi();
    if (getAllPetResponse.statusCode == 200) {
      setState(() {
        pets = getAllPetResponse.pets;
      });
    } else if (getAllPetResponse.statusCode == 401) {
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
                getAllPetResponse.message == null
                    ? "알 수 없는 오류가 발생했습니다."
                    : getAllPetResponse.message!,
                (context) => MainPage());
          });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 25.w),
      decoration: new BoxDecoration(
        color: nWColor,
        borderRadius: new BorderRadius.all(Radius.circular(5)),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Flexible(
              child: Container(
                child: SizedBox(
                  width: 65.w,
                  height: 65.h,
                  child: GestureDetector(
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => PetDetailScreen()),
                      );
                    },
                    child: mainPet?.animalPic == null ||
                            mainPet?.animalPic!.length == 0
                        ? CircleAvatar(
                            backgroundImage: basic_image,
                          )
                        : CircleAvatar(
                            backgroundImage:
                                NetworkImage(S3Address + mainPet!.animalPic!),
                            radius: 150.0),
                  ),
                ),
              ),
              flex: 2),
          Flexible(
            child: Row(
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                Flexible(
                  child: Container(
                    child: Text(
                      textScaleFactor: 1.25.sp,
                      mainPet?.name == null
                          ? "등록된 반려견이 없습니다."
                          : nickname! + "의 " + mainPet!.name!,
                      overflow: TextOverflow.ellipsis,
                      style: TextStyle(color: btnColor, fontFamily: "Daehan"),
                    ),
                  ),
                ),
              ],
            ),
            flex: 4,
          ),
          Container(
            child: Flexible(
              child: SizedBox(
                width: 40.w,
                height: double.infinity,
                child: IconButton(
                  padding: EdgeInsets.zero,
                  icon: Icon(
                    Icons.arrow_drop_down,
                    size: 40.sp,
                  ),
                  color: btnColor,
                  onPressed: () {
                    showModalBottomSheet<void>(
                      context: context,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(25.0),
                      ),
                      builder: (BuildContext context) {
                        return Container(
                          padding: EdgeInsets.fromLTRB(0, 0, 0, 0),
                          height: 200.h,
                          decoration: new BoxDecoration(
                            color: pColor,
                            borderRadius: new BorderRadius.only(
                              topLeft: const Radius.circular(25.0),
                              topRight: const Radius.circular(25.0),
                            ),
                          ),
                          child: Center(
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              // mainAxisSize: MainAxisSize.min,
                              children: <Widget>[
                                pets == null || pets!.length! == 0
                                    ? Text("등록된 반려견이 없습니다.")
                                    : Expanded(
                                        child: GridView.count(
                                          // Create a grid with 2 columns. If you change the scrollDirection to
                                          // horizontal, this produces 2 rows.
                                          crossAxisCount: 4,
                                          // Generate 100 widgets that display their index in the List.
                                          children: List.generate(pets!.length,
                                              (index) {
                                            Pets pet = pets!.elementAt(index);
                                            return Container(
                                                margin: EdgeInsets.fromLTRB(
                                                    20.w, 0, 20.w, 0),
                                                child: Column(children: [
                                                  SizedBox(
                                                    width: 50.w,
                                                    height: 50.h,
                                                    child: GestureDetector(
                                                        onTap: () async {
                                                          generalResponse res =
                                                              await apiUser
                                                                  .modifyUserPetAPI(
                                                                      pet.id!);
                                                          if (res.statusCode ==
                                                              200) {
                                                            await getUser();
                                                            await getMainPet();
                                                            Navigator.pop(
                                                                context);
                                                          }
                                                        },
                                                        child: pet.animalPic ==
                                                                    null ||
                                                                pet.animalPic!
                                                                        .length ==
                                                                    0
                                                            ? CircleAvatar(
                                                                backgroundImage:
                                                                    basic_image,
                                                                radius: 100.0)
                                                            : CircleAvatar(
                                                                backgroundImage:
                                                                    NetworkImage(
                                                                        S3Address +
                                                                            pet.animalPic!),
                                                                radius: 100.0)),
                                                  ),
                                                  Text(pet.name!)
                                                ]));
                                          }),
                                        ),
                                      ),
                                Container(
                                  margin: EdgeInsets.fromLTRB(0, 15.h, 0, 5.h),
                                  child: SizedBox(
                                    child: IconButton(
                                      icon: Icon(Icons.add),
                                      iconSize: 30.h,
                                      color: btnColor,
                                      onPressed: () => Navigator.push(
                                        context,
                                        MaterialPageRoute(
                                            builder: (context) =>
                                                SignUpPetScreen()),
                                      ),
                                    ),
                                  ),
                                )
                              ],
                            ),
                          ),
                        );
                      },
                    );
                  },
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
