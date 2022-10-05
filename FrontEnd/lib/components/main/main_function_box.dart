import 'package:GSSL/constants.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class function_box extends StatelessWidget {
  const function_box(
      {Key? key,
      required this.title,
      required this.box_color,
      required this.paddings,
      required this.nextPage,
      required this.description})
      : super(key: key);
  final title;
  final box_color;
  final paddings;
  final nextPage;
  final description;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => nextPage),
        );
      },
      child: Padding(
        padding: paddings,
        child: Container(
          child: Column(
            children: [
              Flexible(
                child: Stack(
                  children: [
                    imageBox(),
                    Container(
                      width: 480.w,
                      height: 400.h,
                      decoration: BoxDecoration(
                          // borderRadius: BorderRadius.circular(15),
                          color: box_color,
                          boxShadow: [
                            BoxShadow(
                              color: Colors.grey.withOpacity(0.5),
                              spreadRadius: 5,
                              blurRadius: 7,
                              offset: Offset(0, 3),
                            )
                          ]),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Container(
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Padding(
                                  padding: EdgeInsets.fromLTRB(20.w, 0, 0, 0),
                                  child: Text(
                                    "${title}",
                                    style: TextStyle(
                                      fontSize: 60.sp,
                                      color: btnColor,
                                      fontFamily: "Daehan",
                                    ),
                                  ),
                                ),
                                Padding(
                                  padding:
                                      EdgeInsets.fromLTRB(15.w, 10.h, 0, 0),
                                  child: Text(
                                    description,
                                    style: TextStyle(
                                      fontSize: 12.5.sp,
                                      color: nWColor,
                                      fontFamily: "Sub",
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
                flex: 1,
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class imageBox extends StatelessWidget {
  const imageBox({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 480.w,
      height: 400.h,
      decoration: BoxDecoration(
          // borderRadius: BorderRadius.circular(15),
          ),
      child: Image.asset(
        'assets/images/silok2.png',
        fit: BoxFit.fitHeight,
      ),
    );
  }
}
