import 'dart:convert';

import 'package:GSSL/api/interceptor.dart';
import 'package:GSSL/model/request_models/put_walk.dart';
import 'package:GSSL/model/response_models/general_response.dart';
import 'package:http_interceptor/http/http.dart';

class ApiWalk {
  final client = InterceptedClient.build(interceptors: [
    ApiInterceptor()
  ]);
  Future<generalResponse> enterWalk(putWalk requestModel) async {
    String url = "https://j7a204.p.ssafy.io/api/walk";
    final response = await client.post(Uri.parse(url), body: jsonEncode(requestModel.toJson()));
    final walkPutResponse = generalResponse.fromJson(json.decode(response.body));
    return walkPutResponse;
  }
}
