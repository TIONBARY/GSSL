import 'package:GSSL/model/response_models/general_response.dart';
import 'package:GSSL/model/response_models/user_info.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:http/http.dart' as http;
import 'package:image_picker/image_picker.dart';
import 'dart:convert';
import '../model/request_models/signup.dart';
import 'package:http_parser/http_parser.dart';


class ApiUser {

  String api_url = "https://j7a204.p.ssafy.io/api/user";
  final storage = new FlutterSecureStorage();

  Future<userInfo> getUserInfo() async {
    String? accessToken = await storage.read(key: "Authorization");
    Map<String, String> headers = { "Authorization": "Bearer "+accessToken!};
    final response = await http.get(Uri.parse(api_url), headers: headers);
    userInfo result = userInfo.fromJson(json.decode(response.body));
    return result;
  }
}
