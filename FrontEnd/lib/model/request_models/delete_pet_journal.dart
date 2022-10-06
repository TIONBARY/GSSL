class deletePetJournal {
  List<int>? journalIds;

  deletePetJournal({this.journalIds});

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['journal_ids'] = this.journalIds;
    return data;
  }
}