class deletePetJournal {
  List<int>? journalIds;

  deletePetJournal({this.journalIds});

  deletePetJournal.fromJson(Map<String, dynamic> json) {
    journalIds = json['journal_ids'].cast<int>();
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['journal_ids'] = this.journalIds;
    return data;
  }
}