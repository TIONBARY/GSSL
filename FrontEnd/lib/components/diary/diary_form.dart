import 'package:GSSL/api/api_diary.dart';
import 'package:GSSL/components/community/widgets/my_box_widget.dart';
import 'package:GSSL/components/diary/diary_detail_form.dart';
import 'package:GSSL/components/util/custom_dialog.dart';
import 'package:GSSL/constants.dart';
import 'package:GSSL/model/response_models/get_journal_list.dart';
import 'package:GSSL/pages/login_page.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:image_picker/image_picker.dart';

XFile? _image;
final picker = ImagePicker();
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

class DiaryPage extends StatefulWidget {
  const DiaryPage({Key? key}) : super(key: key);

  @override
  State<DiaryPage> createState() => _DiaryPageState();
}

class _DiaryPageState extends State<DiaryPage> {
  List<Content> _aidList = [];

  ApiDiary apiDiary = ApiDiary();

  bool _hasMore = true;
  int _pageNumber = 0;
  bool _error = false;
  bool _loading = true;
  final int _pageSize = 10;
  final int _nextPageThreshold = 5;

  List<int> selectedArticles = [];
  List<int> selectedJournalIds = [];
  bool selectionMode = false;

  String S3Address = "https://a204drdoc.s3.ap-northeast-2.amazonaws.com/";
  AssetImage basic_image = AssetImage("assets/images/basic_dog.png");

  Future<void> _getList(int page, int size) async {
    getJournalList result = await apiDiary.getAllJournalApi(page, size);
    if (result.statusCode == 200) {
      setState(() {
        _hasMore = result.journalList!.content!.length == _pageSize;
        _loading = false;
        _pageNumber = _pageNumber + 1;
        _aidList.addAll(result.journalList!.content!);
      });
    } else if (result.statusCode == 401) {
      showDialog(
          context: context,
          builder: (BuildContext context) {
            return CustomDialog("로그인이 필요합니다.", (context) => LoginScreen());
          });
      setState(() {
        _loading = false;
        _error = true;
      });
    } else {
      showDialog(
          context: context,
          builder: (BuildContext context) {
            return CustomDialog(result.message!, null);
          });
      setState(() {
        _loading = false;
        _error = true;
      });
    }
  }

