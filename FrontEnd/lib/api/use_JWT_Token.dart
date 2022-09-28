import 'dart:convert';

import 'package:GSSL/model/response_models/token_reissue.dart';
import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:http/http.dart' as http;

class apiUseToken {
  Future<http.Response> useJWTHeader(String url, body) async {
    final storage = new FlutterSecureStorage();
    // read value
    String? accessToken = await storage.read(key: 'Authorization');
    String nullSafeAccessToken = "";
    if (accessToken != null) {
      nullSafeAccessToken = accessToken; // Safe
      // debugPrint(accessToken);
    }
    debugPrint(nullSafeAccessToken);
    final response = await http.post(Uri.parse(url),
        headers: <String, String>{
          'Authorization': 'Bearer ' + nullSafeAccessToken,
          'Content-Type': 'application/json; charset=UTF-8',
        },
        body: body);

    if (response.statusCode == 200) {
      return response;
    }

    String? refreshToken = await storage.read(key: 'RefreshToken');
    if (response.statusCode == 401) {
      String reissue = "https://j7a204.p.ssafy.io/api/user/auth/reissue";
      final response = await http.post(Uri.parse(reissue),
          headers: <String, String>{
            'Content-Type': 'application/json; charset=UTF-8',
          },
          body: refreshToken);

      tokenReissue reissueInfo =
          tokenReissue.fromJson(json.decode(response.body));
      // Write value
      await storage.write(
          key: 'Authorization', value: reissueInfo.tokenInfo?.accessToken);
      await storage.write(
          key: 'RefreshToken', value: reissueInfo.tokenInfo?.refreshToken);
      String? accessToken = reissueInfo.tokenInfo?.accessToken;
      if (accessToken != null) {
        nullSafeAccessToken = accessToken;
      }
      if (reissueInfo.statusCode != 200) {
        return response;
      }
    }

    final againResponse = await http.post(Uri.parse(url),
        headers: <String, String>{
          'Authorization': 'Bearer ' + nullSafeAccessToken,
          'Content-Type': 'application/json; charset=UTF-8',
        },
        body: body);

    return againResponse;
  }
}
