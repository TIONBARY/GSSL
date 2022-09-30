import 'package:GSSL/api/api_community.dart';
import 'package:GSSL/components/util/custom_dialog.dart';
import 'package:GSSL/model/response_models/get_board_detail.dart';
import 'package:GSSL/pages/login_page.dart';
import 'package:flutter/material.dart';

import './constants/constants.dart';
import './models/content_first_object.dart';
import './utils_first/context_extension.dart';
import './utils_first/database_helper.dart';
import './utils_first/database_services.dart';
import './utils_first/validator.dart';
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
  TextEditingController photoUrlController = TextEditingController();

  final dbHelper = DatabaseHelper.instance;

  final _formKey = GlobalKey<FormState>();

  ApiCommunity apiCommunity = ApiCommunity();

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
      });
      nameController.text = widget.contentObject!.title!;
      bodyController.text = widget.contentObject!.content!;
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
        title: const Text('Edit Content'),
        leading: IconButtonWidget(
            iconData: Icons.arrow_back_sharp,
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
                      TextFieldWidget(controller: nameController, name: 'Name'),
                      MyBoxWidget(),
                      TextFieldWidget(
                        controller: bodyController,
                        name: 'Body',
                        maxLines: 8,
                      ),
                      MyBoxWidget(),
                      TextFieldWidget(
                        controller: photoUrlController,
                        name: 'Photo Path',
                        isRequired: false,
                        maxLines: 2,
                        validator: () {
                          if (photoUrlController.text.isNotEmpty) {
                            Validation.url(photoUrlController.text);
                          }
                        },
                      ),
                    ],
                  )),
              MyBoxWidget(
                height: 30,
              ),
              TextBtnWidget(
                  name: 'Save',
                  onTap: () {
                    if (_formKey.currentState!.validate()) {
                      ContentObject contentObject = ContentObject(
                          id: widget.contentObject!.id!,
                          name: nameController.text,
                          body: bodyController.text,
                          photo: photoUrlController.text);
                      Map<String, dynamic> map = contentObject.toMap();
                      DatabaseServices()
                          .updateItem(map, tableContent)
                          .then((value) {
                        context.back(true);
                      });
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
    photoUrlController.dispose();
    super.dispose();
  }
}
