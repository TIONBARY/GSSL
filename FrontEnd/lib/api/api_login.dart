import 'package:GSSL/model/response_models/general_response.dart';
import 'package:GSSL/model/response_models/login_post.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import '../model/request_models/login.dart';

import 'package:flutter_secure_storage/flutter_secure_storage.dart';


class ApiLogin {
  Future<generalResponse> login(LoginRequestModel requestModel) async {
    String url = "https://j7a204.p.ssafy.io/api/user/public/login";

    final response = await http.post(Uri.parse(url), headers: <String, String>{
      'Content-Type': 'application/json; charset=UTF-8',
    }, body: jsonEncode(requestModel.toJson()));
    if (response.statusCode == 200 || response.statusCode == 400) {
      print("---------------------------------");
      print(json.decode(response.body));

      loginPost loginInfo = loginPost.fromJson(json.decode(response.body));

      final storage = new FlutterSecureStorage();

      // Write value
      await storage.write(key: 'Authorization', value: loginInfo.tokenInfo?.accessToken);
      await storage.write(key: 'RefreshToken', value: loginInfo.tokenInfo?.refreshToken);

      return generalResponse(loginInfo.statusCode, loginInfo.message);
    } else {
      print(json.decode(response.body));
      throw Exception('Failed to load data!');
    }
  }
}
