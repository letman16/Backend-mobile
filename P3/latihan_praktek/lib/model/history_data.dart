class HistoryData {
  final int id;
  final int idRef; // Ini adalah referensi ke tabel "shopping_list"
  final String event;
  final String date;

  HistoryData(this.id, this.idRef, this.event, this.date);

  Map<String, dynamic> toMap() {
    return {"id": id, "id_reff": idRef, "event": event, "date": date};
  }

  @override
  String toString() {
    return "id: $id\nid_reff: $idRef\nname: $event\nsum: $date";
  }
}
