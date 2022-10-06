import 'package:GSSL/model/response_models/general_response.dart';

class detailPetJournal extends generalResponse {
  JournalDetail? detail;

  detailPetJournal(int statusCode, String message, JournalDetail detail)
      : super(statusCode, message) {
    this.detail = detail;
  }

  detailPetJournal.fromJson(Map<String, dynamic> json)
      : super(json['statusCode'], json['message']) {
    detail = json['detail'] != null
        ? new JournalDetail.fromJson(json['detail'])
        : null;
  }
}

class JournalDetail {
  int? id;
  int? petId;
  String? picture;
  String? part;
  String? symptom;
  String? result;
  String? createdDate;

  JournalDetail(
      {this.id,
      this.petId,
      this.picture,
      this.part,
      this.symptom,
      this.result,
      this.createdDate});

  JournalDetail.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    petId = json['pet_id'];
    picture = json['picture'];
    part = json['part'];
    symptom = json['symptom'];
    result = json['result'];
    createdDate = json['created_date'];
  }
}
