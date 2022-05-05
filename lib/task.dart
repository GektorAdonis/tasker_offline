class Task {
  int? id;
  String title;
  DateTime date;
  int isComplete;

  Task({
    this.id,
    required this.title,
    required this.date,
    this.isComplete = 0,
  });

  factory Task.fromMap(Map<String, dynamic> json) => Task(
        id: json['id'],
        title: json['title'],
        date: DateTime.parse(json['date']),
        isComplete: json['isComplete'],
      );

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'title': title,
      'date': date.toIso8601String(),
      'isComplete': isComplete,
    };
  }
}
