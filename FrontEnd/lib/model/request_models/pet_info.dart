class petInfo {
  int? kindId;
  bool? species;
  String? name;
  int? gender;
  bool? neutralize;
  String? birth;
  double? weight;
  String? animalPic;
  bool? death;
  Null? diseases;
  String? description;

  petInfo(
      {this.kindId,
        this.species,
        this.name,
        this.gender,
        this.neutralize,
        this.birth,
        this.weight,
        this.animalPic,
        this.death,
        this.diseases,
        this.description});

  petInfo.fromJson(Map<String, dynamic> json) {
    kindId = json['kind_id'];
    species = json['species'];
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
    data['kind_id'] = this.kindId;
    data['species'] = this.species;
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