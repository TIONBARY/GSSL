import 'dart:convert';

import 'package:GSSL/api/interceptor.dart';
import 'package:GSSL/model/request_models/put_comment.dart';
import 'package:GSSL/model/request_models/update_comment.dart';
import 'package:GSSL/model/response_models/general_response.dart';
import 'package:GSSL/model/response_models/get_comment_list.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:http_interceptor/http/http.dart';

class ApiComment {
  final client = InterceptedClient.build(interceptors: [ApiInterceptor()]);

  String api_url = "https://j7a204.p.ssafy.io/api/comment";
  final storage = new FlutterSecureStorage();

  Future<generalResponse> writeCommentAPI(putComment requestModel) async {
    String url = api_url;
    final response = await client.post(Uri.parse(url),
        body: json.encode(requestModel.toJson()));
    generalResponse result =
        generalResponse.fromJson(json.decode(response.body));
    return result;
  }

  Future<getComments> getCommentsApi(int? boardId) async {
    String url = api_url + "/" + boardId.toString();
    final response = await client.get(Uri.parse(url));
    getComments result = getComments.fromJson(json.decode(response.body));
    return result;
  }

  Future<generalResponse> modifyCommentAPI(
      int? commentId, updateComment requestModel) async {
    String url = api_url + "/" + commentId.toString();
    ;
    final response = await client.put(Uri.parse(url),
        body: json.encode(requestModel.toJson()));
    generalResponse result =
        generalResponse.fromJson(json.decode(response.body));
    return result;
  }

  //
  Future<generalResponse> deleteAPI(int? commentId) async {
    final response =
        await client.delete(Uri.parse(api_url + "/" + commentId.toString()));
    generalResponse result =
        generalResponse.fromJson(json.decode(response.body));
    return result;
  }
}
