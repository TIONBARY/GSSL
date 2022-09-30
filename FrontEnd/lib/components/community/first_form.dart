import 'dart:async';

import 'package:GSSL/api/api_community.dart';
import 'package:GSSL/api/api_user.dart';
import 'package:GSSL/components/bottomNavBar.dart';
import 'package:GSSL/components/community/board_detail_page.dart';
import 'package:GSSL/components/util/custom_dialog.dart';
import 'package:GSSL/model/response_models/general_response.dart';
import 'package:GSSL/model/response_models/get_board_list.dart';
import 'package:GSSL/model/response_models/user_info.dart';
import 'package:GSSL/pages/login_page.dart';
import 'package:flutter/material.dart';

import './edit_first_page.dart';
import './store_first_page.dart';
import './utils_first/context_extension.dart';
import './widgets/content_item_widget.dart';
import './widgets/dismissible_background_widget.dart';
import './widgets/icon_button_widget.dart';
import './widgets/my_box_widget.dart';
import './widgets/text_button_widget.dart';

class FirstPage extends StatefulWidget {
  const FirstPage({Key? key}) : super(key: key);

  @override
  State<FirstPage> createState() => _FirstPageState();
}

class _FirstPageState extends State<FirstPage> with TickerProviderStateMixin {
  TextEditingController searchController = TextEditingController();
  late Size _size;
  List<Content> _aidList = [];
  User? user;

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

  Future<bool> _getSearchList(String searchText) async {
    // final data = await dbHelper.getSearchList(searchText);
    // if (data.isNotEmpty) {
    //   setState(() {
    //     _aidList = data;
    //     isSearch = true;
    //   });
    //   return true;
    // }
    return false;
  }

  void _getList(int page, int size) async {
    getBoardList result = await apiCommunity.getAllBoardApi(1, page, size);
    if (result.statusCode == 200) {
      setState(() {
        _aidList = result.boardList!.content!;
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

  void _deleteBoard(int boardId) async {
    generalResponse result = await apiCommunity.deleteAPI(boardId);
    if (result.statusCode == 200) {
      _getList(0, 30);
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
    _getList(0, 30);
    getUser();
  }

  @override
  Widget build(BuildContext context) {
    _size = MediaQuery.of(context).size;
    return Scaffold(
      appBar: AppBar(
        toolbarHeight: 70,
        centerTitle: false,
        backgroundColor: Colors.white,
        title: TextField(
          controller: searchController,
          textInputAction: TextInputAction.search,
          onChanged: (v) {
            if (_debounce?.isActive ?? false) _debounce!.cancel();
            _debounce = Timer(const Duration(milliseconds: 1000), () {
              _getSearchList(searchController.text).then((value) {
                if (!value) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(content: Text('Not Found!')),
                  );
                }
              });
            });
          },
          onSubmitted: (str) {
            if (str.isEmpty) {
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(content: Text('Type something to search')),
              );
              return;
            } else {
              _getSearchList(searchController.text).then((value) {
                if (!value) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(content: Text('Not Found!')),
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
                      const SnackBar(content: Text('Type something to search')),
                    );
                    return;
                  }
                },
                child: const Icon(
                  Icons.search,
                  color: Colors.black,
                )),
            hintText: 'Search',
            contentPadding: EdgeInsets.all(10),
            border:
                OutlineInputBorder(borderSide: BorderSide(color: Colors.black)),
            focusedBorder:
                OutlineInputBorder(borderSide: BorderSide(color: Colors.black)),
            enabledBorder:
                OutlineInputBorder(borderSide: BorderSide(color: Colors.black)),
          ),
        ),
        actions: [
          IconButtonWidget(
            color: Theme.of(context).primaryColor,
            onTap: () => context.to(AddNewFeedPage()).then((value) {
              if (value != null) {
                if (value == true) {
                  setState(() {});
                  _getList(0, 30);
                }
              }
            }),
            iconData: Icons.add_sharp,
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
                      itemCount: _aidList.length,
                      itemBuilder: (context, index) {
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
                              secondaryBackground: DismissibleBackgroundWidget(
                                alignment: Alignment.centerLeft,
                                icon: Icons.delete_outline_sharp,
                                backgroundColor: Colors.red,
                                iconColor: Colors.white,
                              ),
                              confirmDismiss:
                                  (DismissDirection direction) async {
                                if (direction == DismissDirection.startToEnd &&
                                    user?.nickname != null &&
                                    user!.nickname ==
                                        _aidList[index].nickname) {
                                  return await showDialog(
                                    context: context,
                                    builder: (BuildContext context) {
                                      return AlertDialog(
                                        title: const Text("수정"),
                                        content:
                                            const Text("정말 해당 게시물을 수정하시겠습니까?"),
                                        actions: <Widget>[
                                          TextBtnWidget(
                                            name: ' 수정 ',
                                            isStretch: false,
                                            onTap: () {
                                              context
                                                  .to(EditPostPage(
                                                      _aidList[index].id!))
                                                  .then((value) {
                                                if (value != null) {
                                                  if (value == true) {
                                                    setState(() {});
                                                    _getList(0, 30);
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
                                        title: const Text("삭제"),
                                        content:
                                            const Text("정말 해당 게시물을 삭제하시겠습니까?"),
                                        actions: <Widget>[
                                          TextBtnWidget(
                                            name: '삭제',
                                            nameColor: Colors.white,
                                            btnColor: Colors.red,
                                            onTap: () {
                                              _deleteBoard(_aidList[index].id!);
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
                              onDismissed: (direction) {
                                if (direction == DismissDirection.startToEnd) {
                                } else if (direction ==
                                    DismissDirection.endToStart) {
                                  _getList(0, 30);
                                }
                              },
                              key: Key(_aidList[index].id!.toString()),
                              child: ContentItemWidget(
                                  name: _aidList[index].title!,
                                  // body: _aidList[index].,
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
                const Text('게시물이 없습니다.'),
              ],
            )),
    );
  }

  @override
  void dispose() {
    searchController.dispose();
    super.dispose();
  }
}
