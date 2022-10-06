import 'dart:async';

import 'package:GSSL/api/api_community.dart';
import 'package:GSSL/api/api_user.dart';
import 'package:GSSL/components/bottomNavBar.dart';
import 'package:GSSL/components/community/board_detail_page.dart';
import 'package:GSSL/components/util/custom_dialog.dart';
import 'package:GSSL/constants.dart';
import 'package:GSSL/model/response_models/general_response.dart';
import 'package:GSSL/model/response_models/get_board_list.dart';
import 'package:GSSL/model/response_models/user_info.dart';
import 'package:GSSL/pages/login_page.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import './edit_first_page.dart';
import './store_third_page.dart';
import './utils_second/context_extension.dart';
import './widgets/content_item_widget.dart';
import './widgets/dismissible_background_widget.dart';
import './widgets/icon_button_widget.dart';
import './widgets/my_box_widget.dart';
import './widgets/text_button_widget.dart';

class ThirdPage extends StatefulWidget {
  const ThirdPage({Key? key}) : super(key: key);

  @override
  State<ThirdPage> createState() => _ThirdPageState();
}

class _ThirdPageState extends State<ThirdPage> with TickerProviderStateMixin {
  TextEditingController searchController = TextEditingController();
  late Size _size;
  List<Content> _aidList = [];
  User? user;
  bool isSearch = false;

  ApiCommunity apiCommunity = ApiCommunity();
  ApiUser apiUser = ApiUser();

  Timer? _debounce;

  bool _hasMore = true;
  int _pageNumber = 0;
  bool _error = false;
  bool _loading = true;
  final int _pageSize = 10;
  final int _nextPageThreshold = 5;

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

