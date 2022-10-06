import 'dart:io';

import 'package:GSSL/api/api_pet.dart';
import 'package:GSSL/components/bottomNavBar.dart';
import 'package:GSSL/model/request_models/pet_info.dart';
import 'package:GSSL/model/response_models/general_response.dart';
import 'package:GSSL/model/response_models/get_all_pet_kind.dart';
import 'package:GSSL/pages/login_page.dart';
import 'package:GSSL/pages/main_page.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:image_picker/image_picker.dart';
import 'package:intl/intl.dart';

import '../../constants.dart';
import '../util/custom_dialog.dart';

class RegisterPetForm extends StatefulWidget {
  const RegisterPetForm({
    Key? key,
  }) : super(key: key);

  @override
  State<RegisterPetForm> createState() => _RegisterPetFormState();
}

class _RegisterPetFormState extends State<RegisterPetForm> {
  final RegisterPetFormKey = GlobalKey<FormState>();
  List<Kind>? kinds;
  int? kind_id = 0;
  bool? species = true;
  String? name = '';
  String? gender = 'M';
  bool? neutralize = false;
  TextEditingController dateinput = TextEditingController();
  DateTime? birth;
  double? weight;
  XFile? animalPicture;
  bool? death = false;
  String? diseases = '';
  String? description = '';
  generalResponse? petRegister;
  ApiPet apiPet = ApiPet();

  final picker = ImagePicker();

  Future<void> chooseImage() async {
    var choosedimage = await picker.pickImage(source: ImageSource.gallery);
    //set source: ImageSource.camera to get image from camera
    setState(() {
      animalPicture = choosedimage;
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
            return CustomDialog("알 수 없는 오류가 발생했습니다.", (context) => MainPage());
          });
    }
  }

  @override
  void initState() {
    super.initState();
    getAllPetKinds();
  }

  bool _submitted = false;

  void _submit() async {
    // set this variable to true when we try to submit
    setState(() => _submitted = true);
    if (RegisterPetFormKey.currentState!.validate()) {
      RegisterPetFormKey.currentState!.save();
      generalResponse result = await apiPet.register(
          animalPicture,
          petInfo(
              kindId: kind_id,
              name: name,
              gender: gender,
              neutralize: neutralize,
              birth: birth,
              weight: weight,
              death: death,
              diseases: diseases,
              description: description));
      if (result.statusCode == 201) {
        showDialog(
            context: context,
            builder: (BuildContext context) {
              return CustomDialog("펫 등록에 성공했습니다.", (context) => BottomNavBar());
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
    return Form(
      key: RegisterPetFormKey,
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
                // Row(
                //   mainAxisAlignment: MainAxisAlignment.spaceBetween,
                //   children: [
                //     Text('무지개 다리를 건넜어요...'),
                //     Transform.scale(
                //       scale: 1.5,
                //       child: Checkbox(
                //         activeColor: Colors.white,
                //         checkColor: Colors.blue,
                //         value: death,
                //         onChanged: (value) {
                //           setState(() {
                //             death = value;
                //           });
                //         },
                //       ),
                //     ),
                //   ],
                // ),
              ])),
          Padding(
            padding: const EdgeInsets.symmetric(vertical: defaultPadding),
            child: TextField(
              style: TextStyle(fontFamily: "Sub"),
              controller: dateinput, //editing controller of this TextField
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
              readOnly:
                  true, //set it true, so that user will not able to edit text
              onTap: () async {
                DateTime? pickedDate = await showDatePicker(
                    context: context,
                    initialDate: DateTime.now(),
                    firstDate: DateTime(
                        1990), //DateTime.now() - not to allow to choose before today.
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
                  hintStyle: TextStyle(color: sColor, fontFamily: "v"),
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
                tag: "signup_btn",
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
                    "반려견 등록".toUpperCase(),
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
