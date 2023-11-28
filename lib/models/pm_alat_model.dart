import 'package:flutter/material.dart';
import 'package:pm_alat/models/task.dart';
import 'package:pm_alat/models/sprint.dart';
import 'package:pm_alat/models/project.dart';

class PMAlatModel extends ChangeNotifier {
  Project _creationProject = Project(
    projectName: '',
    projectCreator: '',
    projectMembers: <String>[],
    projectTasks: <Task>[],
    projectSprints: <Sprint>[],
  );

  Project get CreationProject => _creationProject;
  set CreationProject(Project value) => _creationProject = value;

  void clearCreationProject() {
    _creationProject = Project(
      projectName: '',
      projectCreator: '',
      projectMembers: <String>[],
      projectTasks: <Task>[],
      projectSprints: <Sprint>[],
    );
  }

  void addTask(Task task) {
    _creationProject.projectTasks.add(task);
    notifyListeners();
  }

  void removeTask(Task task) {
    _creationProject.projectTasks.remove(task);
    notifyListeners();
  }

  void addSprint(Sprint sprint) {
    _creationProject.projectSprints.add(sprint);
    notifyListeners();
  }

  Project? _currentProject;
  Project? get CurrentProject => _currentProject;

  void UpdateCurrentProject(Project project) {
    _currentProject = project;
  }

  Task? _editingTask;
  Task? get EditingTask => _editingTask;
  void UpdateEditingTask(Task task) {
    _editingTask = task;
    notifyListeners();
  }
}
