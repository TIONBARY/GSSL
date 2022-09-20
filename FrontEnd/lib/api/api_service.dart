import 'package:http/http.dart' as http;
import 'dart:convert';
import '../model/login_model.dart';

class APIService {
  Future<LoginResponseModel> login(LoginRequestModel requestModel) async {
    String url = "https://j7a204.p.ssafy.io/api/user/public/login";

    final response = await http.post(Uri.parse(url), headers: <String, String>{
      'Content-Type': 'application/json; charset=UTF-8',
    }, body: jsonEncode(requestModel.toJson()));
    if (response.statusCode == 200 || response.statusCode == 400) {
      print(json.decode(response.body));
      return LoginResponseModel.fromJson(
        json.decode(response.body),
      );
    } else {
      print(json.decode(response.body));
      throw Exception('Failed to load data!');
    }
  }
}
