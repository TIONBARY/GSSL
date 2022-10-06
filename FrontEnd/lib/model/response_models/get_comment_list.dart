import 'package:GSSL/model/response_models/general_response.dart';

class getComments extends generalResponse {
  List<Comment>? comments;

  getComments(int statusCode, String message, List<Comment> comments)
      : super(statusCode, message) {
    this.comments = comments;
  }

  getComments.fromJson(Map<String, dynamic> json)
      : super(json['statusCode'], json['message']) {
    if (json['comments'] != null) {
      comments = <Comment>[];
      json['comments'].forEach((v) {
        comments!.add(new Comment.fromJson(v));
      });
    }
  }
}

class Comment {
  int? id;
  String? nickname;
  String? image;
  String? content;
  String? time;

  Comment({this.id, this.nickname, this.image, this.content, this.time});

  Comment.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    nickname = json['nickname'];
    image = json['image'];
    content = json['content'];
    time = json['time'];
  }
}
