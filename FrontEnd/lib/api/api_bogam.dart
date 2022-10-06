import 'package:http/http.dart' as http;
import 'package:image_picker/image_picker.dart';
import 'dart:convert';



class ApiBogam {
  final label = ['결막염', '궤양성각막질환', '백내장', '비궤양성각막질환', '색소침착성각막염', '안검내반증', '안검염', '안검종양', '유루증', '핵경화'];

  String api_url = "https://j7a204.p.ssafy.io";

  Future<Map<String, dynamic>> diagnosis(XFile? file) async {
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

    Map<String, dynamic> result2 = {};

    Map<String, dynamic> temp_result = json.decode(body);
    temp_result.forEach((key, value) {
      result2[label[int.parse(key)]] = value;
    });

    return result2;
  }
}
