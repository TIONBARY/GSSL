class updateWalk {
  List<int>? pets;

  updateWalk(this.pets);

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    if (this.pets != null) {
      data['pet_ids'] = this.pets!.map((v) => v.toString()).toList();
    }
    return data;
  }
}
