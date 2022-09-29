import 'package:GSSL/constants.dart';
import 'package:flutter/material.dart';

import '../components/userinfo/user_info_form.dart';

class UserInfoPage extends StatelessWidget {
  const UserInfoPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('회원정보'),
        automaticallyImplyLeading: false,
        foregroundColor: nWColor,
        backgroundColor: btnColor,
        centerTitle: true,
      ),
      backgroundColor: nWColor,
      body: MobileUserInfoPage(),
    );
  }
}

class MobileUserInfoPage extends StatelessWidget {
  const MobileUserInfoPage({
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
              child: UserInfoForm(),
            ),
            Spacer(),
          ],
        ),
      ],
    );
  }
}
