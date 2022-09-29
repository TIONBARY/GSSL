import 'package:GSSL/model/response_models/general_response.dart';
import 'package:image_picker/image_picker.dart';

class userInfo extends generalResponse {
  int? statusCode;
  User? user;

  userInfo(int statusCode, String message, User user) : super(statusCode, message) {
    this.user = user;
  }

  userInfo.fromJson(Map<String, dynamic> json): super(json['statusCode'], json['message'])  {
    user = json['userInfoDto'] != null ? new User.fromJson(json['userInfoDto']) : null;
  }
}

class User {
  String? memberId;
  String? nickname;
  String? gender;
  String? phone;
  String? email;
  String? profilePic;
  String? introduce;
  int? petId;
  bool? leave;

  User(
      {this.memberId,
        this.nickname,
        this.gender,
        this.phone,
        this.email,
        this.profilePic,
        this.introduce,
        this.petId,
        this.leave});

  User.fromJson(Map<String, dynamic> json) {
    memberId = json['member_id'];
    nickname = json['nickname'];
    gender = json['gender'];
    phone = json['phone'];
    email = json['email'];
    profilePic = json['profile_pic'];
    introduce = json['introduce'];
    petId = json['pet_id'];
    leave = json['leave'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['member_id'] = this.memberId;
    data['nickname'] = this.nickname;
    data['gender'] = this.gender;
    data['phone'] = this.phone;
    data['email'] = this.email;
    data['profile_pic'] = this.profilePic;
    data['introduce'] = this.introduce;
    data['pet_id'] = this.petId;
    data['leave'] = this.leave;
    return data;
  }
}