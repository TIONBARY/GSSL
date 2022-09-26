class detailPetJournal {
  int? statusCode;
  String? message;
  JournalList? journalList;

  detailPetJournal({this.statusCode, this.message, this.journalList});

  detailPetJournal.fromJson(Map<String, dynamic> json) {
    statusCode = json['statusCode'];
    message = json['message'];
    journalList = json['journalList'] != null
        ? new JournalList.fromJson(json['journalList'])
        : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['statusCode'] = this.statusCode;
    data['message'] = this.message;
    if (this.journalList != null) {
      data['journalList'] = this.journalList!.toJson();
    }
    return data;
  }
}

class JournalList {
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

  JournalList(
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

  JournalList.fromJson(Map<String, dynamic> json) {
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
  int? journalId;
  int? petId;
  String? picture;
  String? result;
  String? createdDate;

  Content(
      {this.journalId,
        this.petId,
        this.picture,
        this.result,
        this.createdDate});

  Content.fromJson(Map<String, dynamic> json) {
    journalId = json['journal_id'];
    petId = json['pet_id'];
    picture = json['picture'];
    result = json['result'];
    createdDate = json['created_date'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['journal_id'] = this.journalId;
    data['pet_id'] = this.petId;
    data['picture'] = this.picture;
    data['result'] = this.result;
    data['created_date'] = this.createdDate;
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