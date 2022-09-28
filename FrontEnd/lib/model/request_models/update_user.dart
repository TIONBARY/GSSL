class updateUser {
  String? memberId;
  String? password;
  String? nickname;
  bool? gender;
  String? phone;
  String? email;
  Null? profilePic;
  String? introduce;
  int? petId;

  updateUser(
      {this.memberId,
        this.password,
        this.nickname,
        this.gender,
        this.phone,
        this.email,
        this.profilePic,
        this.introduce,
        this.petId});

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