import 'package:flutter/material.dart';

class function_box extends StatelessWidget {
  const function_box({Key? key, required this.title}) : super(key: key);
  final title;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(30.0),
      child: Container(child: Column(
        children: [
          Flexible(child: Container(width:480, height:360, color:Colors.yellow,
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
                      child: Text("${title}",style: TextStyle(fontSize: 40,),),
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