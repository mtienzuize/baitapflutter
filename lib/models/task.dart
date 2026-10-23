class Task {
  final int id;
  final String title;
  final String description;
  bool isDone;
  final DateTime? dueDate;

  Task({
    required this.id,
    required this.title,
    required this.description,
    this.isDone = false,
    this.dueDate,
  });
}