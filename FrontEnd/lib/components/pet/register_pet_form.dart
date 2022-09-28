import 'dart:io';

import 'package:GSSL/api/api_pet.dart';
import 'package:GSSL/model/request_models/pet_info.dart';
import 'package:GSSL/model/response_models/general_response.dart';
import 'package:GSSL/model/response_models/get_all_pet_kind.dart';
import 'package:GSSL/pages/login_page.dart';
import 'package:GSSL/pages/main_page.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:intl/intl.dart';
import '../util/custom_dialog.dart';

import '../../constants.dart';

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
          builder: (BuildContext context){
            return CustomDialog("로그인이 필요합니다.", (context) => LoginScreen());
          }
      );
    } else {
      showDialog(
          context: context,
          builder: (BuildContext context){
            return CustomDialog("알 수 없는 오류가 발생했습니다.", (context) => MainPage());
          }
      );
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
      generalResponse result =  await apiPet.register(animalPicture, petInfo(kindId: kind_id,
      name: name, gender: gender, neutralize: neutralize, birth: birth, weight: weight,
      death: death, diseases: diseases, description: description));
      if (result.statusCode == 201) {
        showDialog(
            context: context,
            builder: (BuildContext context){
              return CustomDialog("펫 등록에 성공했습니다.", (context) => MainPage());
            }
        );
      } else if (result.statusCode == 401) {
        showDialog(
            context: context,
            builder: (BuildContext context){
              return CustomDialog("로그인이 필요합니다.", (context) => LoginScreen());
            }
        );
      } else {
        showDialog(
            context: context,
            builder: (BuildContext context){
              return CustomDialog(result.message!, null);
            }
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Form(
      key: RegisterPetFormKey,
      child: Column(
        children: [
          DropdownButton(
            value: kind_id,
            items: kinds?.map((Kind item) {
              return DropdownMenuItem<int>(
                child: Text(item.name!),
                value: item.id,
              );
            }).toList(),
            onChanged: (dynamic val) {
              setState(() {
                kind_id = val;
              });
            },
          ),
          Padding(
              padding: const EdgeInsets.symmetric(vertical: defaultPadding),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  Container(
                    // color: const Color(0xffd0cece),
                    width: MediaQuery.of(context).size.width/5,
                    height: MediaQuery.of(context).size.width/5,
                    child: Center(
                        child: animalPicture == null
                            ? Text('')
                            : new CircleAvatar(backgroundImage: new FileImage(File(animalPicture!.path)), radius: 200.0,)
                    ),
                    decoration: BoxDecoration(
                        color: Colors.black,
                        shape: BoxShape.circle
                    ),
                  ),
                  Container(
                    child: ElevatedButton.icon(
                      onPressed: (){
                        chooseImage(); // call choose image function
                      },
                      icon:Icon(Icons.image),
                      style: ElevatedButton.styleFrom(
                          backgroundColor: btnColor,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(10.0),
                          )),
                      label: Text("반려견 이미지 선택"),
                    ),
                  ),
                ],
              )// 이름
          ),
          Column(
              children: <Widget>[
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: [
                    Expanded(child: ListTile(
                      title: const Text('수컷'),
                      leading: Radio<String>(
                        value: "M",
                        groupValue: gender,
                        onChanged: (String? value) {
                          setState(() {
                            gender = value;
                          });
                          },
                      ),
                    )),
                    Expanded(child: ListTile(
                      title: const Text('암컷'),
                      leading: Radio<String>(
                        value: "F",
                        groupValue: gender,
                        onChanged: (String? value) {
                          setState(() {
                            gender = value;
                          });
                          },
                      ),
                    )),
                  ],
                )
              ]
          ),
          Padding(
          //   // 성별
              padding: const EdgeInsets.symmetric(vertical: defaultPadding),
              child: Column(
                  children: <Widget>[
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text('중성화 수술을 했어요'),
                        Transform.scale(
                          scale: 1.5,
                          child: Checkbox(
                            activeColor: Colors.white,
                            checkColor: Colors.blue,
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
                        Text('무지개 다리를 건넜어요...'),
                        Transform.scale(
                          scale: 1.5,
                          child: Checkbox(
                            activeColor: Colors.white,
                            checkColor: Colors.blue,
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
                  ]
              )
          ),
          TextField(
            controller: dateinput, //editing controller of this TextField
            decoration: InputDecoration(
                icon: Icon(Icons.calendar_today), //icon of text field
                labelText: "반려견의 생년월일" //label text of field
            ),
            readOnly: true,  //set it true, so that user will not able to edit text
            onTap: () async {
              DateTime? pickedDate = await showDatePicker(
                  context: context, initialDate: DateTime.now(),
                  firstDate: DateTime(1990), //DateTime.now() - not to allow to choose before today.
                  lastDate: DateTime(2023)
              );

              if(pickedDate != null){
                print(pickedDate);  //pickedDate output format => 2021-03-10 00:00:00.000//formatted date output using intl package =>  2021-03-16
                //you can implement different kind of Date Format here according to your requirement

                setState(() {
                  dateinput.text = DateFormat("yyyy-MM-dd").format(pickedDate);
                  birth = pickedDate; //set output date to TextField value.
                });
              } else {
                print("반려견 생년월일을 입력해주세요.");
              }
            },
          ),
          Padding(
            padding: const EdgeInsets.symmetric(vertical: defaultPadding),
            child: TextFormField(
              keyboardType: TextInputType.text,
              textInputAction: TextInputAction.done,
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
                hintText: "이름",
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
          ),
          TextFormField(
              keyboardType: TextInputType.number,
              textInputAction: TextInputAction.done,
              obscureText: false,
              cursorColor: btnColor,
              onChanged: (val) {
                setState(() { weight = double.tryParse(val);});
              },
              autovalidateMode: _submitted
                  ? AutovalidateMode.onUserInteraction
                  : AutovalidateMode.disabled,
              validator: (text) {
                return null;
              },
              decoration: InputDecoration(
                hintText: "몸무게 (선택)",
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
                suffix: Text("kg"),
              ),
            ),
          Padding(
            // 병명
            padding: const EdgeInsets.symmetric(vertical: defaultPadding),
            child: TextFormField(
              keyboardType: TextInputType.text,
              textInputAction: TextInputAction.done,
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
                hintText: "앓고 있는 질환 (선택)",
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
          ),
          TextFormField(
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
              hintText: "반려견 소개 (선택)",
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
          Padding(
            padding: const EdgeInsets.symmetric(vertical: defaultPadding),
            child: Container(
              height: 48,
              width: double.maxFinite,
              child: Hero(
                tag: "next_btn",
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

