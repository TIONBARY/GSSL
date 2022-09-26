class getAllPet {
  int? statusCode;
  String? message;
  List<Pets>? pets;

  getAllPet({this.statusCode, this.message, this.pets});

  getAllPet.fromJson(Map<String, dynamic> json) {
    statusCode = json['statusCode'];
    message = json['message'];
    if (json['pets'] != null) {
      pets = <Pets>[];
      json['pets'].forEach((v) {
        pets!.add(new Pets.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['statusCode'] = this.statusCode;
    data['message'] = this.message;
    if (this.pets != null) {
      data['pets'] = this.pets!.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class Pets {
  String? id;
  String? userId;
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