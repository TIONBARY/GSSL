import 'dart:convert';

import 'package:GSSL/api/use_JWT_Token.dart';
import 'package:GSSL/model/request_models/put_walk.dart';
import 'package:GSSL/model/response_models/general_response.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';

class ApiWalk {
  Future<generalResponse> enterWalk(putWalk requestModel) async {
    final storage = FlutterSecureStorage();
    // read value
    String? accessToken = await storage.read(key: 'Authorization');
    // String? refreshToken = await storage.read(key: 'RefreshToken');
    String url = "https://j7a204.p.ssafy.io/api/walk";
    final response = await apiUseToken()
        .useJWTHeader(url, jsonEncode(requestModel.toJson()));

    // debugPrint("accessToken");
    // debugPrint(accessToken);
    // final response = await http.post(Uri.parse(url),
    //     headers: <String, String>{
    //       'Content-Type': 'application/json; charset=UTF-8',
    //       'Authorization': 'Bearer ' + accessToken!,
    //     },
    //     body: jsonEncode(requestModel.toJson()));

    generalResponse walkPutResponse =
        generalResponse.fromJson(json.decode(response.body));

    return walkPutResponse;
  }
}
