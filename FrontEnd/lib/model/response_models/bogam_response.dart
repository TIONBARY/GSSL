class bogamResponse {
  int? one;
  int? two;
  int? three;
  int? four;
  int? five;
  int? six;
  int? seven;
  int? eight;
  int? nine;
  int? ten;

  bogamResponse(
      {this.one,
        this.two,
        this.three,
        this.four,
        this.five,
        this.six,
        this.seven,
        this.eight,
        this.nine,
        this.ten}
      );

  bogamResponse.fromJson(Map<String, dynamic> json) {
    one = json['0'];
    two = json['1'];
    three = json['2'];
    four = json['3'];
    five = json['4'];
    six = json['5'];
    seven = json['6'];
    eight = json['7'];
    nine = json['8'];
    ten = json['9'];
  }
}