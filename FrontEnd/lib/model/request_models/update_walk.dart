class updateWalk {
  List<int>? pets;

  updateWalk({this.pets});

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['pets'] = this.pets;
    return data;
  }
}