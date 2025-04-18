import '../../../core/commons/enums/tasktype.dart';

class WheelTask {
  bool _isDummy = false;
  bool get isDummy => _isDummy;
  final String id;
  final String title;
  final String details;
  final int minuteDuration;
  final DateTime createdAt;

  WheelTask({
    required this.id,
    required this.title,
    required this.details,
    required this.minuteDuration,
    required this.createdAt,
  });

  TaskType get type => TaskType.typeFromDurationLength(minuteDuration);

  static List<WheelTask> get dummies => [
    WheelTask(
      id: DateTime.now().millisecondsSinceEpoch.toString(),
      title: "Relax",
      details: "Only chill",
      minuteDuration: 1,
      createdAt: DateTime.now(),
    )
    .._isDummy = true,

    WheelTask(
      id: DateTime.now().add(Duration(milliseconds: 20)).millisecondsSinceEpoch.toString(),
      title: "Exercise",
      details: "Start with a walk, then stretch, then do some yoga",
      minuteDuration: 1,
      createdAt: DateTime.now(),
    )
    .._isDummy = true,
  ];

  WheelTask copyWith({
    String? id,
    String? title,
    String? details,
    int? minuteDuration,
    DateTime? createdAt,
  }) {
    return WheelTask(
      id: id ?? this.id,
      title: title ?? this.title,
      details: details ?? this.details,
      minuteDuration: minuteDuration ?? this.minuteDuration,
      createdAt: createdAt ?? this.createdAt,
    );
  }

  @override
  String toString() {
    return 'Task{id: $id, title: $title, details: $details, minuteDuration: $minuteDuration, isDummy: $_isDummy}';
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    return other is WheelTask &&
        other.id == id &&
        other.title == title &&
        other.details == details &&
        other.minuteDuration == minuteDuration &&
        other._isDummy == _isDummy;
  }

  @override
  int get hashCode => id.hashCode ^ title.hashCode ^ details.hashCode ^ minuteDuration.hashCode ^ _isDummy.hashCode;
}
