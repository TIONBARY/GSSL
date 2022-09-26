class putWalk {
  String? startTime;
  String? endTime;
  double? distance;
  List<int>? pets;

  putWalk({this.startTime, this.endTime, this.distance, this.pets});

  putWalk.fromJson(Map<String, dynamic> json) {
    startTime = json['start_time'];
    endTime = json['end_time'];
    distance = json['distance'];
    pets = json['pets'].cast<int>();
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['start_time'] = this.startTime;
    data['end_time'] = this.endTime;
    data['distance'] = this.distance;
    data['pets'] = this.pets;
    return data;
  }
}