class RefreshTokenRequestModel {
  String refreshToken;

  RefreshTokenRequestModel({
    required this.refreshToken,
  });

  Map<String, String> toJson() {
    Map<String, String> map = {
      'refreshToken': refreshToken,
    };

    return map;
  }
}
