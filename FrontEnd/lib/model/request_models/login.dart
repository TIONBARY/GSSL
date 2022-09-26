class LoginResponseModel {
  final String token;
  final String error;

  LoginResponseModel({required this.token, required this.error});

  factory LoginResponseModel.fromJson(Map<String, dynamic> json) {
    return LoginResponseModel(
      token: json["token"] != null ? json["token"] : "",
      error: json["error"] != null ? json["error"] : "",
    );
  }
}

class LoginRequestModel {
  String id;
  String password;

  LoginRequestModel({
    required this.id,
    required this.password,
  });

  Map<String, String> toJson() {
    Map<String, String> map = {
      'member_id': id.trim(),
      'password': password.trim(),
    };

    return map;
  }
}
