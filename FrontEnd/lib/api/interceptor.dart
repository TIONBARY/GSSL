import 'dart:convert';

import 'package:GSSL/model/response_models/token_reissue.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:http/http.dart' as http;
import 'package:http_interceptor/http_interceptor.dart';

class ApiInterceptor implements InterceptorContract {
  final storage = new FlutterSecureStorage();
  @override
  Future<RequestData> interceptRequest({required RequestData data}) async {
    try {
      String? accessToken = await storage.read(key: 'Authorization');
      data.headers["Authorization"] = "Bearer " + accessToken!;
      data.headers["Content-Type"] = "application/json";
    } catch (e) {
      print(e);
    }
    return data;
  }

  @override
  Future<ResponseData> interceptResponse({required ResponseData data}) async =>
      data;
}

class ExpiredTokenRetryPolicy extends RetryPolicy {
  final storage = new FlutterSecureStorage();

  @override
  int maxRetryAttempts = 2;

  @override
  Future<bool> shouldAttemptRetryOnResponse(ResponseData response) async {
    String? refreshToken = null;
    refreshToken = await storage.read(key: 'RefreshToken');
    String reissue = "https://j7a204.p.ssafy.io/api/user/auth/reissue";
    if (response.statusCode == 401 && refreshToken != null) {
      // 리이슈
      final response = await http.post(Uri.parse(reissue),
          headers: <String, String>{
            'Content-Type': 'application/json; charset=UTF-8',
          },
          body: json.encode({'refreshToken': refreshToken}));

      tokenReissue reissueInfo =
          tokenReissue.fromJson(json.decode(response.body));
      if (reissueInfo.tokenInfo?.accessToken != null &&
          reissueInfo.tokenInfo?.refreshToken != null) {
        // debugPrint(reissueInfo.tokenInfo?.refreshToken!);
        // Write value
        await storage.write(
            key: 'Authorization', value: reissueInfo.tokenInfo?.accessToken);
        await storage.write(
            key: 'RefreshToken', value: reissueInfo.tokenInfo?.refreshToken);

        return response.statusCode == 200;
      }
    }
    return false;
  }
}
