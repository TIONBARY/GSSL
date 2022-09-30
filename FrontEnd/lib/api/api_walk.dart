import 'dart:convert';

import 'package:GSSL/api/interceptor.dart';
import 'package:GSSL/model/request_models/batch_delete_walk.dart';
import 'package:GSSL/model/request_models/put_walk.dart';
import 'package:GSSL/model/request_models/update_walk.dart';
import 'package:GSSL/model/response_models/general_response.dart';
import 'package:GSSL/model/response_models/get_walk_detail.dart';
import 'package:GSSL/model/response_models/get_walk_list.dart';
import 'package:http_interceptor/http/http.dart';

class ApiWalk {
  final client = InterceptedClient.build(interceptors: [ApiInterceptor()]);
  String api_url = "https://j7a204.p.ssafy.io/api/walk";

  // 산책 기록 등록
  Future<generalResponse> enterWalk(putWalk requestModel) async {
    final response = await client.post(Uri.parse(api_url),
        body: jsonEncode(requestModel.toJson()));
    final walkPutResponse =
        generalResponse.fromJson(json.decode(response.body));
    return walkPutResponse;
  }

  // 산책 기록 목록 조회(작업중)
  Future<WalkList> getWalkList() async {
    final response = await client.get(Uri.parse(api_url));
    WalkList result = WalkList.fromJson(json.decode(response.body));
    return result;
  }

  // 산책 기록 상세 조회(작업중)
  Future<Detail> getWalkDetail(int walkId) async {
    final response =
        await client.get(Uri.parse(api_url + "/" + walkId.toString()));
    Detail result = Detail.fromJson(json.decode(response.body));
    return result;
  }

  // 산책 기록 수정
  Future<generalResponse> modifyWalk(int walkId, List<int> list) async {
    final response = await client.post(
        Uri.parse(api_url + "/" + walkId.toString()),
        body: jsonEncode(updateWalk(list).toJson()));
    generalResponse result =
        generalResponse.fromJson(json.decode(response.body));
    return result;
  }

  // 산책 기록 삭제
  Future<generalResponse> deleteWalk(int walkId) async {
    final response =
        await client.delete(Uri.parse(api_url + "/" + walkId.toString()));
    generalResponse result =
        generalResponse.fromJson(json.decode(response.body));
    return result;
  }

  // 산책 기록 일괄 삭제
  Future<generalResponse> deleteAllWalk(List<int> walkIds) async {
    final response = await client.post(Uri.parse(api_url + '/delete'),
        body: jsonEncode(batchDeleteWalk(walkIds).toJson()));
    generalResponse result =
        generalResponse.fromJson(json.decode(response.body));
    return result;
  }
}
