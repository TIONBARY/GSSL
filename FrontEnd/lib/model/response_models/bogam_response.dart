import 'package:GSSL/model/response_models/general_response.dart';

class bogamResponse extends generalResponse {
  int? statusCode;
  bogamResult? bogamresult;

  bogamResponse(int statusCode, String message, bogamResult bogamresult) : super(statusCode, message) {
    this.bogamresult = bogamresult;
  }

  bogamResponse.fromJson(Map<String, dynamic> json): super(json['statusCode'], json['message'])  {
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
        this.ten});

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

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['member_id'] = this.one;
    data['nickname'] = this.two;
    data['gender'] = this.three;
    data['phone'] = this.four;
    data['email'] = this.five;
    data['profile_pic'] = this.six;
    data['introduce'] = this.seven;
    data['pet_id'] = this.eight;
    data['leave'] = this.nine;
    data['leave'] = this.ten;
    return data;
  }
}