import 'package:flutter/material.dart';

enum SingingCharacter { male, female }

class RadioStatefulWidget extends StatefulWidget {
  const RadioStatefulWidget({super.key});

  @override
  State<RadioStatefulWidget> createState() => radioButton();
}

class radioButton extends State<RadioStatefulWidget> {
  SingingCharacter? _character = SingingCharacter.male;

  @override
  Widget build(BuildContext context) {
    return Container(
      child: Column(
          children: <Widget>[
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                ListTile(
                  title: const Text('남자'),
                  leading: Radio<SingingCharacter>(
                    value: SingingCharacter.male,
                    groupValue: _character,
                    onChanged: (SingingCharacter? value) {
                      setState(() {
                        _character = value;
                      });
                    },
                  ),
                ),
                ListTile(
                  title: const Text('여자'),
                  leading: Radio<SingingCharacter>(
                    value: SingingCharacter.female,
                    groupValue: _character,
                    onChanged: (SingingCharacter? value) {
                      setState(() {
                        _character = value;
                      });
                    },
                  ),
                ),
              ],
            )
          ]
      )
    );
  }
}