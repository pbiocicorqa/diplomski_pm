import 'package:pm_alat/models/task_type.dart';
import 'package:pm_alat/models/task_status.dart';
import 'package:pm_alat/models/task_priority.dart';

class Task {
  int taskId;
  String taskName;
  String taskDescription;
  DateTime startDate;
  DateTime endDate;
  TaskPriority taskPriority;
  TaskType taskType;
  String assignedUser;
  TaskStatus taskStatus;
  int trackedTime;
  int sprintId;
  int linkedTaskId;

  Task({
    required this.taskId,
    required this.taskName,
    required this.taskDescription,
    required this.startDate,
    required this.endDate,
    required this.taskPriority,
    required this.taskType,
    required this.assignedUser,
    this.taskStatus = TaskStatus.open,
    this.trackedTime = 0,
    this.sprintId = -1,
    this.linkedTaskId = -1,
  });

  factory Task.fromjson(Map<String, dynamic> json) {
    return Task(
      taskId: json['taskId'],
      taskName: json['taskName'],
      taskDescription: json['taskDescription'],
      startDate: DateTime.parse(json['startDate']),
      endDate: DateTime.parse(json['endDate']),
      taskPriority: TaskPriority.values.elementAt(json['taskPriority']),
      taskType: TaskType.values.elementAt(json['taskType']),
      assignedUser: json['assignedUser'],
      taskStatus: TaskStatus.values.elementAt(json['taskStatus']),
      trackedTime: json['trackedTime'],
      sprintId: json['sprintId'],
      linkedTaskId: json['linkedTaskId'],
    );
  }

  Map<String, dynamic> tojson() {
    return {
      'taskId': taskId,
      'taskName': taskName,
      'taskDescription': taskDescription,
      'startDate': startDate.toIso8601String(),
      'endDate': endDate.toIso8601String(),
      'taskPriority': taskPriority.index,
      'taskType': taskType.index,
      'assignedUser': assignedUser,
      'taskStatus': taskStatus.index,
      'trackedTime': trackedTime,
      'sprintId': sprintId,
      'linkedTaskId': linkedTaskId,
    };
  }
}
