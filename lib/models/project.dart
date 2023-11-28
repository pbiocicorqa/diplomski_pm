import 'package:pm_alat/models/task.dart';
import 'package:pm_alat/models/sprint.dart';

class Project {
  String projectId;
  String projectName;
  String projectCreator;
  List<String> projectMembers;
  List<Task> projectTasks;
  List<Sprint> projectSprints;

  Project({
    this.projectId = '',
    required this.projectName,
    required this.projectCreator,
    required this.projectMembers,
    this.projectTasks = const [],
    this.projectSprints = const [],
  });

  factory Project.fromjson(Map<String, dynamic> json, String id) {
    return Project(
      projectId: id,
      projectName: json['projectName'],
      projectCreator: json['projectCreator'],
      projectMembers: List<String>.from(json['projectMembers']),
    );
  }

  Map<String, dynamic> tojson() {
    return {
      'projectName': projectName,
      'projectCreator': projectCreator,
      'projectMembers': projectMembers,
    };
  }
}
