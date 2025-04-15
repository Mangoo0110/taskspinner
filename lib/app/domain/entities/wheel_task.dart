import '../../../core/commons/enums/tasktype.dart';

class WheelTask {
  final String id;
  final TaskType type;
  final String title;
  final String details;
  final DateTime createdAt;

  WheelTask({
    required this.id,
    required this.type,
    required this.title,
    required this.details,
    required this.createdAt,
  });

  @override
  String toString() {
    return 'Task{id: $id, title: $title, details: $details}';
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    return other is WheelTask &&
        other.id == id &&
        other.title == title &&
        other.details == details;
  }

  @override
  int get hashCode => id.hashCode ^ title.hashCode ^ details.hashCode;
}
