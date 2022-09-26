class putWalk {
  String? startTime;
  String? endTime;
  double? distance;
  List<int>? pets;

  putWalk({this.startTime, this.endTime, this.distance, this.pets});

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['start_time'] = this.startTime;
    data['end_time'] = this.endTime;
    data['distance'] = this.distance;
    data['pets'] = this.pets;
    return data;
  }
}