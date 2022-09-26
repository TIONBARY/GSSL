class singup {
  String? memberId;
  String? password;
  String? nickname;
  String? gender;
  String? phone;
  String? email;
  String? introduce;

  singup(
      {this.memberId,
        this.password,
        this.nickname,
        this.gender,
        this.phone,
        this.email,
        this.introduce});

  singup.fromJson(Map<String, dynamic> json) {
    memberId = json['member_id'];
    password = json['password'];
    nickname = json['nickname'];
    gender = json['gender'];
    phone = json['phone'];
    email = json['email'];
    introduce = json['introduce'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['member_id'] = this.memberId;
    data['password'] = this.password;
    data['nickname'] = this.nickname;
    data['gender'] = this.gender;
    data['phone'] = this.phone;
    data['email'] = this.email;
    data['introduce'] = this.introduce;
    return data;
  }
}