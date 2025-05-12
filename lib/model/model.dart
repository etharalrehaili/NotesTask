class Note {
  int? id;
  String text;
  bool isDone;

  Note({this.id, required this.text, this.isDone = false});

  Map<String, dynamic> toMap() {
    return {'id': id, 'text': text, 'isDone': isDone ? 1 : 0};
  }

  factory Note.fromMap(Map<String, dynamic> map) {
    return Note(id: map['id'], text: map['text'], isDone: map['isDone'] == 1);
  }
}
