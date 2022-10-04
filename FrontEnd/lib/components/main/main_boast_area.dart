import 'dart:async';

import 'package:GSSL/api/api_community.dart';
import 'package:GSSL/components/community/board_detail_page.dart';
import 'package:GSSL/components/community/widgets/my_box_widget.dart';
import 'package:GSSL/components/util/custom_dialog.dart';
import 'package:GSSL/constants.dart';
import 'package:GSSL/model/response_models/get_board_list.dart';
import 'package:GSSL/pages/login_page.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class MainBoastArea extends StatefulWidget {
  const MainBoastArea({Key? key}) : super(key: key);

  @override
  State<MainBoastArea> createState() => _MainBoastAreaState();
}

class _MainBoastAreaState extends State<MainBoastArea>
    with TickerProviderStateMixin {
  List<Content> _aidList = [];

  ApiCommunity apiCommunity = ApiCommunity();

  Timer? _debounce;

  bool _hasMore = true;
  int _pageNumber = 0;
  bool _error = false;
  bool _loading = true;
  final int _pageSize = 5;

  String S3Address = "https://a204drdoc.s3.ap-northeast-2.amazonaws.com/";

  Future<bool> _getList(int page, int size) async {
    getBoardList result = await apiCommunity.getAllBoardApi(1, '', page, size);
    if (result.statusCode == 200) {
      setState(() {
        _hasMore = result.boardList!.content!.length == _pageSize;
        _loading = false;
        _pageNumber = _pageNumber + 1;
        _aidList.addAll(result.boardList!.content!);
      });
      if (_aidList.isNotEmpty) {
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

  @override
  void initState() {
    super.initState();
    _getList(_pageNumber, _pageSize);
  }

  @override
  Widget build(BuildContext context) {
    if (_loading) {
      return Container(
          margin: EdgeInsets.fromLTRB(0, 10.h, 0, 10.h),
          child: Column(children: [
            Padding(
                padding: const EdgeInsets.symmetric(vertical: defaultPadding),
                child: Center(
                    child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Image.asset("assets/images/loadingDog.gif",
                        width: 120.w, height: 100.h, fit: BoxFit.fill),
                  ],
                ))),
          ]));
    } else {
      return _aidList.isNotEmpty
          ? Container(
              height: 160.h,
              child: ListView.builder(
                  scrollDirection: Axis.horizontal,
                  shrinkWrap: true,
                  itemCount: _aidList.length,
                  itemBuilder: (context, index) {
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
                                  builder: (context) =>
                                      BoardDetailPage(_aidList[index].id!)));
                        },
                        child: Padding(
                          padding: EdgeInsets.fromLTRB(10.w, 10.h, 0, 10.h),
                          child: ClipRRect(
                            borderRadius: const BorderRadius.only(
                              topLeft: Radius.circular(10),
                              topRight: Radius.circular(10),
                              bottomLeft: Radius.circular(10),
                              bottomRight: Radius.circular(10),
                            ),
                            child: _aidList[index].image == null ||
                                    _aidList[index].image == ''
                                ? Container()
                                : CachedNetworkImage(
                                    maxWidthDiskCache: 160,
                                    maxHeightDiskCache: 160,
                                    height: 160,
                                    width: 160,
                                    fit: BoxFit.cover,
                                    imageUrl:
                                        S3Address + _aidList[index].image!,
                                    errorWidget: (context, str, err) {
                                      return const Icon(
                                        Icons.photo,
                                        size: 100,
                                      );
                                    },
                                    placeholder: (context, str) {
                                      return const Center(
                                        child: Text("..."),
                                      );
                                    },
                                  ),
                          ),
                        ));
                  }))
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
            ));
    }
  }

  @override
  void dispose() {
    super.dispose();
  }
}
