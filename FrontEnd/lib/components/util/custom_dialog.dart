import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class CustomDialog extends StatelessWidget {
  String text = "";
  Widget Function(BuildContext)? pageBuilder;

  CustomDialog(this.text, this.pageBuilder);

  @override
  Widget build(BuildContext context) {
    return Dialog(
      shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(20.0)), //this right here
      child: Container(
        height: 100.h,
        child: Padding(
          padding: EdgeInsets.fromLTRB(12.0.w, 12.0.h, 12.0.w, 3.0.h),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Title(
                color: Colors.black,
                child: Text(text, style: TextStyle(fontSize: 18.sp)),
              ),
              Container(
                width: 60.0.w,
                margin: EdgeInsets.fromLTRB(0, 10.h, 0, 0),
                child: ElevatedButton(
                  onPressed: () {
                    if (pageBuilder == null) {
                      Navigator.of(context).pop();
                    } else {
                      Navigator.push(
                          context, MaterialPageRoute(builder: pageBuilder!));
                    }
                  },
                  child: Text(
                    "확인",
                    style: TextStyle(color: Colors.white),
                  ),
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}
