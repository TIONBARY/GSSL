class putComment {
  int? userId;
  int? boardId;
  String? content;

  putComment({this.userId, this.boardId, this.content});

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['user_id'] = this.userId;
    data['board_id'] = this.boardId;
    data['content'] = this.content;
    return data;
  }
}