import 'package:GSSL/components/user/modify_form.dart';
import 'package:GSSL/constants.dart';
import 'package:GSSL/responsive.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class ModifyUserScreen extends StatelessWidget {
  const ModifyUserScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('내 정보 수정'),
        titleTextStyle: TextStyle(fontFamily: "Daehan", fontSize: 25.sp),
        foregroundColor: nWColor,
        backgroundColor: btnColor,
        centerTitle: true,
      ),
      backgroundColor: nWColor,
      body: GestureDetector(
        onTap: () {
          FocusScope.of(context).unfocus();
        },
        child: SingleChildScrollView(
          child: Responsive(
            mobile: const MobileSignupScreen(),
            desktop: Row(
              children: [
                Expanded(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: const [
                      SizedBox(
                        width: 450,
                        child: ModifyForm(),
                      ),
                      SizedBox(height: defaultPadding / 2),
                      // SocalSignUp()
                    ],
                  ),
                )
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class MobileSignupScreen extends StatelessWidget {
  const MobileSignupScreen({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: <Widget>[
        Row(
          children: const [
            Spacer(),
            Expanded(
              flex: 8,
              child: ModifyForm(),
            ),
            Spacer(),
          ],
        ),
      ],
    );
  }
}
