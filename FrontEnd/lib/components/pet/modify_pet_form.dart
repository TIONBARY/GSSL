import 'dart:io';

import 'package:GSSL/api/api_pet.dart';
import 'package:GSSL/api/api_user.dart';
import 'package:GSSL/components/bottomNavBar.dart';
import 'package:GSSL/model/request_models/update_pet_info.dart';
import 'package:GSSL/model/response_models/general_response.dart';
import 'package:GSSL/model/response_models/get_all_pet_kind.dart';
import 'package:GSSL/model/response_models/get_pet_detail.dart';
import 'package:GSSL/pages/login_page.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:http/http.dart';
import 'package:image_picker/image_picker.dart';
import 'package:intl/intl.dart';
import 'package:path_provider/path_provider.dart';

import '../../constants.dart';
import '../../model/response_models/user_info.dart';
import '../util/custom_dialog.dart';

class ModifyPetForm extends StatefulWidget {
  const ModifyPetForm({
    Key? key,
  }) : super(key: key);

  @override
  State<ModifyPetForm> createState() => _ModifyPetFormState();
}

class _ModifyPetFormState extends State<ModifyPetForm> {
  final ModifyPetFormKey = GlobalKey<FormState>();
  List<Kind>? kinds;

  int? kind_id = 0;
  bool? species = true;
  String? name = '';
  String? gender = 'M';
  bool? neutralize = false;
  DateTime? birth;
  double? weight;
  File? animalPicture;
  bool? death = false;
  String? diseases = '';
  String? description = '';

  TextEditingController dateinput = TextEditingController();
  String S3Address = "https://a204drdoc.s3.ap-northeast-2.amazonaws.com/";
  Pet? pet;
  User? user;
  ApiPet apiPet = ApiPet();
  ApiUser apiUser = ApiUser();

  final picker = ImagePicker();

  bool _loading = true;

  Future<void> chooseImage() async {
    var choosedimage = await picker.pickImage(source: ImageSource.gallery);
    //set source: ImageSource.camera to get image from camera
    setState(() {
      animalPicture = File(choosedimage!.path);
    });
  }

