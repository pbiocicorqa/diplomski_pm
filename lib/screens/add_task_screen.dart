import 'package:flutter/material.dart';
import 'package:pm_alat/models/pm_alat_model.dart';
import 'package:pm_alat/models/task.dart';
import 'package:pm_alat/models/task_type.dart';
import 'package:pm_alat/models/task_priority.dart';
import 'package:calendar_date_picker2/calendar_date_picker2.dart';
import 'package:provider/provider.dart';

class AddTaskScreen extends StatefulWidget {
  static const String id = 'add_task_screen';
  const AddTaskScreen({super.key});

  @override
  State<AddTaskScreen> createState() => _AddTaskScreenState();
}

class _AddTaskScreenState extends State<AddTaskScreen> {
  final TextEditingController _controllerName = TextEditingController();
  final TextEditingController _controllerDescription = TextEditingController();

  List<DateTime?> _dates = [];
  List<Task> availableTasks = [];
  String _selectedMember = '';
  Task? _selectedTask;
  TaskType _taskType = TaskType.story;
  TaskPriority _taskPriority = TaskPriority.low;

  @override
  Widget build(BuildContext context) {
    final viewModel = Provider.of<PMAlatModel>(context, listen: false);

    if (_selectedMember == '') {
      _selectedMember = viewModel.CreationProject.projectMembers[0];
    }

    final task = ModalRoute.of(context)!.settings.arguments as Task?;
    final isEditMode = task != null;

    if (isEditMode) {
      _controllerName.text = task.taskName;
      _controllerDescription.text = task.taskDescription;
      _dates.add(task.startDate);
      _dates.add(task.endDate);
      _taskPriority = task.taskPriority;
      _taskType = task.taskType;
      _selectedMember = task.assignedUser;
    }

    return Scaffold(
      appBar: AppBar(centerTitle: true, title: const Text("Izrada zadatka")),
      body: SafeArea(
        child: Center(
          child: Padding(
            padding: const EdgeInsets.all(40),
            child: SingleChildScrollView(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  TextField(
                    controller: _controllerName,
                    decoration: const InputDecoration(
                      border: OutlineInputBorder(),
                      labelText: "Naziv zadatka",
                    ),
                  ),
                  const SizedBox(height: 40),
                  TextField(
                    controller: _controllerDescription,
                    decoration: const InputDecoration(
                      border: OutlineInputBorder(),
                      labelText: "Opis zadatka",
                    ),
                  ),
                  const SizedBox(height: 40),
                  const Text("Datum početka i završetka:", style: TextStyle(fontSize: 16)),
                  const SizedBox(height: 20),
                  CalendarDatePicker2(
                    config: CalendarDatePicker2Config(calendarType: CalendarDatePicker2Type.range),
                    value: _dates,
                    onValueChanged: (dates) => _dates = dates,
                  ),
                  DropdownButton(
                    items: const [
                      DropdownMenuItem(value: TaskPriority.low, child: Text("Niski")),
                      DropdownMenuItem(value: TaskPriority.medium, child: Text("Srednji")),
                      DropdownMenuItem(value: TaskPriority.high, child: Text("Visoki")),
                    ],
                    value: _taskPriority,
                    onChanged: (TaskPriority? value) {
                      if (value is TaskPriority) setState(() => _taskPriority = value);
                    },
                  ),
                  const SizedBox(height: 20),
                  DropdownButton(
                    items: const [
                      DropdownMenuItem(value: TaskType.story, child: Text("Korisnička priča")),
                      DropdownMenuItem(value: TaskType.epic, child: Text("Epic")),
                      DropdownMenuItem(value: TaskType.initiative, child: Text("Inicijativa")),
                    ],
                    value: _taskType,
                    onChanged: (TaskType? value) {
                      if (value is TaskType) {
                        setState(() {
                          switch (value) {
                            case TaskType.initiative:
                              availableTasks = [];
                              _selectedTask = null;
                              break;
                            case TaskType.epic:
                              availableTasks = viewModel.CreationProject.projectTasks
                                  .where((task) => task.taskType == TaskType.initiative)
                                  .toList();
                              _selectedTask = availableTasks.isNotEmpty ? availableTasks[0] : null;
                              break;
                            case TaskType.story:
                              availableTasks = viewModel.CreationProject.projectTasks
                                  .where((task) => task.taskType == TaskType.epic)
                                  .toList();
                              _selectedTask = availableTasks.isNotEmpty ? availableTasks[0] : null;
                              break;
                          }

                          _taskType = value;
                        });
                      }
                    },
                  ),
                  const SizedBox(height: 20),
                  DropdownButton<Task>(
                    items: availableTasks.map<DropdownMenuItem<Task>>((Task value) {
                      return DropdownMenuItem(value: value, child: Text(value.taskName));
                    }).toList(),
                    value: _selectedTask,
                    onChanged: (Task? value) {
                      if (value is Task) setState(() => _selectedTask = value);
                    },
                  ),
                  const SizedBox(height: 20),
                  DropdownButton<String>(
                    items: viewModel.CreationProject.projectMembers
                        .map<DropdownMenuItem<String>>((String value) {
                      return DropdownMenuItem(value: value, child: Text(value));
                    }).toList(),
                    value: _selectedMember,
                    onChanged: (String? value) {
                      if (value is String) setState(() => _selectedMember = value);
                    },
                  ),
                  const SizedBox(height: 20),
                  Visibility(
                    visible: isEditMode,
                    child: FilledButton(
                      style: FilledButton.styleFrom(backgroundColor: Colors.red),
                      onPressed: () {
                        if (task != null) {
                          viewModel.removeTask(task);
                          Navigator.pop(context);
                        }
                      },
                      child: const Text("Obriši zadatak"),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          final viewModel = Provider.of<PMAlatModel>(context, listen: false);

          var task = Task(
            taskId: viewModel.CreationProject.projectTasks.length,
            taskName: _controllerName.text,
            taskDescription: _controllerDescription.text,
            startDate: _dates[0]!,
            endDate: _dates[1]!,
            taskPriority: _taskPriority,
            taskType: _taskType,
            assignedUser: _selectedMember,
          );

          if (isEditMode) {
            viewModel.removeTask(task);
          }

          viewModel.addTask(task);
          Navigator.pop(context);
        },
        child: const Icon(Icons.check),
      ),
    );
  }
}
