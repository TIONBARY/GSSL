import 'dart:convert';
import 'dart:io';

import 'package:GSSL/api/interceptor.dart';
import 'package:GSSL/model/request_models/update_user.dart';
import 'package:GSSL/model/response_models/general_response.dart';
import 'package:GSSL/model/response_models/user_info.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:http/http.dart' as http;
import 'package:http_interceptor/http/http.dart';
import 'package:http_parser/http_parser.dart';

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

  Future<generalResponse> modify(File? file, updateUser requestModel) async {
    String url = api_url;
    final httpUri = Uri.parse(url);
    String? accessToken = await storage.read(key: "Authorization");
    Map<String, String> headers = {"Authorization": "Bearer " + accessToken!};
    var request = http.MultipartRequest('PUT', httpUri);
    request.headers.addAll(headers);
    if (file != null) {
      final httpImage = await http.MultipartFile.fromPath('file', file!.path);
      request.files.add(httpImage);
    }
    request.files.add(http.MultipartFile.fromBytes(
      'user',
      utf8.encode(json.encode(requestModel.toJson())),
      contentType: MediaType(
        'application',
        'json',
        {'charset': 'utf-8'},
      ),
    ));
    var response = await request.send();
    http.Response httpResponse = await http.Response.fromStream(response);
    print("Result: ${httpResponse.body}");
    String body = httpResponse.body;
    generalResponse result = generalResponse.fromJson(json.decode(body));
    return result;
  }
}
