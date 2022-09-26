class updateWalk {
  List<int>? pets;

  updateWalk({this.pets});

  updateWalk.fromJson(Map<String, dynamic> json) {
    pets = json['pets'].cast<int>();
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['pets'] = this.pets;
    return data;
  }
}