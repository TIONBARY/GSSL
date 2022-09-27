class putPetJournal {
  Null? picture;
  int? petId;
  String? part;
  String? symptom;
  String? result;

  putPetJournal(
      {this.picture, this.petId, this.part, this.symptom, this.result});

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['picture'] = this.picture;
    data['pet_id'] = this.petId;
    data['part'] = this.part;
    data['symptom'] = this.symptom;
    data['result'] = this.result;
    return data;
  }
}