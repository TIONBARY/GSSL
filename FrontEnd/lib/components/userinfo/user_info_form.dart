import 'package:GSSL/constants.dart';
import 'package:flutter/material.dart';

class UserInfoForm extends StatefulWidget {
  const UserInfoForm({
    Key? key,
  }) : super(key: key);

  @override
  State<UserInfoForm> createState() => _UserInfoFormState();
}

class _UserInfoFormState extends State<UserInfoForm> {
  @override
  Widget build(BuildContext context) {
    return Form(
        child: Column(
      children: [
        Padding(
            padding: const EdgeInsets.all(8),
            child: TextFormField(
              keyboardType: TextInputType.text,
              textInputAction: TextInputAction.next,
              cursorColor: btnColor,
              decoration: InputDecoration(
                isCollapsed: true,
                hintText: "아이디",
                hintStyle: TextStyle(color: sColor),
                contentPadding: EdgeInsets.fromLTRB(20, 10, 10, 10),
                enabledBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.all(Radius.circular(10)),
                    borderSide: BorderSide(color: Colors.white)),
                filled: true,
                fillColor: Colors.white,
                focusedBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.all(Radius.circular(10)),
                    borderSide: BorderSide(color: btnColor)),
              ),
            ))
      ],
    ));
  }
}
