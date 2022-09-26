class userUpdate {
  String? memberId;
  String? password;
  String? nickname;
  bool? gender;
  String? phone;
  String? email;
  Null? profilePic;
  String? introduce;
  int? petId;

  userUpdate(
      {this.memberId,
        this.password,
        this.nickname,
        this.gender,
        this.phone,
        this.email,
        this.profilePic,
        this.introduce,
        this.petId});

  userUpdate.fromJson(Map<String, dynamic> json) {
    memberId = json['member_id'];
    password = json['password'];
    nickname = json['nickname'];
    gender = json['gender'];
    phone = json['phone'];
    email = json['email'];
    profilePic = json['profile_pic'];
    introduce = json['introduce'];
    petId = json['pet_id'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['member_id'] = this.memberId;
    data['password'] = this.password;
    data['nickname'] = this.nickname;
    data['gender'] = this.gender;
    data['phone'] = this.phone;
    data['email'] = this.email;
    data['profile_pic'] = this.profilePic;
    data['introduce'] = this.introduce;
    data['pet_id'] = this.petId;
    return data;
  }
}