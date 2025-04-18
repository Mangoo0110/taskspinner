enum TaskType { 
  easy, 
  medium, 
  hard;

  String get name {
    switch (this) {
      case TaskType.easy:
        return "Easy";
      case TaskType.medium:
        return "Medium";
      case TaskType.hard:
        return "Hard";
    }
  }

  factory TaskType.fromString(String name) {
    switch (name) {
      case "Easy":
        return TaskType.easy;
      case "Medium":
        return TaskType.medium;
      case "Hard":
        return TaskType.hard;
      default:
        throw Exception("Invalid TaskType");
    }
  }

  factory TaskType.typeFromDurationLength(int minutes) {
    return minutes > 30 ? TaskType.hard : minutes > 5 ? TaskType.medium : TaskType.easy;
  }
}
