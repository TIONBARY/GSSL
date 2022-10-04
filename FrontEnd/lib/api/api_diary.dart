import 'dart:convert';
import 'dart:io';

import 'package:GSSL/api/interceptor.dart';
import 'package:GSSL/model/request_models/put_pet_journal.dart';
import 'package:GSSL/model/request_models/update_board.dart';
import 'package:GSSL/model/response_models/detail_pet_journal.dart';
import 'package:GSSL/model/response_models/general_response.dart';
import 'package:GSSL/model/response_models/get_journal_list.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:http/http.dart' as http;
import 'package:http_interceptor/http/http.dart';
import 'package:http_parser/http_parser.dart';
import 'package:image_picker/image_picker.dart';

import '../model/request_models/batch_delete_journal.dart';

class ApiDiary {
  final client = InterceptedClient.build(interceptors: [ApiInterceptor()]);

  String api_url = "https://j7a204.p.ssafy.io/api/journal";
  final storage = new FlutterSecureStorage();

  Future<generalResponse> register(
      XFile? file, putPetJournal requestModel) async {
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
      'journal',
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

  Future<detailPetJournal> getJournalDetailApi(int? journalId) async {
    String url = api_url + "/" + journalId.toString();
    final response = await client.get(Uri.parse(url));
    detailPetJournal result =
        detailPetJournal.fromJson(json.decode(response.body));
    return result;
  }

  Future<getJournalList> getAllJournalApi(int page, int size) async {
    final response = await client
        .get(Uri.parse(api_url), params: {"page": page, "size": size});
    print(json.decode(response.body));
    getJournalList result = getJournalList.fromJson(json.decode(response.body));
    return result;
  }

  //
  Future<generalResponse> modify(
      File? file, int? boardId, updateBoard requestModel) async {
    final httpUri = Uri.parse(api_url + "/" + boardId.toString());
    String? accessToken = await storage.read(key: "Authorization");
    Map<String, String> headers = {"Authorization": "Bearer " + accessToken!};
    var request = http.MultipartRequest('PUT', httpUri);
    request.headers.addAll(headers);
    if (file != null) {
      final httpImage = await http.MultipartFile.fromPath('file', file!.path);
      request.files.add(httpImage);
    }
    request.files.add(http.MultipartFile.fromBytes(
      'board',
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

  //
  Future<generalResponse> deleteAPI(int? boardId) async {
    final response =
        await client.delete(Uri.parse(api_url + "/" + boardId.toString()));
    generalResponse result =
        generalResponse.fromJson(json.decode(response.body));
    return result;
  }

  Future<generalResponse> deleteAllAPI(List<int> journalIds) async {
    final response = await client.post(Uri.parse(api_url + '/delete'),
        body: jsonEncode(batchDeleteJournal(journalIds).toJson()));
    generalResponse result =
        generalResponse.fromJson(json.decode(response.body));
    return result;
  }
}
