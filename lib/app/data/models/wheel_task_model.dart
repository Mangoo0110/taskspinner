
import '../../../core/helpers/formatting.dart';
import '../../domain/entities/wheel_task.dart';

class WheelTaskModel extends WheelTask {
  WheelTaskModel({
    required super.id,
    required super.title,
    required super.details,
    required super.minuteDuration,
    required super.createdAt,
  });

  factory WheelTaskModel.fromMap(Map<String, dynamic> map) {
    return WheelTaskModel(
      id: map['id'] as String,
      title: map['title'] as String,
      details: map['details'] as String,
      minuteDuration: map["minuteDuration"] ?? 1,
      createdAt: parseDateTime(map['createdAt'] ?? ""),
    );
  }

  factory WheelTaskModel.fromEntity(WheelTask entity) {
    return WheelTaskModel(
      id: entity.id,
      minuteDuration: entity.minuteDuration,
      title: entity.title,
      details: entity.details,
      createdAt: entity.createdAt,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'minuteDuration': minuteDuration,
      'title': title,
      'details': details,
      'createdAt': createdAt.toIso8601String(),
    };
  }
}
