

import '../../../core/commons/enums/tasktype.dart';
import '../../../core/helpers/formatting.dart';
import '../../domain/entities/wheel_task.dart';

class WheelTaskModel extends WheelTask {
  WheelTaskModel({
    required super.id,
    required super.type,
    required super.title,
    required super.details,
    required super.createdAt,
  });

  factory WheelTaskModel.fromMap(Map<String, dynamic> map) {
    return WheelTaskModel(
      id: map['id'] as String,
      type: TaskType.fromString(map['type'] ?? ""),
      title: map['title'] as String,
      details: map['details'] as String,
      createdAt: parseDateTime(map['createdAt'] ?? ""),
    );
  }

  factory WheelTaskModel.fromEntity(WheelTask entity) {
    return WheelTaskModel(
      id: entity.id,
      type: entity.type,
      title: entity.title,
      details: entity.details,
      createdAt: entity.createdAt,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'type': type.name,
      'title': title,
      'details': details,
      'createdAt': createdAt.toIso8601String(),
    };
  }
}
