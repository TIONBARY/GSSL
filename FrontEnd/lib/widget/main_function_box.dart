import 'package:flutter/material.dart';

class function_box extends StatelessWidget {
  const function_box({Key? key, required this.title, required this.box_color, required this.paddings}) : super(key: key);
  final title;
  final box_color;
  final paddings;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: paddings,
      child: Container(child: Column(
        children: [
          Flexible(child: Container(width:480, height:360, color:box_color,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Container(child:
                Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Padding(
                      padding: const EdgeInsets.all(15.0),
                      child: Text("${title}",style: TextStyle(fontSize: 40, fontFamily: "Daehan"),),
                    ),
                  ],
                ),
                  width: 200, height: 100, color: Colors.red,),
              ],
            ),),flex: 1,),
        ],
      ),),
    );;;
  }
}