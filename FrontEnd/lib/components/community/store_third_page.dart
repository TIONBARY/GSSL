import 'dart:io';

import 'package:GSSL/api/api_community.dart';
import 'package:GSSL/components/bottomNavBar.dart';
import 'package:GSSL/components/util/custom_dialog.dart';
import 'package:GSSL/constants.dart';
import 'package:GSSL/model/request_models/put_board.dart';
import 'package:GSSL/model/response_models/general_response.dart';
import 'package:GSSL/pages/login_page.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

import './widgets/card_widget.dart';
import './widgets/icon_button_widget.dart';
import './widgets/my_box_widget.dart';
import './widgets/text_button_widget.dart';
import './widgets/text_field_widget.dart';

class AddNewFeedPage extends StatefulWidget {
  const AddNewFeedPage({Key? key}) : super(key: key);

  @override
  State<AddNewFeedPage> createState() => _AddNewFeedPageState();
}

class _AddNewFeedPageState extends State<AddNewFeedPage> {
  TextEditingController nameController = TextEditingController();
  TextEditingController bodyController = TextEditingController();

  XFile? image;

  final _formKey = GlobalKey<FormState>();
  final picker = ImagePicker();
  ApiCommunity apiCommunity = ApiCommunity();

  bool insertSuccess = false;

  Future<void> chooseImage() async {
    var choosedimage = await picker.pickImage(source: ImageSource.gallery);
    //set source: ImageSource.camera to get image from camera
    setState(() {
      image = choosedimage;
    });
  }

  void _submit() async {
    // set this variable to true when we try to submit
    generalResponse result = await apiCommunity.register(
        image,
        putBoard(
            typeId: 3,
            title: nameController.text,
            content: bodyController.text));
    if (result.statusCode == 201) {
      showDialog(
          context: context,
          builder: (BuildContext context) {
            return CustomDialog("게시글 등록에 성공했습니다.", (context) => BottomNavBar());
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
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        iconTheme: IconThemeData(
          color: btnColor,
          size: 20,
        ),
        toolbarHeight: 50,
        backgroundColor: pColor,
        title: const Text(
          '반려견 질문하기',
          style: TextStyle(
            color: Colors.black,
            fontSize: 20,
          ),
        ),
        leading: IconButtonWidget(
            color: btnColor,
            iconData: Icons.arrow_back_sharp,
            iconColor: nWColor,
            onTap: () => Navigator.of(context).pop(insertSuccess)),
      ),
      body: SingleChildScrollView(
        child: CardWidget(
          child: Column(
            children: [
              Form(
                  key: _formKey,
                  child: Column(
                    children: [
                      TextFieldWidget(
                        controller: nameController,
                        name: '제목',
                        validator: (text) {
                          if (text == null || text.isEmpty) {
                            return '제목을 입력해주세요.';
                          }
                          if (text.length > 20) {
                            return '제목은 20자 이내로 입력해주세요.';
                          }
                          return null;
                        },
                      ),
                      MyBoxWidget(),
                      TextFieldWidget(
                        controller: bodyController,
                        name: '내용',
                        validator: (text) {
                          if (text == null || text.isEmpty) {
                            return '내용을 입력해주세요.';
                          }
                          if (text.length > 1000) {
                            return '내용은 1000자 이내로 입력해주세요.';
                          }
                          return null;
                        },
                        maxLines: 8,
                      ),
                      MyBoxWidget(),
                      Padding(
                          padding: const EdgeInsets.symmetric(
                              vertical: defaultPadding),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceAround,
                            children: [
                              Container(
                                // color: const Color(0xffd0cece),
                                width: MediaQuery.of(context).size.width / 5,
                                height: MediaQuery.of(context).size.width / 5,
                                child: Center(
                                    child: image == null
                                        ? Text('')
                                        : new Image(
                                            image: new FileImage(
                                                File(image!.path)))),
                                decoration: BoxDecoration(
                                    color: Colors.black,
                                    shape: BoxShape.rectangle),
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
                                        borderRadius:
                                            BorderRadius.circular(10.0),
                                      )),
                                  label: Text("게시글 이미지 선택"),
                                ),
                              ),
                            ],
                          ) // 이름
                          ),
                    ],
                  )),
              MyBoxWidget(
                height: 30,
              ),
              TextBtnWidget(
                  name: '게시하기',
                  btnColor: btnColor,
                  nameColor: nWColor,
                  onTap: () {
                    if (_formKey.currentState!.validate()) {
                      _formKey.currentState!.save();
                      _submit();
                    }
                  }),
            ],
          ),
        ),
      ),
    );
  }

  @override
  void dispose() {
    nameController.dispose();
    bodyController.dispose();
    super.dispose();
  }
}