  Future<void> getAllPetKinds() async {
    getAllPetKind? kindResponse = await apiPet.getPetKind();
    if (kindResponse.statusCode == 200) {
      setState(() {
        kinds = kindResponse.kinds;
        kinds?.add(Kind(id: 0, name: "품종 선택"));
      });
    } else if (kindResponse.statusCode == 401) {
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
                kindResponse.message == null
                    ? "알 수 없는 오류가 발생했습니다."
                    : kindResponse.message!,
                (context) => BottomNavBar());
          });
    }
  }

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
        kind_id = pet!.kindId;
        species = pet!.species!;
        name = pet!.name!;
        gender = pet!.gender!;
        neutralize = pet!.neutralize!;
        dateinput = TextEditingController(text: pet!.birth!.split("T")[0]);
        birth = DateTime(
            int.parse(pet!.birth!.substring(0, 4)),
            int.parse(pet!.birth!.substring(5, 7)),
            int.parse(pet!.birth!.substring(8, 10)));
        weight = pet!.weight!;
        // animalPicture = NetworkImage(S3Address + pet!.animalPic!);

        death = pet!.death!;
        diseases = pet!.diseases!;
        description = pet!.description!;
        _loading = false;
      });
      if (pet?.animalPic == null || pet!.animalPic!.length == 0) return;
      final url = S3Address + pet!.animalPic!; // <-- 1
      final response = await get(Uri.parse(url)); // <--2
      final documentDirectory = await getApplicationDocumentsDirectory();
      final firstPath = documentDirectory.path + "/images";
      final filePathAndName =
          documentDirectory.path + '/images/' + pet!.animalPic!;
      //comment out the next three lines to prevent the image from being saved
      //to the device to show that it's coming from the internet
      await Directory(firstPath).create(recursive: true); // <-- 1
      File file2 = new File(filePathAndName); // <-- 2
      file2.writeAsBytesSync(response.bodyBytes); // <-- 3
      setState(() {
        animalPicture = file2;
      });
      print(animalPicture);
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

  @override
  void initState() {
    super.initState();
    getAllPetKinds();
    getUser();
  }

  bool _submitted = false;

  void _submit() async {
    // set this variable to true when we try to submit
    setState(() => _submitted = true);
    if (ModifyPetFormKey.currentState!.validate()) {
      ModifyPetFormKey.currentState!.save();
      generalResponse result = await apiPet.modify(
          animalPicture,
          pet?.id,
          updatePetInfo(
              kindId: kind_id,
              name: name,
              gender: gender,
              neutralize: neutralize,
              birth: birth,
              weight: weight,
              death: death,
              diseases: diseases,
              description: description));
      if (result.statusCode == 200) {
        showDialog(
            context: context,
            builder: (BuildContext context) {
              return CustomDialog("펫 수정에 성공했습니다.", (context) => BottomNavBar());
            });
      } else if (result.statusCode == 401) {
        showDialog(
            context: context,
            builder: (BuildContext context) {
              return CustomDialog("로그인이 필요합니다.", (context) => LoginScreen());
            });
      } else {
        showDialog(
            context: context,
            builder: (BuildContext context) {
              return CustomDialog(result.message!, null);
            });
      }
    } else {
      showDialog(
          context: context,
          builder: (BuildContext context) {
            return CustomDialog("필수 정보를 입력해주세요.", null);
          });
    }
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
      return Form(
        key: ModifyPetFormKey,
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.symmetric(vertical: defaultPadding),
              child: TextFormField(
                // 반려견 이름
                style: TextStyle(fontFamily: "Sub"),
                keyboardType: TextInputType.text,
                textInputAction: TextInputAction.next,
                cursorColor: btnColor,
                controller: TextEditingController()
                  ..text = name == null || name!.length == 0 ? "" : name!,
                onChanged: (val) {
                  name = val;
                },
                autovalidateMode: _submitted
                    ? AutovalidateMode.onUserInteraction
                    : AutovalidateMode.disabled,
                validator: (text) {
                  if (text == null || text.isEmpty) {
                    return '반려견의 이름을 입력해주세요.';
                  }
                  if (text.length > 10) {
                    return '10자 이내로 입력해주세요.';
                  }
                  return null;
                },
                decoration: InputDecoration(
                  isCollapsed: true,
                  hintText: "이름",
                  hintStyle: TextStyle(color: sColor, fontFamily: "Sub"),
                  contentPadding: EdgeInsets.fromLTRB(20.w, 10.h, 10.w, 10.h),
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
            ),
            DropdownButtonFormField(
              decoration: InputDecoration(
                contentPadding: EdgeInsets.fromLTRB(20.w, 14.h, 10.w, 14.h),
                enabledBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.all(Radius.circular(10)),
                    borderSide: BorderSide(color: sColor)),
                filled: true,
                fillColor: Colors.white,
                focusedBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.all(Radius.circular(10)),
                    borderSide: BorderSide(color: btnColor)),
              ),
              isExpanded: true,
              value: kind_id,
              items: kinds?.map((Kind item) {
                return DropdownMenuItem<int>(
                  child: Text(
                    item.name!,
                    style: TextStyle(color: btnColor, fontFamily: "Sub"),
                  ),
                  value: item.id,
                );
              }).toList(),
              onChanged: (dynamic val) {
                setState(() {
                  kind_id = val;
                });
              },
            ),
            Column(children: <Widget>[
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  Expanded(
                      child: ListTile(
                    title: const Text(
                      '남아',
                      style: TextStyle(color: btnColor, fontFamily: "Sub"),
                    ),
                    leading: Radio<String>(
                      value: "M",
                      groupValue: gender,
                      fillColor:
                          MaterialStateColor.resolveWith((states) => btnColor),
                      onChanged: (String? value) {
                        setState(() {
                          gender = value;
                        });
                      },
                    ),
                  )),
                  Expanded(
                      child: ListTile(
                    title: const Text(
                      '여아',
                      style: TextStyle(color: btnColor, fontFamily: "Sub"),
                    ),
                    leading: Radio<String>(
                      value: "F",
                      groupValue: gender,
                      fillColor:
                          MaterialStateColor.resolveWith((states) => btnColor),
                      onChanged: (String? value) {
                        setState(() {
                          gender = value;
                        });
                      },
                    ),
                  )),
                ],
              )
            ]),
            Padding(
                padding: EdgeInsets.fromLTRB(10.w, 0, 0, 0),
                child: Column(children: <Widget>[
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        '중성화 수술을 했어요',
                        style: TextStyle(color: btnColor, fontFamily: "Sub"),
                      ),
                      Transform.scale(
                        scale: 1.25,
                        child: Checkbox(
                          activeColor: btnColor,
                          checkColor: nWColor,
                          value: neutralize,
                          onChanged: (value) {
                            setState(() {
                              neutralize = value;
                            });
                          },
                        ),
                      ),
                    ],
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        '무지개 다리를 건넜어요...',
                        style: TextStyle(color: btnColor, fontFamily: "Sub"),
                      ),
                      Transform.scale(
                        scale: 1.25,
                        child: Checkbox(
                          activeColor: btnColor,
                          checkColor: nWColor,
                          value: death,
                          onChanged: (value) {
                            setState(() {
                              death = value;
                            });
                          },
                        ),
                      ),
                    ],
                  ),
                ])),
            Padding(
              padding: const EdgeInsets.symmetric(vertical: defaultPadding),
              child: TextField(
                style: TextStyle(fontFamily: "Sub"),
                controller: dateinput,
                //editing controller of this TextField
                decoration: InputDecoration(
                  prefixIcon: Padding(
                    padding: const EdgeInsets.all(defaultPadding),
                    child: Icon(Icons.calendar_today, color: sColor),
                  ),
                  hintText: "반려견의 생년월일",
                  hintStyle: TextStyle(color: sColor, fontFamily: "Sub"),
                  contentPadding: EdgeInsets.fromLTRB(20.w, 10.h, 10.w, 10.h),
                  enabledBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.all(Radius.circular(10)),
                      borderSide: BorderSide(color: sColor)),
                  filled: true,
                  fillColor: Colors.white,
                  focusedBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.all(Radius.circular(10)),
                      borderSide: BorderSide(color: btnColor)),
                ),
                readOnly: true,
                //set it true, so that user will not able to edit text
                onTap: () async {
                  DateTime? pickedDate = await showDatePicker(
                      context: context,
                      initialDate: DateTime.now(),
                      firstDate: DateTime(1990),
                      //DateTime.now() - not to allow to choose before today.
                      lastDate: DateTime(2023),
                      builder: (context, child) {
                        return Theme(
                          data: Theme.of(context).copyWith(
                            colorScheme: ColorScheme.light(
                              primary: sColor,
                              onPrimary: btnColor,
                              onSurface: btnColor,
                            ),
                            textButtonTheme: TextButtonThemeData(
                              style: TextButton.styleFrom(
                                primary: btnColor, // button text color
                              ),
                            ),
                          ),
                          child: child!,
                        );
                      });

                  if (pickedDate != null) {
                    print(
                        pickedDate); //pickedDate output format => 2021-03-10 00:00:00.000//formatted date output using intl package =>  2021-03-16
                    //you can implement different kind of Date Format here according to your requirement

                    setState(() {
                      dateinput.text =
                          DateFormat("yyyy-MM-dd").format(pickedDate);
                      birth = pickedDate; //set output date to TextField value.
                    });
                  } else {
                    print("반려견 생년월일을 입력해주세요.");
                  }
                },
              ),
            ),
            Container(
                margin: EdgeInsets.fromLTRB(0, 0, 0, 10),
                child: Divider(color: sColor, thickness: 2.0)),
            Column(
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: [
                    Container(
                      // color: const Color(0xffd0cece),
                      width: MediaQuery.of(context).size.width / 5,
                      height: MediaQuery.of(context).size.width / 5,
                      child: Center(
                          child: animalPicture == null
                              ? Text('')
                              : new CircleAvatar(
                                  backgroundImage:
                                      new FileImage(File(animalPicture!.path)),
                                  radius: 200.0,
                                )),
                      decoration:
                          BoxDecoration(color: sColor, shape: BoxShape.circle),
                    ),
                    Container(
                      child: ElevatedButton.icon(
                        onPressed: () {
                          chooseImage(); // call choose image function
                        },
                        icon: Icon(Icons.image),
                        style: ElevatedButton.styleFrom(
                            backgroundColor: btnColor,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(5.0),
                            )),
                        label: Text(
                          "반려견 이미지 (선택)",
                          style: TextStyle(
                            fontFamily: "Sub",
                          ),
                        ),
                      ),
                    ),
                  ],
                )
              ],
            ),
            Padding(
              padding: const EdgeInsets.symmetric(vertical: defaultPadding),
              child: TextFormField(
                // 몸무게
                style: TextStyle(fontFamily: "Sub"),
                keyboardType: TextInputType.number,
                textInputAction: TextInputAction.next,
                controller: TextEditingController()
                  ..text =
                      weight == null || weight == 0.0 ? "" : weight.toString(),
                cursorColor: btnColor,
                onSaved: (val) {
                  setState(() {
                    weight = double.tryParse(val!);
                  });
                },
                autovalidateMode: _submitted
                    ? AutovalidateMode.onUserInteraction
                    : AutovalidateMode.disabled,
                validator: (text) {
                  return null;
                },
                decoration: InputDecoration(
                    isCollapsed: true,
                    hintText: "몸무게 (선택)",
                    hintStyle: TextStyle(color: sColor, fontFamily: "Sub"),
                    contentPadding: EdgeInsets.fromLTRB(20.w, 10.h, 10.w, 10.h),
                    enabledBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.all(Radius.circular(10)),
                        borderSide: BorderSide(color: sColor)),
                    filled: true,
                    fillColor: Colors.white,
                    focusedBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.all(Radius.circular(10)),
                        borderSide: BorderSide(color: btnColor)),
                    suffix: Text("kg")),
              ),
            ),
            TextFormField(
              // 질환
              style: TextStyle(fontFamily: "Sub"),
              keyboardType: TextInputType.text,
              textInputAction: TextInputAction.next,
              cursorColor: btnColor,
              controller: TextEditingController()
                ..text =
                    diseases == null || diseases!.length == 0 ? "" : diseases!,
              onChanged: (val) {
                diseases = val;
              },
              autovalidateMode: _submitted
                  ? AutovalidateMode.onUserInteraction
                  : AutovalidateMode.disabled,
              validator: (text) {
                if (text == null) {
                  return null;
                }
                if (text.length > 15) {
                  return '앓고 있는 질환은 최대 15자까지 입력할 수 있어요.';
                }
                return null;
              },
              decoration: InputDecoration(
                isCollapsed: true,
                hintText: "앓고 있는 질환 (선택)",
                hintStyle: TextStyle(color: sColor, fontFamily: "Sub"),
                contentPadding: EdgeInsets.fromLTRB(20.w, 10.h, 10.w, 10.h),
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
            Padding(
              padding: const EdgeInsets.symmetric(vertical: defaultPadding),
              child: TextFormField(
                style: TextStyle(fontFamily: "Sub"),
                keyboardType: TextInputType.multiline,
                maxLines: 4,
                textInputAction: TextInputAction.done,
                cursorColor: btnColor,
                controller: TextEditingController()
                  ..text = description == null || description!.length == 0
                      ? ""
                      : description!,
                onChanged: (val) {
                  description = val;
                },
                autovalidateMode: _submitted
                    ? AutovalidateMode.onUserInteraction
                    : AutovalidateMode.disabled,
                validator: (text) {
                  if (text == null) {
                    return null;
                  }
                  if (text.length > 50) {
                    return '반려견 소개는 최대 50자까지 입력할 수 있어요.';
                  }
                  return null;
                },
                decoration: InputDecoration(
                  isCollapsed: true,
                  hintText: "반려견 소개 (선택)",
                  hintStyle: TextStyle(color: sColor, fontFamily: "Sub"),
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
            ),
            Padding(
              padding: const EdgeInsets.symmetric(vertical: defaultPadding),
              child: Container(
                height: 35.h,
                width: double.maxFinite,
                child: Hero(
                  tag: "modify_btn",
                  child: ElevatedButton(
                    onPressed: () {
                      _submit();
                    },
                    style: ElevatedButton.styleFrom(
                        backgroundColor: btnColor,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(25.0),
                        )),
                    child: Text(
                      "반려견 정보 수정".toUpperCase(),
                      style: TextStyle(
                        fontFamily: "Sub",
                      ),
                    ),
                  ),
                ),
              ),
            ),
            const SizedBox(height: defaultPadding / 2),
          ],
        ),
      );
    }
  }
}
