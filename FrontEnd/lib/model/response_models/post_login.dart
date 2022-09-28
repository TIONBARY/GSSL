import 'package:GSSL/model/response_models/general_response.dart';
import 'package:flutter/cupertino.dart';

class loginPost extends generalResponse {
  TokenInfo? tokenInfo;

  loginPost(int statusCode, String message, TokenInfo tokenInfo)
      : super(statusCode, message) {
    this.tokenInfo = tokenInfo;
  }

  loginPost.fromJson(Map<String, dynamic> json)
      : super(json['statusCode'], json['message']) {
    tokenInfo = json['tokenDto'] != null
        ? new TokenInfo.fromJson(json['tokenDto'])
        : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['statusCode'] = this.statusCode;
    data['message'] = this.message;
    if (this.tokenInfo != null) {
      data['tokenDto'] = this.tokenInfo!.toJson();
    }
    return data;
  }
}

class TokenInfo {
  String? grantType;
  String? accessToken;
  String? refreshToken;
  int? accessTokenExpiresIn;

  TokenInfo(
      {this.grantType,
      this.accessToken,
      this.refreshToken,
      this.accessTokenExpiresIn});

  TokenInfo.fromJson(Map<String, dynamic> json) {
    debugPrint("아이디");
    debugPrint(json['user_id']);
    grantType = json['grantType'];
    accessToken = json['accessToken'];
    refreshToken = json['refreshToken'];
    accessTokenExpiresIn = json['accessTokenExpiresIn'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['grantType'] = this.grantType;
    data['accessToken'] = this.accessToken;
    data['refreshToken'] = this.refreshToken;
    data['accessTokenExpiresIn'] = this.accessTokenExpiresIn;
    return data;
  }
}
