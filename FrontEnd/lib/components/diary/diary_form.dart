import 'package:GSSL/components/diary/diary_detail_form.dart';
import 'package:GSSL/constants.dart';
import 'package:flutter/material.dart';

List<ImageDetails> _images = [
  // ImageDetails(
  //   imagePath: 'assets/images/1.png',
  //   disease: '\안검염',
  //   date: '2022년 9월 26일',
  //   title: '첫 검사',
  //   details:
  //       '오늘 뽀롱이가 많이 아팠다. 눈을 박박 긁어서 첫 진단을 해보니 암검염이라고 판정됬다. 근처 동물 병원을 가서 치료를 받았다.',
  // ),
  // ImageDetails(
  //   imagePath: 'assets/images/2.png',
  //   disease: '\각막염',
  //   date: '2022년 8월 18일',
  //   title: '조심 또 조심',
  //   details: '뽀롱이가 각막염에 걸렸다. 실명위기 까지 갔었는데 조기 치료해서 다행이다.',
  // ),
  // ImageDetails(
  //   imagePath: 'assets/images/3.png',
  //   disease: '\눈병',
  //   date: '2022년 4월 13일',
  //   title: '눈이 빨개진 뽀롱이',
  //   details: '눈이 빨개져서 1차 진단을 해보니 심각하지않은 눈병에 걸린 뽀롱이였다.',
  // ),
  ImageDetails(
    imagePath: 'assets/images/4.png',
    disease: '\건강',
    date: '2022년 7월 13일',
    title: '회복을 한 뽀롱이',
    details: '아팠던 뽀롱이가 다시 살아났다.',
  ),
  ImageDetails(
    imagePath: 'assets/images/5.png',
    disease: '\녹내장',
    date: '2022년 9월 28일',
    title: '눈약 넣는 뽀롱이',
    details: '동물 병원에서 눈약을 처방받아서 오늘 넣어주었다.',
  ),
  ImageDetails(
    imagePath: 'assets/images/1.png',
    disease: '\안검염',
    date: '2022년 9월 26일',
    title: '첫 검사',
    details:
        '오늘 뽀롱이가 많이 아팠다. 눈을 박박 긁어서 첫 진단을 해보니 암검염이라고 판정됬다. 근처 동물 병원을 가서 치료를 받았다.',
  ),
  ImageDetails(
    imagePath: 'assets/images/4.png',
    disease: '\건강',
    date: '2022년 7월 13일',
    title: '회복을 한 뽀롱이',
    details: '아팠던 뽀롱이가 다시 살아났다.',
  ),
  ImageDetails(
    imagePath: 'assets/images/5.png',
    disease: '\녹내장',
    date: '2022년 9월 28일',
    title: '눈약 넣는 뽀롱이',
    details: '동물 병원에서 눈약을 처방받아서 오늘 넣어주었다.',
  ),
  ImageDetails(
    imagePath: 'assets/images/4.png',
    disease: '\건강',
    date: '2022년 7월 13일',
    title: '회복을 한 뽀롱이',
    details: '아팠던 뽀롱이가 다시 살아났다.',
  ),
  ImageDetails(
    imagePath: 'assets/images/5.png',
    disease: '\녹내장',
    date: '2022년 9월 28일',
    title: '눈약 넣는 뽀롱이',
    details: '동물 병원에서 눈약을 처방받아서 오늘 넣어주었다.',
  ),
];

class DiaryPage extends StatelessWidget {
  const DiaryPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: <Widget>[
          // Padding(
          //   padding: const EdgeInsets.all(8),
          //   child: TextFormField(
          //     cursorColor: btnColor,
          //     decoration: InputDecoration(
          //       prefixIcon: Icon(Icons.search, color: sColor),
          //       hintText: "검색",
          //       hintStyle: TextStyle(color: sColor),
          //       contentPadding: EdgeInsets.fromLTRB(20, 17.5, 10, 17.5),
          //
          //       enabledBorder: OutlineInputBorder(
          //           borderRadius: BorderRadius.all(Radius.circular(10)),
          //           borderSide: BorderSide(color: sColor)
          //       ),
          //       filled: true,
          //       fillColor: nWColor,
          //       focusedBorder: OutlineInputBorder(
          //           borderRadius: BorderRadius.all(Radius.circular(10)),
          //           borderSide: BorderSide(color: btnColor)
          //       ),
          //     ),
          //   ),
          // ),
          Expanded(
            child: Container(
              padding: EdgeInsets.fromLTRB(15, 10, 15, 10),
              decoration: BoxDecoration(
                color: nWColor,
              ),
              child: GridView.builder(
                gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 3,
                  crossAxisSpacing: 10,
                  mainAxisSpacing: 10,
                ),
                itemBuilder: (context, index) {
                  return RawMaterialButton(
                    onPressed: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => DetailsPage(
                            imagePath: _images[index].imagePath,
                            title: _images[index].title,
                            date: _images[index].date,
                            disease: _images[index].disease,
                            details: _images[index].details,
                            index: index,
                          ),
                        ),
                      );
                    },
                    child: Hero(
                      tag: 'logo$index',
                      child: Container(
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(10),
                          boxShadow: [
                            BoxShadow(
                              color: Colors.grey.withOpacity(0.7),
                              blurRadius: 7,
                              offset: Offset(3, 3),
                            ),
                          ],
                          image: DecorationImage(
                            image: AssetImage(_images[index].imagePath),
                            fit: BoxFit.cover,
                          ),
                        ),
                      ),
                    ),
                  );
                },
                itemCount: _images.length,
              ),
            ),
          )
        ],
      ),
    );
  }
}

class ImageDetails {
  final String imagePath;
  final String disease;
  final String date;
  final String title;
  final String details;

  ImageDetails({
    required this.imagePath,
    required this.disease,
    required this.date,
    required this.title,
    required this.details,
  });
}
