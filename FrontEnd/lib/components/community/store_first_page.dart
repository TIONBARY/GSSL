import './utils_first/context_extension.dart';
import 'package:flutter/material.dart';

import './constants/constants.dart';
import './models/content_first_object.dart';
import './utils_first/database_helper.dart';
import './utils_first/database_services.dart';
import './utils_first/validator.dart';
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
  TextEditingController photoUrlController = TextEditingController();
  final dbHelper = DatabaseHelper.instance;

  final _formKey = GlobalKey<FormState>();

  bool insertSuccess = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('반려견 자랑하기'),
        leading: IconButtonWidget(iconData: Icons.arrow_back_sharp, onTap: () => Navigator.of(context).pop(insertSuccess)),
      ),
      body: SingleChildScrollView(
        child: CardWidget(
          child: Column(
            children: [
              Form(
                  key: _formKey,
                  child: Column(
                    children: [
                      TextFieldWidget(controller: nameController, name: '제목'),
                      MyBoxWidget(),
                      TextFieldWidget(
                        controller: bodyController,
                        name: '내용',
                        maxLines: 8,
                      ),
                      MyBoxWidget(),
                      TextFieldWidget(
                        controller: photoUrlController,
                        name: '사진 주소(URL)',
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
                  name: '게시하기',
                  onTap: () {
                    if (_formKey.currentState!.validate()) {
                      ContentObject contentObject = ContentObject(name: nameController.text, body: bodyController.text, photo: photoUrlController.text);
                      DatabaseServices().insertItem(contentObject.toMap(), tableContent).then((value) => context.back(true));
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
