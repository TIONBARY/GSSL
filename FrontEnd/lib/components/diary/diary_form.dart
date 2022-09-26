import 'package:flutter/material.dart';
import 'package:GSSL/components/diary/diary_detail_form.dart';

List<ImageDetails> _images = [
  ImageDetails(
    imagePath: 'assets/images/1.png',
    disease: '\안검염',
    date: '2022년 9월 26일',
    title: '첫 검사',
    details:
    '오늘 뽀롱이가 많이 아팠다. 눈을 박박 긁어서 첫 진단을 해보니 암검염이라고 판정됬다. 근처 동물 병원을 가서 치료를 받았다.',
  ),
  ImageDetails(
    imagePath: 'assets/images/2.png',
    disease: '\각막염',
    date: '2022년 8월 18일',
    title: '조심 또 조심',
    details:
    '뽀롱이가 각막염에 걸렸다. 실명위기 까지 갔었는데 조기 치료해서 다행이다.',
  ),
  ImageDetails(
    imagePath: 'assets/images/3.png',
    disease: '\눈병',
    date: '2022년 4월 13일',
    title: '눈이 빨개진 뽀롱이',
    details:
    '눈이 빨개져서 1차 진단을 해보니 심각하지않은 눈병에 걸린 뽀롱이였다.',
  ),
  ImageDetails(
    imagePath: 'assets/images/4.png',
    disease: '\건강',
    date: '2022년 7월 13일',
    title: '회복을 한 뽀롱이',
    details:
    '아팠던 뽀롱이가 다시 살아났다.',
  ),
  ImageDetails(
    imagePath: 'assets/images/5.png',
    disease: '\녹내장',
    date: '2022년 9월 28일',
    title: '눈약 넣는 뽀롱이',
    details:
    '동물 병원에서 눈약을 처방받아서 오늘 넣어주었다.',
  ),
  ImageDetails(
    imagePath: 'assets/images/6.png',
    disease: '\녹내장',
    date: '2022년 9월 29일',
    title: '재발된 눈병',
    details:
    '약을 처방받아서 치료를 해주었는데 눈병이 다시 생겼다.',
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
          // SizedBox(
          //   height: 40,
          // ),
          // Text(
          //   'Gallery',
          //   style: TextStyle(
          //     fontSize: 25,
          //     fontWeight: FontWeight.w600,
          //     color: Colors.white,
          //   ),
          //   textAlign: TextAlign.center,
          // ),
          // SizedBox(
          //   height: 40,
          // ),
          TextField(
            decoration: InputDecoration(
                prefixIcon: Icon(Icons.search, color: Colors.black),
                hintText: "Search for an Image",
                border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(8.0)
                )
            ),
          ),
          SizedBox(height: 24.0,),
          Expanded(
            child: Container(
              padding: EdgeInsets.symmetric(
                horizontal: 20,
                vertical: 30,
              ),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(30),
                  topRight: Radius.circular(30),
                ),
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
                          borderRadius: BorderRadius.circular(15),
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