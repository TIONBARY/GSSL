import 'package:GSSL/model/response_models/general_response.dart';

class getBoardDetail extends generalResponse {
  Board? board;

  getBoardDetail(int statusCode, String message, Board board)
      : super(statusCode, message) {
    this.board = board;
  }

  getBoardDetail.fromJson(Map<String, dynamic> json)
      : super(json['statusCode'], json['message']) {
    board = json['board'] != null ? new Board.fromJson(json['board']) : null;
  }
}

class Board {
  int? id;
  String? nickname;
  int? typeId;
  String? title;
  String? image;
  String? content;
  String? time;
  int? views;

  Board(
      {this.id,
      this.nickname,
      this.typeId,
      this.title,
      this.image,
      this.content,
      this.time,
      this.views});

  Board.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    nickname = json['nickname'];
    typeId = json['type_id'];
    title = json['title'];
    image = json['image'];
    content = json['content'];
    time = json['time'];
    views = json['views'];
  }
}
