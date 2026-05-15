class Task {
  final String id;
  final String title;
  final bool isCompleted;
  final int priority;
  final DateTime? dueDate;

  Task({
    required this.id,
    required this.title,
    this.isCompleted = false,
    this.priority = 1,
    this.dueDate,
  });

  factory Task.fromJson(Map<String, dynamic> json) {
    return Task(
      id: json['id'],
      title: json['title'],
      isCompleted: json['is_completed'],
      priority: json['priority'],
      dueDate: json['due_date'] != null ? DateTime.parse(json['due_date']) : null,
    );
  }

  Map<String, dynamic> toJson() => {
    'title': title,
    'is_completed': isCompleted,
    'priority': priority,
    'due_date': dueDate?.toIso8601String(),
  };
}