import 'package:GSSL/api/api_pet.dart';
import 'package:GSSL/api/api_user.dart';
import 'package:GSSL/components/util/custom_dialog.dart';
import 'package:GSSL/constants.dart';
import 'package:GSSL/model/response_models/get_all_pet.dart';
import 'package:GSSL/model/response_models/get_pet_detail.dart';
import 'package:GSSL/model/response_models/user_info.dart';
import 'package:GSSL/pages/login_page.dart';
import 'package:GSSL/pages/main_page.dart';
import 'package:GSSL/pages/signup_pet_page.dart';
import 'package:flutter/material.dart';
import 'package:GSSL/model/response_models/general_response.dart';
import 'package:image_picker/image_picker.dart';

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
  String? mainAnimalName;
  String? mainAnimalImage;
  User? user;
  List<Pets>? pets;
  AssetImage basic_image = AssetImage("assets/images/basic_dog.jpg");

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
            return CustomDialog("알 수 없는 오류가 발생했습니다.", (context) => MainPage());
          });
    }
  }

  Future<void> getMainPet() async {
    getPetDetail? getMainPetResponse =
        await apiPet.getPetDetailApi(user?.petId);
    if (getMainPetResponse.statusCode == 200) {
      setState(() {
        mainAnimalImage = getMainPetResponse.pet?.animalPic;
        mainAnimalName = getMainPetResponse.pet?.name;
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
            return CustomDialog("알 수 없는 오류가 발생했습니다.", (context) => MainPage());
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
            return CustomDialog("알 수 없는 오류가 발생했습니다.", (context) => MainPage());
          });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Flexible(
            child: Container(
          margin: EdgeInsets.fromLTRB(30, 0, 0, 0),
          child: SizedBox(
            width: 80.0,
            height: 80.0,
            child: GestureDetector(
              onTap: () => print('이미지 클릭'),
              child: mainAnimalImage == null || mainAnimalImage!.length == 0
                  ? CircleAvatar(
                      backgroundImage:
                          basic_image,
                    )
                  : CircleAvatar(
                      backgroundImage:
                          NetworkImage(S3Address + mainAnimalImage!),
                      radius: 100.0),
            ),
          ),
        )),
        Flexible(
          child: Container(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Flexible(
                  child: Container(
                    child: Container(
                      padding: EdgeInsets.fromLTRB(20, 10, 0, 10),
                      child: Text(
                        mainAnimalName == null
                            ? "등록된 반려견이 없습니다."
                            : nickname! + "의 " + mainAnimalName!,
                        style: TextStyle(color: btnColor),
                      ),
                      width: double.infinity,
                      height: double.infinity,
                    ),
                  ),
                  flex: 1,
                ),
              ],
            ),
          ),
          flex: 3,
        ),
        Flexible(
          child: Container(
            child: Container(
              child: IconButton(
                icon: Icon(Icons.wifi_protected_setup),
                color: btnColor,
                onPressed: () {
                  showModalBottomSheet<void>(
                    context: context,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(25.0),
                    ),
                    builder: (BuildContext context) {
                      return Container(
                        padding: EdgeInsets.fromLTRB(0, 20, 0, 0),
                        height: 275,
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
                                                  20, 0, 20, 0),
                                              child: Column(children: [
                                                SizedBox(
                                                  width: 65.0,
                                                  height: 65.0,
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
                                margin: EdgeInsets.fromLTRB(0, 30, 0, 10),
                                child: SizedBox(
                                  child: IconButton(
                                    icon: Icon(Icons.add),
                                    iconSize: 50,
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
              width: double.infinity,
              height: double.infinity,
            ),
          ),
          flex: 1,
        ),
      ],
    );
  }
}
