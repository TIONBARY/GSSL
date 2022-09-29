import 'package:GSSL/components/pet/modify_pet_form.dart';
import 'package:GSSL/constants.dart';
import 'package:GSSL/responsive.dart';
import 'package:flutter/material.dart';

import '../components/logo.dart';

class ModifyPetScreen extends StatelessWidget {
  const ModifyPetScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: pColor,
      body: GestureDetector(
        onTap: () {
          FocusScope.of(context).unfocus();
        },
        child: SingleChildScrollView(
          child: Responsive(
            mobile: const MobileSignupScreen(),
            desktop: Row(
              children: [
                const Expanded(
                  child: Logo(heights: defaultPadding),
                ),
                Expanded(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: const [
                      SizedBox(
                        width: 450,
                        child: ModifyPetForm(),
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
  const MobileSignupScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: <Widget>[
        const Logo(heights: defaultPadding),
        Row(
          children: const [
            Spacer(),
            Expanded(
              flex: 8,
              child: ModifyPetForm(),
            ),
            Spacer(),
          ],
        ),
        // const SocalSignUp()
      ],
    );
  }
}
