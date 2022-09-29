import 'package:GSSL/api/interceptor.dart';
import 'package:GSSL/model/response_models/general_response.dart';
import 'package:GSSL/model/response_models/user_info.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:http/http.dart' as http;
import 'package:http_interceptor/http/http.dart';
import 'package:image_picker/image_picker.dart';
import 'dart:convert';
import '../model/request_models/signup.dart';
import 'package:http_parser/http_parser.dart';


class ApiUser {

  final client = InterceptedClient.build(interceptors: [
    ApiInterceptor()
  ]);

  String api_url = "https://j7a204.p.ssafy.io/api/user";
  final storage = new FlutterSecureStorage();

  Future<userInfo> getUserInfo() async {
    final response = await client.get(Uri.parse(api_url));
    userInfo result = userInfo.fromJson(json.decode(response.body));
    return result;
  }

  Future<generalResponse> modifyUserPetAPI(int petId) async {
    String? accessToken = await storage.read(key: "Authorization");
    Map<String, String> headers = { "Authorization": "Bearer "+accessToken!, 'Content-Type': 'application/json; charset=UTF-8'};
    final response = await client.put(Uri.parse(api_url+"/pet"), body: json.encode({'pet_id': petId}));
    generalResponse result = generalResponse.fromJson(json.decode(response.body));
    return result;
  }
}
