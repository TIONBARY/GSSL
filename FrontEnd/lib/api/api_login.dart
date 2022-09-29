import 'package:GSSL/model/response_models/general_response.dart';
import 'package:GSSL/model/response_models/post_login.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import '../model/request_models/put_login.dart';

import 'package:flutter_secure_storage/flutter_secure_storage.dart';


class ApiLogin {
  Future<generalResponse> login(LoginRequestModel requestModel) async {
    String url = "https://j7a204.p.ssafy.io/api/user/public/login";

    final response = await http.post(Uri.parse(url), headers: <String, String>{
      'Content-Type': 'application/json; charset=UTF-8',
    }, body: jsonEncode(requestModel.toJson()));

      loginPost loginInfo = loginPost.fromJson(json.decode(response.body));

      final storage = new FlutterSecureStorage();

      // Write value
      await storage.write(key: 'Authorization', value: loginInfo.tokenInfo?.accessToken);
      await storage.write(key: 'RefreshToken', value: loginInfo.tokenInfo?.refreshToken);
      print("++++++++++++++++++++++++++++++++++++++++");
      print(loginInfo.tokenInfo?.accessToken);
      String? authKey = await storage.read(key: 'Authorization');
      print("${authKey}");
      return generalResponse(loginInfo.statusCode, loginInfo.message);
  }
}
