import 'dart:io';

import 'package:GSSL/api/api_community.dart';
import 'package:GSSL/components/bottomNavBar.dart';
import 'package:GSSL/components/util/custom_dialog.dart';
import 'package:GSSL/constants.dart';
import 'package:GSSL/model/request_models/update_board.dart';
import 'package:GSSL/model/response_models/general_response.dart';
import 'package:GSSL/model/response_models/get_board_detail.dart';
import 'package:GSSL/pages/login_page.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:http/http.dart';
import 'package:image_picker/image_picker.dart';
import 'package:path_provider/path_provider.dart';

import './utils_first/database_helper.dart';
import './widgets/card_widget.dart';
import './widgets/icon_button_widget.dart';
import './widgets/my_box_widget.dart';
import './widgets/text_button_widget.dart';
import './widgets/text_field_widget.dart';

class EditPostPage extends StatefulWidget {
  int boardId;
  Board? contentObject;
  EditPostPage(this.boardId);

  @override
  State<EditPostPage> createState() => _EditPostPageState();
}

class _EditPostPageState extends State<EditPostPage> {
  TextEditingController nameController = TextEditingController();
  TextEditingController bodyController = TextEditingController();

  final dbHelper = DatabaseHelper.instance;

  final _formKey = GlobalKey<FormState>();
  String S3Address = "https://a204drdoc.s3.ap-northeast-2.amazonaws.com/";
  File? image;
  final picker = ImagePicker();
  ApiCommunity apiCommunity = ApiCommunity();

  bool insertSuccess = false;

  bool _loading = true;

  Future<void> chooseImage() async {
    var choosedimage = await picker.pickImage(source: ImageSource.gallery);
    //set source: ImageSource.camera to get image from camera
    setState(() {
      image = File(choosedimage!.path);
    });
  }

  @override
  void initState() {
    super.initState();
    _getBoard();
  }

  Future<void> _getBoard() async {
    getBoardDetail result =
        await apiCommunity.getBoardDetailApi(widget.boardId);
    if (result.statusCode == 200) {
      setState(() {
        widget.contentObject = result.board;
        _loading = false;
      });
      nameController.text = widget.contentObject!.title!;
      bodyController.text = widget.contentObject!.content!;
      if (widget.contentObject?.image == null ||
          widget.contentObject!.image!.length == 0) return;
      final url = S3Address + widget.contentObject!.image!; // <-- 1
      final response = await get(Uri.parse(url)); // <--2
      final documentDirectory = await getApplicationDocumentsDirectory();
      final firstPath = documentDirectory.path + "/images";
      final filePathAndName =
          documentDirectory.path + '/images/' + widget.contentObject!.image!;
      //comment out the next three lines to prevent the image from being saved
      //to the device to show that it's coming from the internet
      await Directory(firstPath).create(recursive: true); // <-- 1
      File file2 = new File(filePathAndName); // <-- 2
      file2.writeAsBytesSync(response.bodyBytes); // <-- 3
      setState(() {
        image = file2;
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

  void _submit() async {
    // set this variable to true when we try to submit
    generalResponse result = await apiCommunity.modify(
        image,
        widget.contentObject!.id!,
        updateBoard(
            typeId: widget.contentObject!.typeId!,
            title: nameController.text,
            content: bodyController.text));
    if (result.statusCode == 200) {
      showDialog(
          context: context,
          builder: (BuildContext context) {
            return CustomDialog("게시글 수정에 성공했습니다.", (context) => BottomNavBar());
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
    if (_loading) {
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
      return Scaffold(
        appBar: AppBar(
          centerTitle: true,
          backgroundColor: pColor,
          titleTextStyle: TextStyle(
            fontFamily: "Sub",
            fontSize: 20.sp,
            color: btnColor,
          ),
          title: const Text(
            '게시글 수정하기',
          ),
          leading: IconButtonWidget(
              color: btnColor,
              iconData: Icons.arrow_back_sharp,
              iconColor: nWColor,
              onTap: () => Navigator.of(context).pop(false)),
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
                            padding:
                                EdgeInsets.symmetric(vertical: defaultPadding),
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
                    name: '수정하기',
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
  }

  @override
  void dispose() {
    nameController.dispose();
    bodyController.dispose();
    super.dispose();
  }
}
