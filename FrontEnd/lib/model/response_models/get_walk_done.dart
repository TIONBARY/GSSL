import 'package:GSSL/model/response_models/general_response.dart';

class getWalkDone extends generalResponse {
  bool? done;

  getWalkDone(int statusCode, String message, bool done)
      : super(statusCode, message) {
    this.done = done;
  }

  getWalkDone.fromJson(Map<String, dynamic> json)
      : super(json['statusCode'], json['message']) {
    done = json['done'];
  }
}
