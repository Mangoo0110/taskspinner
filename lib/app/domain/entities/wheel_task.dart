import '../../../core/commons/enums/tasktype.dart';

class WheelTask {
  bool _isDummy = false;
  bool get isDummy => _isDummy;
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

  static List<WheelTask> get dummies => [
    WheelTask(
      id: DateTime.now().millisecondsSinceEpoch.toString(),
      type: TaskType.easy,
      title: "Relax",
      details: "Only chill",
      createdAt: DateTime.now(),
    )
    .._isDummy = true,

    WheelTask(
      id: DateTime.now().add(Duration(milliseconds: 20)).millisecondsSinceEpoch.toString(),
      type: TaskType.easy,
      title: "Exercise",
      details: "Start with a walk, then stretch, then do some yoga",
      createdAt: DateTime.now(),
    )
    .._isDummy = true,
  ];

  @override
  String toString() {
    return 'Task{id: $id, title: $title, details: $details, isDummy: $_isDummy}';
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
