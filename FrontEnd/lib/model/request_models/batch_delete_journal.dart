class batchDeleteJournal {
  List<int>? journalIds;

  batchDeleteJournal(this.journalIds);

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    if (this.journalIds != null) {
      data['journal_ids'] = this.journalIds!.map((v) => v.toString()).toList();
    }
    return data;
  }
}
