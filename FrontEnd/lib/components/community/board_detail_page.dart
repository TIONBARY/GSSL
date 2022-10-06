import 'dart:async';

import 'package:GSSL/api/api_comment.dart';
import 'package:GSSL/api/api_community.dart';
import 'package:GSSL/api/api_user.dart';
import 'package:GSSL/components/bottomNavBar.dart';
import 'package:GSSL/components/community/widgets/icon_button_widget.dart';
import 'package:GSSL/components/util/custom_dialog.dart';
import 'package:GSSL/constants.dart';
import 'package:GSSL/model/request_models/put_comment.dart';
import 'package:GSSL/model/request_models/update_comment.dart';
import 'package:GSSL/model/response_models/general_response.dart';
import 'package:GSSL/model/response_models/get_board_detail.dart';
import 'package:GSSL/model/response_models/get_comment_list.dart';
import 'package:GSSL/model/response_models/user_info.dart';
import 'package:GSSL/pages/login_page.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

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

  bool _boardLoading = true;
  bool _commentLoading = true;

  final TextEditingController commentController = TextEditingController();
  final TextEditingController modifyCommentController = TextEditingController();

  AssetImage basic_image = AssetImage("assets/images/user.png");

  String? commentContent;

  String? modifyCommentContent;

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
      _boardLoading = false;
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
      _commentLoading = false;
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
      commentController.text = "";
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

  void _modifyComment(int? commentId) async {
    // set this variable to true when we try to submit
    generalResponse result = await apiComment.modifyCommentAPI(
        commentId, updateComment(content: modifyCommentContent));
    if (result.statusCode == 200) {
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

  void _deleteComment(int? commentId) async {
    // set this variable to true when we try to submit
    generalResponse result = await apiComment.deleteAPI(commentId);
    if (result.statusCode == 200) {
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
    if (_boardLoading || _commentLoading) {
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
        appBar: AppBar(
          centerTitle: true,
          iconTheme: IconThemeData(
            color: btnColor,
            size: 20.sp,
          ),
          toolbarHeight: 50,
          backgroundColor: pColor,
          titleTextStyle: TextStyle(
            fontFamily: "Sub",
            fontSize: 20.sp,
            color: btnColor,
          ),
          title: Text(
            board?.typeId != null && board!.typeId! == 1
                ? "반려견 자랑하기"
                : (board?.typeId != null && board!.typeId! == 2
                    ? "반려견 진단공유"
                    : (board?.typeId != null && board!.typeId! == 3
                        ? "질문하기"
                        : "")),
          ),
          leading: IconButtonWidget(
              color: btnColor,
              iconData: Icons.arrow_back_sharp,
              iconColor: nWColor,
              onTap: () => Navigator.of(context).pop(false)),
        ),
        backgroundColor: nWColor,
        body: Container(
            margin: EdgeInsets.fromLTRB(25.w, 20.h, 25.w, 20.h),
            child: ListView(children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(board?.title == null ? "" : board!.title!,
                      style: TextStyle(fontSize: 25.sp, fontFamily: "Sub")),
                ],
              ),
              Padding(
                  padding: EdgeInsets.fromLTRB(0, 10.h, 0, 10.h),
                  child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          board?.nickname == null
                              ? ""
                              : '작성자 : ' + board!.nickname!,
                          style: TextStyle(fontFamily: "Sub", color: sColor),
                        ),
                        Text(
                          board?.time == null
                              ? ""
                              : board!.time!.split("T")[0] +
                                  " " +
                                  board!.time!.split("T")[1].substring(0, 8),
                          style: TextStyle(fontFamily: "Sub"),
                        )
                      ])),
              Container(
                padding: EdgeInsets.fromLTRB(0, 0, 0, 20.h),
                decoration:
                    BoxDecoration(borderRadius: BorderRadius.circular(10)),
                child: Center(
                    child: board?.image == null
                        ? Text('')
                        : ClipRRect(
                            borderRadius: BorderRadius.circular(5),
                            child: Image.network(
                              S3Address + board!.image!,
                            ),
                          )),
              ),
              Padding(
                padding: EdgeInsets.fromLTRB(10.w, 0, 10.w, 0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    Flexible(
                      child: RichText(
                          overflow: TextOverflow.ellipsis,
                          maxLines: 10,
                          text: TextSpan(
                              text:
                                  board?.content == null ? "" : board!.content!,
                              style: TextStyle(
                                  color: btnColor,
                                  fontSize: 20.sp,
                                  fontFamily: "Sub"))),
                    )
                  ],
                ),
              ),
              Padding(
                padding: const EdgeInsets.fromLTRB(0, 25, 0, 0),
                child: TextFormField(
                  controller: commentController,
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
                    hintStyle: TextStyle(color: sColor, fontFamily: "Sub"),
                    contentPadding: EdgeInsets.fromLTRB(20.w, 10.h, 10.w, 10.h),
                    enabledBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.all(Radius.circular(10)),
                        borderSide: BorderSide(color: sColor)),
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
                        style: TextStyle(
                          fontFamily: "Sub",
                        ),
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
                            padding: EdgeInsets.fromLTRB(0, 25.h, 0, 25.h),
                            child: Text(
                              "댓글이 없습니다.",
                              style: TextStyle(fontFamily: "Sub"),
                            ))
                      ],
                    )
                  : ListView(
                      scrollDirection: Axis.vertical,
                      shrinkWrap: true,
                      physics: const NeverScrollableScrollPhysics(),
                      children: [
                          for (int i = 0; i < comments.length; i++)
                            Padding(
                                padding: EdgeInsets.fromLTRB(0, 7.h, 0, 7.h),
                                child: ListTile(
                                  onTap: () {
                                    if (user?.nickname == null ||
                                        user!.nickname! != comments[i].nickname)
                                      return;
                                    showDialog(
                                        context: context,
                                        builder: (BuildContext context) {
                                          return Dialog(
                                            shape: RoundedRectangleBorder(
                                                borderRadius:
                                                    BorderRadius.circular(
                                                        20.0)), //this right here
                                            child: Container(
                                              height: 200.h,
                                              child: Padding(
                                                padding: EdgeInsets.fromLTRB(
                                                    12.0.w,
                                                    12.0.h,
                                                    12.0.w,
                                                    3.0.h),
                                                child: Column(
                                                  mainAxisAlignment:
                                                      MainAxisAlignment.center,
                                                  crossAxisAlignment:
                                                      CrossAxisAlignment.center,
                                                  children: [
                                                    Padding(
                                                        padding: EdgeInsets.fromLTRB(
                                                            0,
                                                            0,
                                                            0,
                                                            MediaQuery.of(
                                                                        context)
                                                                    .size
                                                                    .height /
                                                                40),
                                                        child: Title(
                                                          color: Colors.black,
                                                          child: Text(
                                                            "댓글 수정",
                                                            style: TextStyle(
                                                              fontSize: 18.sp,
                                                              fontFamily:
                                                                  "Title",
                                                            ),
                                                          ),
                                                        )),
                                                    TextFormField(
                                                      controller:
                                                          modifyCommentController
                                                            ..text = comments[i]
                                                                .content!
                                                            ..selection = TextSelection
                                                                .fromPosition(
                                                                    TextPosition(
                                                                        offset: modifyCommentController
                                                                            .text
                                                                            .length)),
                                                      keyboardType:
                                                          TextInputType.text,
                                                      textInputAction:
                                                          TextInputAction.next,
                                                      cursorColor: btnColor,
                                                      style: TextStyle(
                                                          fontFamily: "Sub"),
                                                      onChanged: (val) {
                                                        final value = TextSelection
                                                            .collapsed(
                                                                offset:
                                                                    modifyCommentController
                                                                        .text
                                                                        .length);
                                                        modifyCommentController
                                                            .selection = value;
                                                        modifyCommentContent =
                                                            val;
                                                      },
                                                      validator: (text) {
                                                        if (text == null ||
                                                            text.isEmpty) {
                                                          return '댓글을 입력해주세요.';
                                                        }
                                                        return null;
                                                      },
                                                      decoration:
                                                          InputDecoration(
                                                        isCollapsed: true,
                                                        hintText: "댓글을 입력하세요.",
                                                        hintStyle: TextStyle(
                                                          color: sColor,
                                                          fontFamily: "Sub",
                                                        ),
                                                        contentPadding:
                                                            EdgeInsets.fromLTRB(
                                                                20, 10, 10, 10),
                                                        enabledBorder: OutlineInputBorder(
                                                            borderRadius:
                                                                BorderRadius
                                                                    .all(Radius
                                                                        .circular(
                                                                            10)),
                                                            borderSide:
                                                                BorderSide(
                                                                    color:
                                                                        sColor)),
                                                        filled: true,
                                                        fillColor: Colors.white,
                                                        focusedBorder: OutlineInputBorder(
                                                            borderRadius:
                                                                BorderRadius
                                                                    .all(Radius
                                                                        .circular(
                                                                            10)),
                                                            borderSide: BorderSide(
                                                                color:
                                                                    btnColor)),
                                                      ),
                                                    ),
                                                    Container(
                                                        width: 150.0.w,
                                                        margin:
                                                            EdgeInsets.fromLTRB(
                                                                0, 10.h, 0, 0),
                                                        child: Row(
                                                            mainAxisAlignment:
                                                                MainAxisAlignment
                                                                    .spaceAround,
                                                            children: [
                                                              ElevatedButton(
                                                                onPressed:
                                                                    () async {
                                                                  Navigator.pop(
                                                                      context);
                                                                  modifyCommentContent =
                                                                      modifyCommentController
                                                                          .text;
                                                                  _modifyComment(
                                                                      comments[
                                                                              i]
                                                                          .id);
                                                                },
                                                                style: ElevatedButton
                                                                    .styleFrom(
                                                                  padding:
                                                                      EdgeInsets
                                                                          .all(
                                                                              0),
                                                                  backgroundColor:
                                                                      btnColor,
                                                                  shape:
                                                                      RoundedRectangleBorder(
                                                                    borderRadius:
                                                                        BorderRadius.circular(
                                                                            5.0),
                                                                  ),
                                                                  tapTargetSize:
                                                                      MaterialTapTargetSize
                                                                          .shrinkWrap,
                                                                ),
                                                                child: Text(
                                                                  "확인",
                                                                  style: TextStyle(
                                                                      color: Colors
                                                                          .white,
                                                                      fontFamily:
                                                                          "Sub"),
                                                                ),
                                                              ),
                                                              ElevatedButton(
                                                                onPressed: () {
                                                                  Navigator.pop(
                                                                      context);
                                                                },
                                                                style: ElevatedButton
                                                                    .styleFrom(
                                                                        backgroundColor:
                                                                            Colors.white),
                                                                child: Text(
                                                                  "취소",
                                                                  style: TextStyle(
                                                                      color: Colors
                                                                          .black,
                                                                      fontFamily:
                                                                          "Sub"),
                                                                ),
                                                              ),
                                                            ])),
                                                  ],
                                                ),
                                              ),
                                            ),
                                          );
                                        });
                                  },
                                  onLongPress: () {
                                    if (user?.nickname == null ||
                                        user!.nickname! != comments[i].nickname)
                                      return;
                                    showDialog(
                                        context: context,
                                        builder: (BuildContext context) {
                                          return Dialog(
                                            shape: RoundedRectangleBorder(
                                                borderRadius:
                                                    BorderRadius.circular(
                                                        20.0)), //this right here
                                            child: Container(
                                              height: 150.h,
                                              child: Padding(
                                                padding: EdgeInsets.fromLTRB(
                                                    12.0.w,
                                                    18.0.h,
                                                    12.0.w,
                                                    3.0.h),
                                                child: Column(
                                                  mainAxisAlignment:
                                                      MainAxisAlignment.center,
                                                  crossAxisAlignment:
                                                      CrossAxisAlignment.center,
                                                  children: [
                                                    Padding(
                                                        padding: EdgeInsets.fromLTRB(
                                                            0,
                                                            0,
                                                            0,
                                                            MediaQuery.of(
                                                                        context)
                                                                    .size
                                                                    .height /
                                                                40),
                                                        child: Title(
                                                          color: Colors.black,
                                                          child: Text(
                                                              "정말 이 댓글을 삭제하시겠습니까?",
                                                              style: TextStyle(
                                                                  fontSize:
                                                                      15.sp,
                                                                  fontFamily:
                                                                      "Title")),
                                                        )),
                                                    Container(
                                                        width: 150.0.w,
                                                        margin:
                                                            EdgeInsets.fromLTRB(
                                                                0, 10.h, 0, 0),
                                                        child: Row(
                                                            mainAxisAlignment:
                                                                MainAxisAlignment
                                                                    .spaceAround,
                                                            children: [
                                                              ElevatedButton(
                                                                onPressed:
                                                                    () async {
                                                                  Navigator.pop(
                                                                      context);
                                                                  _deleteComment(
                                                                      comments[
                                                                              i]
                                                                          .id);
                                                                },
                                                                style: ElevatedButton
                                                                    .styleFrom(
                                                                        backgroundColor:
                                                                            btnColor),
                                                                child: Text(
                                                                  "확인",
                                                                  style: TextStyle(
                                                                      color: Colors
                                                                          .white,
                                                                      fontFamily:
                                                                          "Sub"),
                                                                ),
                                                              ),
                                                              ElevatedButton(
                                                                onPressed: () {
                                                                  Navigator.pop(
                                                                      context);
                                                                },
                                                                style: ElevatedButton
                                                                    .styleFrom(
                                                                        backgroundColor:
                                                                            Colors.white),
                                                                child: Text(
                                                                  "취소",
                                                                  style: TextStyle(
                                                                      color: Colors
                                                                          .black,
                                                                      fontFamily:
                                                                          "Sub"),
                                                                ),
                                                              ),
                                                            ])),
                                                  ],
                                                ),
                                              ),
                                            ),
                                          );
                                        });
                                  },
                                  leading: GestureDetector(
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
                                                  S3Address +
                                                      comments[i].image!)),
                                    ),
                                  ),
                                  title: Text(
                                    comments[i].nickname == null
                                        ? ""
                                        : comments[i].nickname!,
                                    style: TextStyle(
                                        fontWeight: FontWeight.bold,
                                        fontFamily: "Sub"),
                                  ),
                                  subtitle: Text(
                                    comments[i].content == null
                                        ? ""
                                        : comments[i].content!,
                                    style: TextStyle(fontFamily: "Sub"),
                                  ),
                                )),
                        ]),
            ])),
      );
    }
  }

  @override
  void dispose() {
    searchController.dispose();
    super.dispose();
  }
}
