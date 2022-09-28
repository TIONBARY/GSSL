import '../constants/constants.dart';

class ContentObject2 {
  int? id;
  String name;
  String body;
  String? photo;

  ContentObject2({this.id, required this.name, required this.body, this.photo});

  Map<String, dynamic> toMap() {
    return {columnId: id, contentName: name, contentBody: body, contentPhoto: photo};
  }

  factory ContentObject2.fromMap(Map<String, dynamic> map) {
    return ContentObject2(id: map['id'], name: map['name'], body: map['body'], photo: map['photo']);
  }
}
