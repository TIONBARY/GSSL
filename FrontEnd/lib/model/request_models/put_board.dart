class putBoard {
  int? typeId;
  String? title;
  String? content;

  putBoard({this.typeId, this.title, this.content});

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['type_id'] = this.typeId;
    data['title'] = this.title;
    data['content'] = this.content;
    return data;
  }
}