  // Future getImage(ImageSource imageSource) async {
  //   final image = await picker.pickImage(source: imageSource, imageQuality: 50);
  //
  //   setState(() {
  //     _image = XFile(image!.path); // 가져온 이미지를 _image에 저장
  //   });
  // }
  //
  //
  //
  // Widget showImage() {
  //   return Container(
  //       color: const Color(0xffd0cece),
  //       width: MediaQuery.of(context).size.width,
  //       height: MediaQuery.of(context).size.width,
  //       child: Center(
  //           child: _image == null
  //               ? Text('이미지를 촬영/선택 해주세요')
  //               : Image.file(File(_image!.path))));
  // }
  void enterIntoArticle(int index) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => DetailsPage(
          _aidList[index].journalId!,
          index,
        ),
      ),
    );
  }

  void selectArticle(int index) {
    if (selectedArticles.contains(index)) {
      selectedArticles.remove(index);
    } else {
      selectedArticles.add(index);
    }
    setState(() {
      selectedArticles = selectedArticles;
      if (selectedArticles.isNotEmpty) {
        selectionMode = true;
      } else {
        selectionMode = false;
      }
    });
    // 새로고침
    print(selectedArticles);
    setState(() {});
  }

  @override
  void initState() {
    super.initState();
    _getList(_pageNumber, _pageSize);
  }

  late Size _size;
  @override
  Widget build(BuildContext context) {
    _size = MediaQuery.of(context).size;
    if (_loading) {
      return Scaffold(
          body: SafeArea(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Expanded(
                child: Container(
              padding: EdgeInsets.fromLTRB(10.w, 10.h, 10.w, 10.h),
              decoration: BoxDecoration(
                color: Colors.white,
                image: DecorationImage(
                    fit: BoxFit.contain,
                    image: AssetImage("assets/images/loadingDog.gif")),
              ),
            ))
          ],
        ),
      ));
    } else {
      return Scaffold(
        body: _aidList.isNotEmpty
            ? SafeArea(
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
                          padding: EdgeInsets.fromLTRB(15.w, 15.h, 15.w, 15.h),
                          decoration: BoxDecoration(
                            color: nWColor,
                          ),
                          child: Stack(children: [
                            GridView.builder(
                              gridDelegate:
                                  SliverGridDelegateWithFixedCrossAxisCount(
                                crossAxisCount: 3,
                                crossAxisSpacing: 10,
                                mainAxisSpacing: 10,
                              ),
                              itemBuilder: (context, index) {
                                if (_hasMore &&
                                    index ==
                                        _aidList.length - _nextPageThreshold) {
                                  _getList(_pageNumber, _pageSize);
                                }
                                if (index == _aidList.length) {
                                  if (_error) {
                                    return Center(
                                        child: InkWell(
                                      onTap: () {
                                        setState(() {
                                          _loading = true;
                                          _error = false;
                                          _getList(_pageNumber, _pageSize);
                                        });
                                      },
                                      child: Padding(
                                        padding: const EdgeInsets.all(16),
                                        child:
                                            Text("에러가 발생했습니다. 터치하여 다시 시도해주세요."),
                                      ),
                                    ));
                                  } else {
                                    return Center(
                                        child: Padding(
                                      padding: const EdgeInsets.all(8),
                                      child: CircularProgressIndicator(),
                                    ));
                                  }
                                }
                                return RawMaterialButton(
                                    onLongPress: () {
                                      if (selectionMode) {
                                        enterIntoArticle(index);
                                      } else {
                                        selectArticle(index);
                                      }
                                    },
                                    onPressed: () {
                                      if (!selectionMode) {
                                        enterIntoArticle(index);
                                      } else {
                                        selectArticle(index);
                                      }
                                    },
                                    child: Hero(
                                        tag: 'logo$index',
                                        child: Stack(children: [
                                          Container(
                                            decoration: BoxDecoration(
                                              borderRadius:
                                                  BorderRadius.circular(10),
                                              boxShadow: [
                                                BoxShadow(
                                                  color: Colors.grey
                                                      .withOpacity(0.7),
                                                  blurRadius: 7,
                                                  offset: Offset(3, 3),
                                                ),
                                              ],
                                              image: _aidList[index]?.picture ==
                                                          null ||
                                                      _aidList[index]!
                                                              .picture!
                                                              .length! ==
                                                          0
                                                  ? DecorationImage(
                                                      image: basic_image,
                                                      fit: BoxFit.cover,
                                                    )
                                                  : DecorationImage(
                                                      image: NetworkImage(
                                                          S3Address +
                                                              _aidList[index]!
                                                                  .picture!),
                                                      fit: BoxFit.cover,
                                                    ),
                                            ),
                                          ),
                                          (selectionMode)
                                              ? Theme(
                                                  data: Theme.of(context)
                                                      .copyWith(
                                                    unselectedWidgetColor:
                                                        nWColor,
                                                  ),
                                                  child: Checkbox(
                                                    activeColor: btnColor,
                                                    shape: const RoundedRectangleBorder(
                                                        borderRadius:
                                                            BorderRadius.all(
                                                                Radius.circular(
                                                                    5.0))),
                                                    // Rounded Checkbox
                                                    value: selectedArticles
                                                        .contains(index),
                                                    onChanged: (inputValue) {
                                                      setState(() {
                                                        // selectedArticles = [];
                                                      });
                                                    },
                                                  ))
                                              : Container(),
                                        ])));
                              },
                              itemCount: _aidList.length,
                            ),
                            Positioned(
                              right: 0.w,
                              bottom: 0.h,
                              child: (selectedArticles.isNotEmpty)
                                  ? FloatingActionButton(
                                      child: Icon(Icons.delete),
                                      elevation: 5,
                                      hoverElevation: 10,
                                      tooltip: "선택된 항목 삭제",
                                      backgroundColor: Colors.red,
                                      onPressed: () {
                                        // debugPrint("삭제");
                                        selectedArticles.forEach((e) =>
                                            selectedJournalIds
                                                .add(_aidList[e].journalId!));
                                        // 삭제 요청 전송;
                                        print(selectedJournalIds);
                                        apiDiary
                                            .deleteAllAPI(selectedJournalIds);
                                        // 선택 리스트 비우기
                                        setState(() {
                                          selectedArticles = [];
                                          selectedJournalIds = [];
                                          selectionMode = false;
                                        });
                                        // 새로고침
                                        setState(() {
                                          _aidList = [];
                                          _hasMore = true;
                                          _pageNumber = 0;
                                          _error = false;
                                          _loading = true;
                                        });
                                        _getList(_pageNumber, _pageSize);
                                      })
                                  : Container(),
                            ),
                          ])),
                    ),
                  ],
                ),
              )
            : Center(
                child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Image.asset('assets/images/no_data.png'),
                  MyBoxWidget(
                    height: 5,
                  ),
                  const Text('작성한 일지가 없습니다.'),
                ],
              )),
        // floatingActionButton: _buildAddNoteFAB(),
      );
    }
  }

  // 갤러리에서 사진 추가 + 버튼
  // Widget _buildAddNoteFAB() {
  //   return TweenAnimationBuilder<Offset>(
  //     duration: const Duration(seconds: 2),
  //     tween: Tween<Offset>(
  //       begin: const Offset(0, -800),
  //       end: const Offset(0, 0),
  //     ),
  //     curve: Curves.bounceOut,
  //     builder: (context, Offset offset, child) {
  //       return Transform.translate(
  //         offset: offset,
  //         child: child,
  //       );
  //     },
  //     child: FloatingActionButton(
  //       onPressed: () {
  //         getImage(ImageSource.gallery);
  //       },
  //       backgroundColor: AppColors.white,
  //       child: Icon(
  //         Icons.add,
  //         color: AppColors.codGray,
  //         size: _size.width * 0.08,
  //       ),
  //     ),
  //   );
  // }

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
