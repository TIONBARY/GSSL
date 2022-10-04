import 'dart:convert';

import 'package:http/http.dart' as http;
import 'package:image_picker/image_picker.dart';
import 'package:video_compress/video_compress.dart';

class ApiJeongeum {
  String api_url = "https://j7a204.p.ssafy.io";

  Future<String> diagnosis(XFile? file) async {
    final info = await VideoCompress.compressVideo(
      file!.path,
      quality: VideoQuality.LowQuality,
      deleteOrigin: false,
      includeAudio: true,
    );
    String url = api_url + "/action";
    final httpUri = Uri.parse(url);
    var request = http.MultipartRequest('POST', httpUri);
    if (info != null) {
      final httpImage = await http.MultipartFile.fromPath(
          'info',info.file!.path);
      request.files.add(httpImage);
    }
    var response = await request.send();
    http.Response httpResponse = await http.Response.fromStream(response);
    print("Result: ${httpResponse.body}");
    String body = utf8.decode(httpResponse.bodyBytes);
    return body;
  }
}
