import 'dart:async';

import 'package:GSSL/api/api_community.dart';
import 'package:GSSL/api/api_user.dart';
import 'package:GSSL/components/bottomNavBar.dart';
import 'package:GSSL/components/community/widgets/icon_button_widget.dart';
import 'package:GSSL/components/util/custom_dialog.dart';
import 'package:GSSL/constants.dart';
import 'package:GSSL/model/response_models/get_board_detail.dart';
import 'package:GSSL/model/response_models/user_info.dart';
import 'package:GSSL/pages/login_page.dart';
import 'package:flutter/material.dart';

class BoardDetailPage extends StatefulWidget {
  int boardId;
  BoardDetailPage(this.boardId);

  @override
  State<BoardDetailPage> createState() => _BoardDetailPageState();
}

class _BoardDetailPageState extends State<BoardDetailPage>
    with TickerProviderStateMixin {
  TextEditingController searchController = TextEditingController();
  Board? board;
  late Size _size;
  User? user;
  String S3Address = "https://a204drdoc.s3.ap-northeast-2.amazonaws.com/";
  ApiCommunity apiCommunity = ApiCommunity();
  ApiUser apiUser = ApiUser();

  Timer? _debounce;

  Future<void> getUser() async {
    userInfo? userInfoResponse = await apiUser.getUserInfo();
    if (userInfoResponse.statusCode == 200) {
      setState(() {
        user = userInfoResponse.user;
      });
    } else if (userInfoResponse.statusCode == 401) {
      showDialog(
          context: context,
          builder: (BuildContext context) {
            return CustomDialog("로그인이 필요합니다.", (context) => LoginScreen());
          });
    } else {
      showDialog(
          context: context,
          builder: (BuildContext context) {
            return CustomDialog(
                userInfoResponse.message == null
                    ? "알 수 없는 오류가 발생했습니다."
                    : userInfoResponse.message!,
                (context) => BottomNavBar());
          });
    }
  }

  void _getBoardDetail() async {
    getBoardDetail result =
        await apiCommunity.getBoardDetailApi(widget.boardId);
    if (result.statusCode == 200) {
      setState(() {
        board = result.board;
      });
    } else if (result.statusCode == 401) {
      showDialog(
          context: context,
          builder: (BuildContext context) {
            return CustomDialog("로그인이 필요합니다.", (context) => LoginScreen());
          });
    } else {
      showDialog(
          context: context,
          builder: (BuildContext context) {
            return CustomDialog(result.message!, null);
          });
    }
    // final data = await dbHelper.queryAllRows(tableContent);
    // setState(() {
    //   _aidList = data;
    // });
  }

  @override
  void initState() {
    super.initState();
    _getBoardDetail();
    getUser();
  }

  @override
  Widget build(BuildContext context) {
    _size = MediaQuery.of(context).size;
    return Scaffold(
      appBar: AppBar(
        iconTheme: IconThemeData(
          color: btnColor,
          size: 20,
        ),
        toolbarHeight: 50,
        backgroundColor: pColor,
        title: Text(
          board?.typeId != null && board!.typeId! == 1
              ? "반려견 자랑하기"
              : (board?.typeId != null && board!.typeId! == 2
                  ? "반려견 진단공유"
                  : (board?.typeId != null && board!.typeId! == 3
                      ? "질문하기"
                      : "")),
          style: TextStyle(
            color: Colors.black,
            fontSize: 20,
          ),
        ),
        leading: IconButtonWidget(
            iconData: Icons.arrow_back_sharp,
            onTap: () => Navigator.of(context).pop(false)),
      ),
      body: Container(
          margin: EdgeInsets.fromLTRB(
              MediaQuery.of(context).size.width / 10,
              MediaQuery.of(context).size.height / 30,
              MediaQuery.of(context).size.width / 10,
              MediaQuery.of(context).size.height / 10),
          child: Column(children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(board?.title == null ? "" : board!.title!,
                    style: TextStyle(fontSize: 25)),
              ],
            ),
            Padding(
                padding: EdgeInsets.fromLTRB(
                    0,
                    MediaQuery.of(context).size.height / 40,
                    0,
                    MediaQuery.of(context).size.height / 40),
                child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(board?.nickname == null ? "" : board!.nickname!),
                      Text(board?.time == null
                          ? ""
                          : board!.time!.split("T")[0] +
                              " " +
                              board!.time!.split("T")[1].substring(0, 8))
                    ])),
            Container(
              // color: const Color(0xffd0cece),
              padding: EdgeInsets.fromLTRB(
                  0, 0, 0, MediaQuery.of(context).size.height / 40),
              child: Center(
                  child: board?.image == null
                      ? Text('')
                      : SizedBox(
                          child: Image.network(
                          S3Address + board!.image!,
                        ))),
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                Text(board?.content == null ? "" : board!.content!,
                    style: TextStyle(fontSize: 20)),
              ],
            ),
          ])),
    );
  }

  @override
  void dispose() {
    searchController.dispose();
    super.dispose();
  }
}
