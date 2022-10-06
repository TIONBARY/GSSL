class putComment {
  int? boardId;
  String? content;

  putComment({this.boardId, this.content});

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['board_id'] = this.boardId;
    data['content'] = this.content;
    return data;
  }
}