  Future<bool> _getSearchList(String searchText, int page, int size) async {
    getBoardList result =
        await apiCommunity.getAllBoardApi(3, searchText, page, size);
    if (result.statusCode == 200) {
      setState(() {
        _hasMore = result.boardList!.content!.length == _pageSize;
        _loading = false;
        _pageNumber = _pageNumber + 1;
        _aidList.addAll(result.boardList!.content!);
      });
      if (_aidList.isNotEmpty) {
        setState(() {
          isSearch = true;
        });
        return true;
      }
      return false;
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
    return false;
  }

  void _deleteBoard(int boardId) async {
    generalResponse result = await apiCommunity.deleteAPI(boardId);
    if (result.statusCode == 200) {
      setState(() {
        _hasMore = true;
        _loading = false;
        _pageNumber = 0;
        _aidList = [];
      });
      _getSearchList(searchController.text, _pageNumber, _pageSize);
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
    _getSearchList(searchController.text, _pageNumber, _pageSize);
    getUser();
  }

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
        appBar: AppBar(
          toolbarHeight: 70,
          centerTitle: false,
          backgroundColor: Colors.white,
          title: TextField(
            controller: searchController,
            textInputAction: TextInputAction.search,
            onSubmitted: (str) {
              if (str.isEmpty) {
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(content: Text('검색할 단어를 입력하세요.')),
                );
                return;
              } else {
                setState(() {
                  _aidList = [];
                  _hasMore = true;
                  _pageNumber = 0;
                  _error = false;
                  _loading = true;
                });
                _getSearchList(searchController.text, _pageNumber, _pageSize)
                    .then((value) {
                  if (!value) {
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(content: Text('검색 결과가 없습니다.')),
                    );
                  }
                });
              }
            },
            decoration: InputDecoration(
              suffixIcon: InkWell(
                  onTap: () {
                    if (searchController.text.isEmpty) {
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(content: Text('검색할 단어를 입력하세요.')),
                      );
                      return;
                    }
                  },
                  child: const Icon(
                    Icons.search,
                    color: Colors.black,
                  )),
              hintText: '검색할 단어를 입력하세요.',
              hintStyle: TextStyle(color: sColor, fontFamily: "Sub"),
              contentPadding: EdgeInsets.fromLTRB(20.w, 10.h, 10.w, 10.h),
              enabledBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.all(Radius.circular(10)),
                  borderSide: BorderSide(color: btnColor)),
              filled: true,
              fillColor: Colors.white,
              focusedBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.all(Radius.circular(10)),
                  borderSide: BorderSide(color: btnColor)),
            ),
          ),
          actions: [
            Padding(
              padding: EdgeInsets.fromLTRB(0, 0, 12.5.w, 0),
              child: IconButtonWidget(
                color: btnColor,
                onTap: () => context.to(AddNewFeedPage()).then((value) {
                  if (value != null) {
                    if (value == true) {
                      setState(() {
                        _aidList = [];
                        _hasMore = true;
                        _pageNumber = 0;
                        _error = false;
                        _loading = true;
                      });
                      _getSearchList(
                          searchController.text, _pageNumber, _pageSize);
                    }
                  }
                }),
                iconData: Icons.add_sharp,
                iconColor: Colors.white,
              ),
            ),
          ],
        ),
        body: _aidList.isNotEmpty
            ? SingleChildScrollView(
                child: Column(
                  children: [
                    ListView.builder(
                        physics: const NeverScrollableScrollPhysics(),
                        shrinkWrap: true,
                        itemCount: _aidList.length + (_hasMore ? 1 : 0),
                        itemBuilder: (context, index) {
                          if (_hasMore &&
                              index == _aidList.length - _nextPageThreshold) {
                            _getSearchList(
                                searchController.text, _pageNumber, _pageSize);
                          }
                          if (index == _aidList.length) {
                            if (_error) {
                              return Center(
                                  child: InkWell(
                                onTap: () {
                                  setState(() {
                                    _loading = true;
                                    _error = false;
                                    _getSearchList(searchController.text,
                                        _pageNumber, _pageSize);
                                  });
                                },
                                child: Padding(
                                  padding: const EdgeInsets.all(16),
                                  child: Text("에러가 발생했습니다. 터치하여 다시 시도해주세요."),
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
                          return GestureDetector(
                              onTap: () {
                                Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                        builder: (context) => BoardDetailPage(
                                            _aidList[index].id!)));
                              },
                              child: Dismissible(
                                background: DismissibleBackgroundWidget(
                                    alignment: Alignment.centerRight,
                                    icon: Icons.edit,
                                    backgroundColor:
                                        Theme.of(context).primaryColor),
                                secondaryBackground:
                                    DismissibleBackgroundWidget(
                                  alignment: Alignment.centerLeft,
                                  icon: Icons.delete_outline_sharp,
                                  backgroundColor: Colors.red,
                                  iconColor: Colors.white,
                                ),
                                confirmDismiss:
                                    (DismissDirection direction) async {
                                  if (direction ==
                                          DismissDirection.startToEnd &&
                                      user?.nickname != null &&
                                      user!.nickname ==
                                          _aidList[index].nickname) {
                                    return await showDialog(
                                      context: context,
                                      builder: (BuildContext context) {
                                        return AlertDialog(
                                          title: const Text("수정",
                                              style:
                                                  TextStyle(fontFamily: "Sub")),
                                          content: const Text(
                                              "정말 해당 게시물을 수정하시겠습니까?",
                                              style:
                                                  TextStyle(fontFamily: "Sub")),
                                          actions: <Widget>[
                                            TextBtnWidget(
                                              name: '수정',
                                              btnColor: btnColor,
                                              nameColor: Colors.white,
                                              isStretch: false,
                                              onTap: () {
                                                context
                                                    .to(EditPostPage(
                                                        _aidList[index].id!))
                                                    .then((value) {
                                                  if (value != null) {
                                                    if (value == true) {
                                                      setState(() {
                                                        _aidList = [];
                                                        _hasMore = true;
                                                        _pageNumber = 0;
                                                        _error = false;
                                                        _loading = true;
                                                      });
                                                      _getSearchList(
                                                          searchController.text,
                                                          _pageNumber,
                                                          _pageSize);
                                                    }
                                                  }
                                                  return context.back(false);
                                                });
                                              },
                                            ),
                                            TextBtnWidget(
                                              name: '취소',
                                              btnColor: Colors.white,
                                              onTap: () => context.back(false),
                                              isStretch: false,
                                            ),
                                          ],
                                        );
                                      },
                                    );
                                  } else if (direction ==
                                          DismissDirection.endToStart &&
                                      user?.nickname != null &&
                                      user!.nickname ==
                                          _aidList[index].nickname) {
                                    return await showDialog(
                                      context: context,
                                      builder: (BuildContext context) {
                                        return AlertDialog(
                                          title: const Text("삭제",
                                              style:
                                                  TextStyle(fontFamily: "Sub")),
                                          content: const Text(
                                              "정말 해당 게시물을 삭제하시겠습니까?",
                                              style:
                                                  TextStyle(fontFamily: "Sub")),
                                          actions: <Widget>[
                                            TextBtnWidget(
                                              name: '삭제',
                                              nameColor: Colors.white,
                                              btnColor: Colors.red,
                                              onTap: () {
                                                _deleteBoard(
                                                    _aidList[index].id!);
                                                return context.back(false);
                                              },
                                              isStretch: false,
                                            ),
                                            TextBtnWidget(
                                              name: '취소',
                                              btnColor: Colors.white,
                                              onTap: () => context.back(false),
                                              isStretch: false,
                                            ),
                                          ],
                                        );
                                      },
                                    );
                                  }
                                  return null;
                                },
                                key: Key(_aidList[index].id!.toString()),
                                child: ContentItemWidget(
                                    name: _aidList[index].title!,
                                    profileImage: _aidList[index].profileImage,
                                    nickname: _aidList[index]!.nickname!,
                                    photo: _aidList[index].image),
                              ));
                        }),
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
                  const Text('게시물이 없습니다.', style: TextStyle(fontFamily: "Sub")),
                ],
              )),
      );
    }
  }

  @override
  void dispose() {
    searchController.dispose();
    super.dispose();
  }
}
