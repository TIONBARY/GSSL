import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../constants.dart';

class health_magazine extends StatelessWidget {
  const health_magazine({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 480.sm,
      width: 480.sm,
      padding: EdgeInsets.all(5.sm),
      color: nWColor,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Column(
            children: [
              magazineBox(
                picAdr: 'assets/images/tooth/001.png',
                category: '건강',
                title: "반짝 반짝 건치를 위한\n양치 꿀팁 대방출!",
                content: tooth_health_news(),
              ),
              magazineBox(
                  picAdr: 'assets/images/food_ad/001.png',
                  category: '사료',
                  title: "우리 아이가 좋아하는 간식!\n견생실록이 책임질게요.",
                  content: food_ad()),
            ],
          ),
          Column(
            children: [
              magazineBox(
                  picAdr: 'assets/images/behave_news/001.png',
                  category: '톡톡',
                  title: "강아지 콧구멍이 촉촉한 이유.\n그것을 알려드림",
                  content: pet_behave_news()),
              magazineBox(
                  picAdr: 'assets/images/salon_ad/001.jpg',
                  category: '협찬',
                  title: "멍멍살롱이 오픈 했어요.\n오픈 기념 할인권 대방출!",
                  content: salon_ad()),
            ],
          )
        ],
      ),
    );
  }
}

class magazineBox extends StatelessWidget {
  const magazineBox(
      {Key? key,
      required this.picAdr,
      required this.category,
      required this.title,
      required this.content})
      : super(key: key);

  final picAdr;
  final category;
  final title;
  final content;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        showModalBottomSheet(
          context: context,
          isScrollControlled: true,
          builder: (BuildContext context) {
            return Container(
                height: 0.8.sh,
                decoration: BoxDecoration(
                    color: nWColor,
                    borderRadius: BorderRadius.only(
                      topLeft: Radius.circular(10),
                      topRight: Radius.circular(10),
                    )),
                child: content); // 내부
          },
        );
      },
      child: magazineBoxTitle(
        picAdr: picAdr,
        category: category,
        title: title,
      ), // 보이는 화면
    );
  }
}

class magazineBoxTitle extends StatelessWidget {
  const magazineBoxTitle(
      {Key? key,
      required this.picAdr,
      required this.category,
      required this.title})
      : super(key: key);

  final picAdr;
  final category;
  final title;

  @override
  Widget build(BuildContext context) {
    return Container(
        width: 0.45.sw,
        height: 230.sm,
        margin: EdgeInsets.fromLTRB(5.w, 0, 5.w, 0),
        child: Column(
          children: [
            Expanded(child: Image.asset("${picAdr}")),
            Container(
              color: nWColor,
              child: Padding(
                padding: EdgeInsets.fromLTRB(0, 2.h, 2.h, 0),
                child: Flexible(
                  child: Container(
                    color: nWColor,
                    child: Text(
                        overflow: TextOverflow.ellipsis,
                        style: TextStyle(
                          fontFamily: "sub",
                          fontSize: 13.sp,
                        ),
                        "${title}"),
                  ),
                  flex: 4,
                ),
              ),
            )
          ],
        ));
  }
}

class tooth_health_news extends StatelessWidget {
  const tooth_health_news({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ListView(
      children: [
        photos(
          adrs: "assets/images/tooth/001.png",
        ),
        photos(
          adrs: "assets/images/tooth/002.png",
        ),
        photos(
          adrs: "assets/images/tooth/003.png",
        ),
        photos(
          adrs: "assets/images/tooth/004.png",
        ),
        photos(
          adrs: "assets/images/tooth/005.png",
        ),
        photos(
          adrs: "assets/images/tooth/006.png",
        ),
      ],
    );
  }
}

class pet_behave_news extends StatelessWidget {
  const pet_behave_news({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ListView(
      children: [
        photos(
          adrs: "assets/images/behave_news/001.png",
        ),
        photos(
          adrs: "assets/images/behave_news/002.png",
        ),
        photos(
          adrs: "assets/images/behave_news/003.png",
        ),
        photos(
          adrs: "assets/images/behave_news/004.png",
        ),
        photos(
          adrs: "assets/images/behave_news/005.png",
        ),
        photos(
          adrs: "assets/images/behave_news/006.png",
        ),
      ],
    );
  }
}

class food_ad extends StatelessWidget {
  const food_ad({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ListView(
      children: [
        photos(
          adrs: "assets/images/food_ad/001.png",
        ),
        photos(
          adrs: "assets/images/food_ad/002.png",
        ),
        photos(
          adrs: "assets/images/food_ad/003.png",
        ),
        photos(
          adrs: "assets/images/food_ad/004.png",
        ),
        photos(
          adrs: "assets/images/food_ad/005.png",
        ),
        photos(
          adrs: "assets/images/food_ad/006.png",
        ),
      ],
    );
  }
}

class salon_ad extends StatelessWidget {
  const salon_ad({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ListView(
      children: [
        photos(
          adrs: "assets/images/salon_ad/001.jpg",
        ),
        photos(
          adrs: "assets/images/salon_ad/002.jpg",
        ),
        photos(
          adrs: "assets/images/salon_ad/003.jpg",
        ),
        photos(
          adrs: "assets/images/salon_ad/004.jpg",
        ),
      ],
    );
  }
}

class photos extends StatelessWidget {
  const photos({Key? key, this.adrs}) : super(key: key);
  final adrs;

  @override
  Widget build(BuildContext context) {
    return Container(
      child: Image.asset(adrs),
    );
  }
}
