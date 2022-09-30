import 'dart:convert';

import 'package:GSSL/api/interceptor.dart';
import 'package:GSSL/model/response_models/general_response.dart';
import 'package:GSSL/model/response_models/user_info.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:http_interceptor/http/http.dart';

class ApiUser {
  final client = InterceptedClient.build(interceptors: [ApiInterceptor()]);

  String api_url = "https://j7a204.p.ssafy.io/api/user";
  final storage = new FlutterSecureStorage();

  Future<userInfo> getUserInfo() async {
    final response = await client.get(Uri.parse(api_url));
    userInfo result = userInfo.fromJson(json.decode(response.body));
    return result;
  }

  Future<generalResponse> modifyUserPetAPI(int petId) async {
    String? accessToken = await storage.read(key: "Authorization");
    Map<String, String> headers = {
      "Authorization": "Bearer " + accessToken!,
      'Content-Type': 'application/json; charset=UTF-8'
    };
    final response = await client.put(Uri.parse(api_url + "/pet"),
        body: json.encode({'pet_id': petId}));
    generalResponse result =
        generalResponse.fromJson(json.decode(response.body));
    return result;
  }

  Future<generalResponse> logoutAPI() async {
    final response = await client.post(Uri.parse(api_url + "/auth/logout"),
        body: json.encode(
            {'refresh_token': await storage.read(key: 'RefreshToken')}));
    generalResponse result =
        generalResponse.fromJson(json.decode(response.body));
    if (result.statusCode == 200) {
      storage.deleteAll();
    }
    return result;
  }
}
