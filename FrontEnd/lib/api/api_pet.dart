import 'dart:convert';

import 'package:GSSL/api/interceptor.dart';
import 'package:GSSL/model/request_models/pet_info.dart';
import 'package:GSSL/model/response_models/general_response.dart';
import 'package:GSSL/model/response_models/get_all_pet.dart';
import 'package:GSSL/model/response_models/get_all_pet_kind.dart';
import 'package:GSSL/model/response_models/get_pet_detail.dart';
import 'package:GSSL/model/response_models/get_pet_kind.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:http/http.dart' as http;
import 'package:http_interceptor/http/http.dart';
import 'package:http_parser/http_parser.dart';
import 'package:image_picker/image_picker.dart';

class ApiPet {
  final client = InterceptedClient.build(interceptors: [ApiInterceptor()]);

  String api_url = "https://j7a204.p.ssafy.io/api/pet";
  final storage = new FlutterSecureStorage();

  Future<getAllPetKind> getPetKind() async {
    String url = api_url + "/kind";
    final response = await client.get(Uri.parse(url));
    getAllPetKind result = getAllPetKind.fromJson(json.decode(response.body));
    return result;
  }

  Future<GetPetKind> getPetKindOne(int kindId) async {
    String url = api_url + "/kind/" + kindId.toString();
    final response = await client.get(Uri.parse(url));
    GetPetKind result = GetPetKind.fromJson(json.decode(response.body));
    return result;
  }

  Future<generalResponse> register(XFile? file, petInfo requestModel) async {
    final httpUri = Uri.parse(api_url);
    String? accessToken = await storage.read(key: "Authorization");
    Map<String, String> headers = {"Authorization": "Bearer " + accessToken!};
    var request = http.MultipartRequest('POST', httpUri);
    request.headers.addAll(headers);
    if (file != null) {
      final httpImage = await http.MultipartFile.fromPath('file', file.path);
      request.files.add(httpImage);
    }
    request.files.add(http.MultipartFile.fromBytes(
      'pet',
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

  Future<getPetDetail> getPetDetailApi(int? petId) async {
    String url = api_url + "/" + petId.toString();
    final response = await client.get(Uri.parse(url));
    getPetDetail result = getPetDetail.fromJson(json.decode(response.body));
    return result;
  }

  Future<getAllPet> getAllPetApi() async {
    final response = await client.get(Uri.parse(api_url));
    getAllPet result = getAllPet.fromJson(json.decode(response.body));
    return result;
  }
}
