class getPetDetail {
  int? statusCode;
  String? message;
  Pet? pet;

  getPetDetail({this.statusCode, this.message, this.pet});

  getPetDetail.fromJson(Map<String, dynamic> json) {
    statusCode = json['statusCode'];
    message = json['message'];
    pet = json['pet'] != null ? new Pet.fromJson(json['pet']) : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['statusCode'] = this.statusCode;
    data['message'] = this.message;
    if (this.pet != null) {
      data['pet'] = this.pet!.toJson();
    }
    return data;
  }
}

class Pet {
  String? id;
  String? userId;
  String? species;
  String? kind;
  String? name;
  String? gender;
  bool? neutralize;
  String? birth;
  double? weight;
  String? animalPic;
  bool? death;
  Null? diseases;
  String? description;

  Pet(
      {this.id,
        this.userId,
        this.species,
        this.kind,
        this.name,
        this.gender,
        this.neutralize,
        this.birth,
        this.weight,
        this.animalPic,
        this.death,
        this.diseases,
        this.description});

  Pet.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    userId = json['user_id'];
    species = json['species'];
    kind = json['kind'];
    name = json['name'];
    gender = json['gender'];
    neutralize = json['neutralize'];
    birth = json['birth'];
    weight = json['weight'];
    animalPic = json['animal_pic'];
    death = json['death'];
    diseases = json['diseases'];
    description = json['description'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['user_id'] = this.userId;
    data['species'] = this.species;
    data['kind'] = this.kind;
    data['name'] = this.name;
    data['gender'] = this.gender;
    data['neutralize'] = this.neutralize;
    data['birth'] = this.birth;
    data['weight'] = this.weight;
    data['animal_pic'] = this.animalPic;
    data['death'] = this.death;
    data['diseases'] = this.diseases;
    data['description'] = this.description;
    return data;
  }
}