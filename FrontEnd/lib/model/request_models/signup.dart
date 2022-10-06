import 'package:GSSL/components/signup/signup_form.dart';

class Signup {
  String? memberId;
  String? password;
  String? nickname;
  String? gender;
  String? phone;
  String? email;
  String? introduce;

  Signup(
      {this.memberId,
        this.password,
        this.nickname,
        this.gender,
        this.phone,
        this.email,
        this.introduce});

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