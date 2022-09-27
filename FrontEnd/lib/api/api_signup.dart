import 'package:GSSL/model/response_models/general_response.dart';
import 'package:http/http.dart' as http;
import 'package:image_picker/image_picker.dart';
import 'dart:convert';
import '../model/request_models/signup.dart';
import 'package:http_parser/http_parser.dart';


class ApiSignup {

  String api_url = "https://j7a204.p.ssafy.io/api";

  Future<generalResponse> checkId(String? member_id) async {
    String url = api_url + "/user/public/id/" + member_id!;
    final response = await http.get(Uri.parse(url));
    generalResponse result = generalResponse.fromJson(json.decode(response.body));
    return result;
  }

  Future<generalResponse> checkNickname(String? nickname) async {
    String url = api_url + "/user/public/nickname/" + nickname!;
    final response = await http.get(Uri.parse(url));
    generalResponse result = generalResponse.fromJson(json.decode(response.body));
    return result;
  }


  Future<generalResponse> signup(XFile? file, Signup requestModel) async {
    String url = api_url + "/user/public/signup";
    final httpUri = Uri.parse(url);
    var request = http.MultipartRequest('POST', httpUri);
    if (file != null) {
      final httpImage = await http.MultipartFile.fromPath(
          'file', file.path);
      request.files.add(httpImage);
    }
    request.files.add(http.MultipartFile.fromBytes(
      'user',
      utf8.encode(json.encode(requestModel.toJson())),
      contentType: MediaType(
        'application',
        'json',
        {'charset': 'utf-8'},
      ),
    ));
    var response = await request.send();
    http.Response httpResponse = await http.Response.fromStream(response);
    print("Result: ${httpResponse.body}");
    String body = httpResponse.body;
    generalResponse result = generalResponse.fromJson(json.decode(body));
    return result;
  }
}
