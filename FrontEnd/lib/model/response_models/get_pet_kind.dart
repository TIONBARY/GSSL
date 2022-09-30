import 'package:GSSL/model/response_models/general_response.dart';

class GetPetKind extends generalResponse {
  Kind? kind;

  GetPetKind(int statusCode, String message, Kind kind)
      : super(statusCode, message) {
    this.kind = kind;
  }

  GetPetKind.fromJson(Map<String, dynamic> json)
      : super(json['statusCode'], json['message']) {
    if (json['petKind'] != null) {
      kind = Kind.fromJson(json['petKind']);
    }
  }
}

class Kind {
  int? id;
  String? name;

  Kind({this.id, this.name});

  Kind.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    name = json['name'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['name'] = this.name;
    return data;
  }
}
