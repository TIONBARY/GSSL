import 'package:GSSL/model/response_models/general_response.dart';

class getAllPet extends generalResponse {
  List<Pets>? pets;

  getAllPet(int statusCode, String message, List<Pets> pets) : super(statusCode, message){
   this.pets = pets;
  }

  getAllPet.fromJson(Map<String, dynamic> json) : super(json['statusCode'], json['message']) {
    if (json['petList'] != null) {
      pets = <Pets>[];
      json['petList'].forEach((v) {
        pets!.add(new Pets.fromJson(v));
      });
    }
  }
}

class Pets {
  int? id;
  int? userId;
  String? name;
  String? animalPic;

  Pets({this.id, this.userId, this.name, this.animalPic});

  Pets.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    userId = json['user_id'];
    name = json['name'];
    animalPic = json['animal_pic'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['user_id'] = this.userId;
    data['name'] = this.name;
    data['animal_pic'] = this.animalPic;
    return data;
  }
}