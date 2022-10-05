import 'package:GSSL/api/api_diary.dart';
import 'package:GSSL/api/api_pet.dart';
import 'package:GSSL/components/util/custom_dialog.dart';
import 'package:GSSL/constants.dart';
import 'package:GSSL/model/response_models/detail_pet_journal.dart';
import 'package:GSSL/model/response_models/get_pet_detail.dart';
import 'package:GSSL/pages/login_page.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class DetailsPage extends StatefulWidget {
  int journalId;
  int index;
  DetailsPage(this.journalId, this.index);

  @override
  State<DetailsPage> createState() => _DiaryPageState();
}

class _DiaryPageState extends State<DetailsPage> {
  ApiDiary apiDiary = ApiDiary();
  ApiPet apiPet = ApiPet();

  bool _loadingJournal = true;
  bool _loadingPet = true;
  bool _error = false;

  JournalDetail? detail;
  Pet? pet;

  String S3Address = "https://a204drdoc.s3.ap-northeast-2.amazonaws.com/";
  AssetImage basic_image = AssetImage("assets/images/basic_dog.png");

  Future<void> _getJournal() async {
    detailPetJournal result =
        await apiDiary.getJournalDetailApi(widget.journalId);
    if (result.statusCode == 200) {
      setState(() {
        _loadingJournal = false;
        detail = result.detail;
      });
      _getPet(detail!.petId!);
    } else if (result.statusCode == 401) {
      showDialog(
          context: context,
          builder: (BuildContext context) {
            return CustomDialog("로그인이 필요합니다.", (context) => LoginScreen());
          });
      setState(() {
        _loadingJournal = false;
        _error = true;
      });
    } else {
      showDialog(
          context: context,
          builder: (BuildContext context) {
            return CustomDialog(result.message!, null);
          });
      setState(() {
        _loadingJournal = false;
        _error = true;
      });
    }
  }

  Future<void> _getPet(int petId) async {
    getPetDetail result = await apiPet.getPetDetailApi(petId);
    if (result.statusCode == 200) {
      setState(() {
        _loadingPet = false;
        pet = result.pet;
      });
    } else if (result.statusCode == 401) {
      showDialog(
          context: context,
          builder: (BuildContext context) {
            return CustomDialog("로그인이 필요합니다.", (context) => LoginScreen());
          });
      setState(() {
        _loadingPet = false;
        _error = true;
      });
    } else {
      showDialog(
          context: context,
          builder: (BuildContext context) {
            return CustomDialog(result.message!, null);
          });
      setState(() {
        _loadingPet = false;
        _error = true;
      });
    }
  }

  @override
  void initState() {
    super.initState();
    _getJournal();
  }

  @override
  Widget build(BuildContext context) {
    if (_loadingJournal || _loadingPet) {
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
        body: Container(
          child: Column(
            children: <Widget>[
              Expanded(
                child: Hero(
                  tag: 'logo$widget.index',
                  child: Container(
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.only(
                          bottomLeft: Radius.circular(30),
                          bottomRight: Radius.circular(30)),
                      image: detail?.picture == null ||
                              detail?.picture!.length! == 0
                          ? DecorationImage(
                              image: basic_image,
                              fit: BoxFit.cover,
                            )
                          : DecorationImage(
                              image: NetworkImage(S3Address + detail!.picture!),
                              fit: BoxFit.cover,
                            ),
                    ),
                  ),
                ),
              ),
              Container(
                height: 250.h,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: <Widget>[
                    Padding(
                      padding: EdgeInsets.fromLTRB(20.w, 15.h, 20.w, 0),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: <Widget>[
                          Text(
                            pet?.name == null ? '' : pet!.name! + '의 진단 결과',
                            style: TextStyle(
                                color: btnColor,
                                fontSize: 25.sp,
                                fontWeight: FontWeight.w500,
                                fontFamily: "Daehan"),
                          ),
                          Text(
                            detail?.createdDate == null
                                ? ''
                                : detail!.createdDate!.split("T")[0] +
                                    " " +
                                    detail!.createdDate!.split("T")[1],
                            style: TextStyle(
                                fontSize: 12.5.sp,
                                fontFamily: "Daehan",
                                color: sColor),
                          ),
                          SizedBox(
                            height: 25.h,
                          ),
                          Text(
                            detail?.result == null
                                ? '진단 결과가 없습니다.'
                                : '진단 결과 : ' + detail!.result!,
                            style: TextStyle(
                                color: btnColor,
                                fontSize: 20.sp,
                                fontWeight: FontWeight.w300,
                                fontFamily: "Daehan"),
                          ),
                          Text(
                            detail?.symptom == null
                                ? ''
                                : '증상 : ' + detail!.symptom!,
                            style: TextStyle(
                                color: Colors.redAccent,
                                fontSize: 20.sp,
                                fontWeight: FontWeight.w300,
                                fontFamily: "Daehan"),
                          ),
                        ],
                      ),
                    ),
                    Row(
                      children: <Widget>[
                        Expanded(
                          child: TextButton(
                            onPressed: () {
                              Navigator.pop(context);
                            },
                            style: TextButton.styleFrom(
                              padding: EdgeInsets.symmetric(vertical: 10.h),
                              foregroundColor: btnColor,
                              backgroundColor: btnColor,
                            ),
                            child: Text(
                              '뒤로가기',
                              style: TextStyle(
                                  color: nWColor,
                                  fontFamily: "Daehan",
                                  fontSize: 15.sp),
                            ),
                          ),
                        ),
                        SizedBox(
                          width: 0,
                        ),
                        // Expanded(
                        //   child: TextButton(
                        //     onPressed: () {},
                        //     style: TextButton.styleFrom(
                        //       padding: EdgeInsets.symmetric(vertical: 15),
                        //       foregroundColor: Colors.lightBlueAccent,
                        //     ),
                        //     child: Text(
                        //       'Buy',
                        //       style: TextStyle(
                        //         color: Colors.white,
                        //       ),
                        //     ),
                        //   ),
                        // ),
                      ],
                    )
                  ],
                ),
              ),
            ],
          ),
        ),
      );
    }
  }
}
