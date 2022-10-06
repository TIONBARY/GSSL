class putWalk {
  String? startTime;
  String? endTime;
  int? distance;
  List<int>? pet_ids;

  putWalk({this.startTime, this.endTime, this.distance, this.pet_ids});

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['start_time'] = this.startTime;
    data['end_time'] = this.endTime;
    data['distance'] = this.distance;
    data['pet_ids'] = this.pet_ids;
    return data;
  }
}
