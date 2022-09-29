import 'package:GSSL/model/response_models/general_response.dart';

class bogamResponse {
  bogamResult? bogamresult;

  bogamResponse(int statusCode, String message, bogamResult bogamresult) {
    this.bogamresult = bogamresult;
  }

  bogamResponse.fromJson(Map<String, dynamic> json) {
    bogamresult = json['dic'] != null ? new bogamResult.fromJson(json['dic']) : null;
  }
}

class bogamResult {
  String? one;
  String? two;
  String? three;
  String? four;
  String? five;
  String? six;
  String? seven;
  String? eight;
  String? nine;
  String? ten;

  bogamResult(
      {this.one,
        this.two,
        this.three,
        this.four,
        this.five,
        this.six,
        this.seven,
        this.eight,
        this.nine,
        this.ten}
  );

  bogamResult.fromJson(Map<String, dynamic> json) {
    one = json[0];
    two = json[1];
    three = json[2];
    four = json[3];
    five = json[4];
    six = json[5];
    seven = json[6];
    eight = json[7];
    nine = json[8];
    ten = json[9];
  }
}