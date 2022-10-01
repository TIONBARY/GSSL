import 'dart:async';

import 'package:GSSL/api/api_comment.dart';
import 'package:GSSL/api/api_community.dart';
import 'package:GSSL/api/api_user.dart';
import 'package:GSSL/components/bottomNavBar.dart';
import 'package:GSSL/components/community/widgets/icon_button_widget.dart';
import 'package:GSSL/components/util/custom_dialog.dart';
import 'package:GSSL/constants.dart';
import 'package:GSSL/model/request_models/put_comment.dart';
import 'package:GSSL/model/response_models/general_response.dart';
import 'package:GSSL/model/response_models/get_board_detail.dart';
import 'package:GSSL/model/response_models/get_comment_list.dart';
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
  final formKey = GlobalKey<FormState>();
  TextEditingController searchController = TextEditingController();
  Board? board;
  List<Comment> comments = List.empty();
  late Size _size;
  User? user;
  String S3Address = "https://a204drdoc.s3.ap-northeast-2.amazonaws.com/";
  ApiCommunity apiCommunity = ApiCommunity();
  ApiUser apiUser = ApiUser();
  ApiComment apiComment = ApiComment();

  final TextEditingController commentController = TextEditingController();

  AssetImage basic_image = AssetImage("assets/images/user.png");

  String? commentContent;

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

  Future<void> _getComments() async {
    getComments result = await apiComment.getCommentsApi(widget.boardId);
    if (result.statusCode == 200) {
      setState(() {
        comments = result.comments!;
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
  }

  void _writeComment() async {
    // set this variable to true when we try to submit
    generalResponse result = await apiComment.writeCommentAPI(
        putComment(boardId: widget.boardId, content: commentContent));
    if (result.statusCode == 201) {
      _getComments();
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
  }

  @override
  void initState() {
    super.initState();
    _getBoardDetail();
    getUser();
    _getComments();
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
              0),
          child: ListView(children: [
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
            Padding(
              padding: const EdgeInsets.fromLTRB(0, 25, 0, 0),
              child: TextFormField(
                keyboardType: TextInputType.text,
                textInputAction: TextInputAction.next,
                cursorColor: btnColor,
                onChanged: (val) {
                  commentContent = val;
                },
                validator: (text) {
                  if (text == null || text.isEmpty) {
                    return '댓글을 입력해주세요.';
                  }
                  return null;
                },
                decoration: InputDecoration(
                  isCollapsed: true,
                  hintText: "댓글을 입력하세요.",
                  hintStyle: TextStyle(color: sColor),
                  contentPadding: EdgeInsets.fromLTRB(20, 10, 10, 10),
                  enabledBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.all(Radius.circular(10)),
                      borderSide: BorderSide(color: Colors.white)),
                  filled: true,
                  fillColor: Colors.white,
                  focusedBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.all(Radius.circular(10)),
                      borderSide: BorderSide(color: btnColor)),
                  suffix: ElevatedButton(
                    onPressed: () {
                      _writeComment();
                    },
                    style: ElevatedButton.styleFrom(
                      padding: EdgeInsets.all(0),
                      backgroundColor: btnColor,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(5.0),
                      ),
                      tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                    ),
                    child: Text(
                      "등록".toUpperCase(),
                    ),
                  ),
                ),
              ),
            ),
            comments.length == 0
                ? Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Container(
                          padding: EdgeInsets.fromLTRB(
                              0, MediaQuery.of(context).size.height / 10, 0, 0),
                          child: Text("댓글이 없습니다."))
                    ],
                  )
                : ListView(
                    scrollDirection: Axis.vertical,
                    shrinkWrap: true,
                    children: [
                        for (int i = 0; i < comments.length; i++)
                          Padding(
                            padding:
                                const EdgeInsets.fromLTRB(2.0, 8.0, 2.0, 0.0),
                            child: ListTile(
                              leading: GestureDetector(
                                onTap: () async {
                                  // Display the image in large form.
                                  print("Comment Clicked");
                                },
                                child: Container(
                                  height: 50.0,
                                  width: 50.0,
                                  decoration: new BoxDecoration(
                                      color: Colors.blue,
                                      borderRadius: new BorderRadius.all(
                                          Radius.circular(50))),
                                  child: comments[i].image == null ||
                                          comments[i].image!.length! == 0
                                      ? CircleAvatar(
                                          radius: 50,
                                          backgroundImage: basic_image)
                                      : CircleAvatar(
                                          radius: 50,
                                          backgroundImage: NetworkImage(
                                              S3Address + comments[i].image!)),
                                ),
                              ),
                              title: Text(
                                comments[i].nickname == null
                                    ? ""
                                    : comments[i].nickname!,
                                style: TextStyle(fontWeight: FontWeight.bold),
                              ),
                              subtitle: Text(comments[i].content == null
                                  ? ""
                                  : comments[i].content!),
                            ),
                          )
                      ]),
          ])),
    );
  }

  @override
  void dispose() {
    searchController.dispose();
    super.dispose();
  }
}
