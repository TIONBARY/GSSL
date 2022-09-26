class userInfo {
  int? statusCode;
  User? user;

  userInfo({this.statusCode, this.user});

  userInfo.fromJson(Map<String, dynamic> json) {
    statusCode = json['statusCode'];
    user = json['user'] != null ? new User.fromJson(json['user']) : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['statusCode'] = this.statusCode;
    if (this.user != null) {
      data['user'] = this.user!.toJson();
    }
    return data;
  }
}

class User {
  String? memberId;
  String? nickname;
  bool? gender;
  String? phone;
  String? email;
  Null? profilePic;
  Null? introduce;
  Null? petId;
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