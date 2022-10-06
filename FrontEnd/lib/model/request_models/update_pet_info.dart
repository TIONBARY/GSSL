class updatePetInfo {
  int? kindId;
  bool? species;
  String? name;
  String? gender;
  bool? neutralize;
  DateTime? birth;
  double? weight;
  String? animalPic;
  bool? death;
  String? diseases;
  String? description;

  updatePetInfo(
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

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['kind_id'] = this.kindId;
    data['species'] = this.species;
    data['name'] = this.name;
    data['gender'] = this.gender;
    data['neutralize'] = this.neutralize;
    data['birth'] = this.birth?.toIso8601String();
    data['weight'] = this.weight;
    data['animal_pic'] = this.animalPic;
    data['death'] = this.death;
    data['diseases'] = this.diseases;
    data['description'] = this.description;
    return data;
  }
}
