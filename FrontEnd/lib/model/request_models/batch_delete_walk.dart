class batchDeleteWalk {
  List<int>? walkIds;

  batchDeleteWalk(this.walkIds);

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    if (this.walkIds != null) {
      data['walk_ids'] = this.walkIds!.map((v) => v.toString()).toList();
    }
    return data;
  }
}
