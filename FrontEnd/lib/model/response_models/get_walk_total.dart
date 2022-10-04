import 'package:GSSL/model/response_models/general_response.dart';

class getWalkTotalInfo extends generalResponse {
  TotalInfo? totalInfo;

  getWalkTotalInfo(int statusCode, String message, TotalInfo totalInfo)
      : super(statusCode, message) {
    this.totalInfo = totalInfo;
  }

  getWalkTotalInfo.fromJson(Map<String, dynamic> json)
      : super(json['statusCode'], json['message']) {
    totalInfo = json['totalInfo'] != null
        ? new TotalInfo.fromJson(json['totalInfo'])
        : null;
  }
}

class TotalInfo {
  int? time_passed;
  int? distance_sum;

  TotalInfo({this.time_passed, this.distance_sum});

  TotalInfo.fromJson(Map<String, dynamic> json) {
    time_passed = json['time_passed'];
    distance_sum = json['distance_sum'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['time_passed'] = this.time_passed;
    data['distance_sum'] = this.distance_sum;
    return data;
  }
}
