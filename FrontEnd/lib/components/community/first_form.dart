import 'package:flutter/material.dart';

class FirstPage extends StatelessWidget {
  const FirstPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: Container(
          color: Colors.pink,
          child: Center(
            child: Text(
              '자랑하기 내용',
              style: TextStyle(
                fontSize: 32,
                color: Colors.white,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
        )
    );
  }
}
