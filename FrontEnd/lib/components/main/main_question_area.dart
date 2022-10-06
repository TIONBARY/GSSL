import 'dart:async';

import 'package:GSSL/api/api_community.dart';
import 'package:GSSL/components/community/board_detail_page.dart';
import 'package:GSSL/components/community/widgets/my_box_widget.dart';
import 'package:GSSL/components/util/custom_dialog.dart';
import 'package:GSSL/constants.dart';
import 'package:GSSL/model/response_models/get_board_list.dart';
import 'package:GSSL/pages/login_page.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class MainQuestionArea extends StatefulWidget {
  const MainQuestionArea({Key? key}) : super(key: key);

  @override
  State<MainQuestionArea> createState() => _MainQuestionAreaState();
}

class _MainQuestionAreaState extends State<MainQuestionArea>
    with TickerProviderStateMixin {
  List<Content> _aidList = [];

  ApiCommunity apiCommunity = ApiCommunity();

  Timer? _debounce;

  bool _hasMore = true;
  int _pageNumber = 0;
  bool _error = false;
  bool _loading = true;
  final int _pageSize = 3;

  String S3Address = "https://a204drdoc.s3.ap-northeast-2.amazonaws.com/";

  Future<bool> _getList(int page, int size) async {
    getBoardList result = await apiCommunity.getAllBoardApi(3, '', page, size);
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
          color: nWColor,
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
      return Column(children: [
        Align(
          alignment: Alignment.centerLeft,
          child: Container(
            color: nWColor,
            padding: EdgeInsets.fromLTRB(20.w, 10.h, 20.w, 10.h),
          ),
        ),
        _aidList.isNotEmpty
            ? Container(
                color: nWColor,
                padding: EdgeInsets.all(20.0),
                child: DataTable(columns: [
                  DataColumn(
                    label: Text('작성자'),
                  ),
                  DataColumn(
                    label: Text('제목'),
                  ),
                ], rows: [
                  DataRow(cells: [
                    _aidList[0].nickname == null
                        ? DataCell.empty
                        : DataCell(ConstrainedBox(
                            constraints: BoxConstraints(
                                minWidth: 50.w, maxWidth: 80.w), //SET max width
                            child: Text(_aidList[0]!.nickname!,
                                overflow: TextOverflow.ellipsis))),
                    _aidList[0].title == null
                        ? DataCell.empty
                        : DataCell(onTap: () {
                            Navigator.push(
                                context,
                                MaterialPageRoute(
                                    builder: (context) =>
                                        BoardDetailPage(_aidList[0].id!)));
                          },
                            ConstrainedBox(
                                constraints: BoxConstraints(
                                    minWidth: 150.w,
                                    maxWidth: 150.w), //SET max width
                                child: Text(_aidList[0].title!,
                                    overflow: TextOverflow.ellipsis))),
                  ]),
                  DataRow(cells: [
                    _aidList.length < 2 || _aidList[1].nickname == null
                        ? DataCell.empty
                        : DataCell(ConstrainedBox(
                            constraints: BoxConstraints(
                                minWidth: 50.w, maxWidth: 80.w), //SET max width
                            child: Text(_aidList[1]!.nickname!,
                                overflow: TextOverflow.ellipsis))),
                    _aidList.length < 2 || _aidList[1].title == null
                        ? DataCell.empty
                        : DataCell(onTap: () {
                            Navigator.push(
                                context,
                                MaterialPageRoute(
                                    builder: (context) =>
                                        BoardDetailPage(_aidList[1].id!)));
                          },
                            ConstrainedBox(
                                constraints: BoxConstraints(
                                    minWidth: 150.w,
                                    maxWidth: 150.w), //SET max width
                                child: Text(_aidList[1].title!,
                                    overflow: TextOverflow.ellipsis))),
                  ]),
                  DataRow(cells: [
                    _aidList.length < 3 || _aidList[2].nickname == null
                        ? DataCell.empty
                        : DataCell(ConstrainedBox(
                            constraints: BoxConstraints(
                                minWidth: 50.w, maxWidth: 80.w), //SET max width
                            child: Text(_aidList[2]!.nickname!,
                                overflow: TextOverflow.ellipsis))),
                    _aidList.length < 3 || _aidList[2].title == null
                        ? DataCell.empty
                        : DataCell(onTap: () {
                            Navigator.push(
                                context,
                                MaterialPageRoute(
                                    builder: (context) =>
                                        BoardDetailPage(_aidList[2].id!)));
                          },
                            ConstrainedBox(
                                constraints: BoxConstraints(
                                    minWidth: 150.w,
                                    maxWidth: 150.w), //SET max width
                                child: Text(_aidList[2].title!,
                                    overflow: TextOverflow.ellipsis))),
                  ])
                ]))
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
              ))
      ]);
    }
  }

  @override
  void dispose() {
    super.dispose();
  }
}
