class getWalkList {
  int? statusCode;
  String? message;
  WalkList? walkList;

  getWalkList({this.statusCode, this.message, this.walkList});

  getWalkList.fromJson(Map<String, dynamic> json) {
    statusCode = json['statusCode'];
    message = json['message'];
    walkList = json['walkList'] != null
        ? new WalkList.fromJson(json['walkList'])
        : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['statusCode'] = this.statusCode;
    data['message'] = this.message;
    if (this.walkList != null) {
      data['walkList'] = this.walkList!.toJson();
    }
    return data;
  }
}

class WalkList {
  List<Content>? content;
  String? pageable;
  bool? last;
  int? totalElements;
  int? totalPages;
  int? number;
  int? size;
  Sort? sort;
  int? numberOfElements;
  bool? first;
  bool? empty;

  WalkList(
      {this.content,
        this.pageable,
        this.last,
        this.totalElements,
        this.totalPages,
        this.number,
        this.size,
        this.sort,
        this.numberOfElements,
        this.first,
        this.empty});

  WalkList.fromJson(Map<String, dynamic> json) {
    if (json['content'] != null) {
      content = <Content>[];
      json['content'].forEach((v) {
        content!.add(new Content.fromJson(v));
      });
    }
    pageable = json['pageable'];
    last = json['last'];
    totalElements = json['totalElements'];
    totalPages = json['totalPages'];
    number = json['number'];
    size = json['size'];
    sort = json['sort'] != null ? new Sort.fromJson(json['sort']) : null;
    numberOfElements = json['numberOfElements'];
    first = json['first'];
    empty = json['empty'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    if (this.content != null) {
      data['content'] = this.content!.map((v) => v.toJson()).toList();
    }
    data['pageable'] = this.pageable;
    data['last'] = this.last;
    data['totalElements'] = this.totalElements;
    data['totalPages'] = this.totalPages;
    data['number'] = this.number;
    data['size'] = this.size;
    if (this.sort != null) {
      data['sort'] = this.sort!.toJson();
    }
    data['numberOfElements'] = this.numberOfElements;
    data['first'] = this.first;
    data['empty'] = this.empty;
    return data;
  }
}

class Content {
  String? startTime;
  String? endTime;
  int? distance;
  List<WalkPetsList>? walkPetsList;

  Content({this.startTime, this.endTime, this.distance, this.walkPetsList});

  Content.fromJson(Map<String, dynamic> json) {
    startTime = json['start_time'];
    endTime = json['end_time'];
    distance = json['distance'];
    if (json['walkPetsList'] != null) {
      walkPetsList = <WalkPetsList>[];
      json['walkPetsList'].forEach((v) {
        walkPetsList!.add(new WalkPetsList.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['start_time'] = this.startTime;
    data['end_time'] = this.endTime;
    data['distance'] = this.distance;
    if (this.walkPetsList != null) {
      data['walkPetsList'] = this.walkPetsList!.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class WalkPetsList {
  int? id;
  int? userId;
  String? name;
  String? gender;
  String? animalPic;

  WalkPetsList({this.id, this.userId, this.name, this.gender, this.animalPic});

  WalkPetsList.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    userId = json['user_id'];
    name = json['name'];
    gender = json['gender'];
    animalPic = json['animal_pic'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['user_id'] = this.userId;
    data['name'] = this.name;
    data['gender'] = this.gender;
    data['animal_pic'] = this.animalPic;
    return data;
  }
}

class Sort {
  bool? empty;
  bool? sorted;
  bool? unsorted;

  Sort({this.empty, this.sorted, this.unsorted});

  Sort.fromJson(Map<String, dynamic> json) {
    empty = json['empty'];
    sorted = json['sorted'];
    unsorted = json['unsorted'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['empty'] = this.empty;
    data['sorted'] = this.sorted;
    data['unsorted'] = this.unsorted;
    return data;
  }
}