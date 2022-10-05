import 'package:GSSL/constants.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class TextFieldWidget extends StatelessWidget {
  final TextEditingController controller;
  final String name;
  final int maxLines;
  final bool isObscured;
  final bool isRequired;
  final TextInputType textInputType;
  final Color? filledColor;
  Function? validator;

  TextFieldWidget(
      {required this.controller,
      required this.name,
      this.maxLines = 1,
      this.isRequired = true,
      this.isObscured = false,
      this.textInputType = TextInputType.text,
      this.filledColor,
      this.validator});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Padding(
          padding: EdgeInsets.fromLTRB(0, 0, 0, 5.h),
          child: Row(
            children: [
              Text(
                name,
                style: TextStyle(
                  fontFamily: "Daehan",
                  fontSize: 20.sp,
                  color: btnColor,
                ),
              ),
              if (isRequired)
                const Padding(
                  padding: EdgeInsets.only(left: 2),
                  child: Text(
                    '*',
                    style: TextStyle(color: Colors.red, fontSize: 15),
                  ),
                )
            ],
          ),
        ),
        TextFormField(
          validator: validator == null
              ? (value) {
                  if (validator == null || validator!() == null) {
                    if ((value == null || value.isEmpty) && isRequired) {
                      return 'Please enter some text';
                    }
                    return null;
                  }
                  return null;
                }
              : (value) {
                  return validator!(value);
                },
          controller: controller,
          obscureText: isObscured,
          keyboardType: textInputType,
          cursorColor: btnColor,
          style: TextStyle(fontFamily: "Daehan"),
          decoration: InputDecoration(
            isDense: true,
            contentPadding: EdgeInsets.fromLTRB(20.w, 10.h, 10.w, 10.h),
            enabledBorder: OutlineInputBorder(
                borderRadius: BorderRadius.all(Radius.circular(15)),
                borderSide: BorderSide.none),
            filled: true,
            fillColor: filledColor ?? Color(0x40C3B091),
            focusedBorder: OutlineInputBorder(
                borderRadius: BorderRadius.all(Radius.circular(15)),
                borderSide: BorderSide(color: btnColor)),
            errorBorder: OutlineInputBorder(
              borderRadius: BorderRadius.all(Radius.circular(15)),
              borderSide: BorderSide(
                color: Colors.red,
              ),
            ),
            focusedErrorBorder: OutlineInputBorder(
              borderRadius: BorderRadius.all(Radius.circular(15)),
              borderSide: BorderSide(
                color: Colors.red,
              ),
            ),
          ),
          // cursorColor: baseColor,
          showCursor: true,
          maxLines: maxLines,
        ),
      ],
    );
  }
}
