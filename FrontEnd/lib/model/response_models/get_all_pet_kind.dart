import 'package:GSSL/model/response_models/general_response.dart';

class getAllPetKind extends generalResponse {
  List<Kind>? kinds;

  getAllPetKind(int statusCode, String message, List<Kind> kinds) : super(statusCode, message){
    this.kinds = kinds;
  }

  getAllPetKind.fromJson(Map<String, dynamic> json) : super(json['statusCode'], json['message']) {
    if (json['petKindList'] != null) {
      kinds = <Kind>[];
      json['petKindList'].forEach((v) {
        kinds!.add(new Kind.fromJson(v));
      });
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