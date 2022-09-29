import 'package:GSSL/model/response_models/bogam_response.dart';
import 'package:GSSL/model/response_models/general_response.dart';
import 'package:http/http.dart' as http;
import 'package:image_picker/image_picker.dart';
import 'dart:convert';
import '../model/request_models/signup.dart';
import 'package:http_parser/http_parser.dart';


class ApiBogam {

  String api_url = "https://j7a204.p.ssafy.io";

  Future<bogamResponse> diagnosis(XFile? file) async {
    String url = api_url + "/eye/temp";
    final httpUri = Uri.parse(url);
    var request = http.MultipartRequest('POST', httpUri);
    if (file != null) {
      final httpImage = await http.MultipartFile.fromPath(
          'file', file.path);
      request.files.add(httpImage);
    }
    var response = await request.send();
    http.Response httpResponse = await http.Response.fromStream(response);
    print("Result: ${httpResponse.body}");
    String body = httpResponse.body;
    bogamResponse result = bogamResponse.fromJson(json.decode(body));
    return result;
  }
}
