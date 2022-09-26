import 'package:GSSL/model/response_models/general_response.dart';

class loginPost extends generalResponse {
  TokenInfo? tokenInfo;

  loginPost(int statusCode, String message,TokenInfo tokenInfo) : super(statusCode, message) {
    this.tokenInfo = tokenInfo;
  }

  loginPost.fromJson(Map<String, dynamic> json) : super(json['statusCode'], json['message'])  {
    tokenInfo = json['token_info'] != null
        ? new TokenInfo.fromJson(json['token_info'])
        : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['statusCode'] = this.statusCode;
    data['message'] = this.message;
    if (this.tokenInfo != null) {
      data['token_info'] = this.tokenInfo!.toJson();
    }
    return data;
  }
}

class TokenInfo {
  String? grantType;
  String? accessToken;
  String? refreshToken;
  String? accessTokenExpiresIn;
  int? userId;

  TokenInfo(
      {this.grantType,
        this.accessToken,
        this.refreshToken,
        this.accessTokenExpiresIn,
        this.userId});

  TokenInfo.fromJson(Map<String, dynamic> json) {
    grantType = json['grantType'];
    accessToken = json['accessToken'];
    refreshToken = json['refreshToken'];
    accessTokenExpiresIn = json['accessTokenExpiresIn'];
    userId = json['user_id'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['grantType'] = this.grantType;
    data['accessToken'] = this.accessToken;
    data['refreshToken'] = this.refreshToken;
    data['accessTokenExpiresIn'] = this.accessTokenExpiresIn;
    data['user_id'] = this.userId;
    return data;
  }
}