import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:pm_alat/models/pm_alat_model.dart';
import 'package:pm_alat/models/task.dart';
import 'package:pm_alat/models/task_status.dart';
import 'package:provider/provider.dart';

class TaskScreen extends StatefulWidget {
  static const String id = 'task_screen';
  const TaskScreen({super.key});

  @override
  State<TaskScreen> createState() => _TaskScreenState();
}

class _TaskScreenState extends State<TaskScreen> {
  final List<int> _timeValues = [0, 1, 2, 3, 4, 5, 6, 7, 8];

  TaskStatus _taskStatus = TaskStatus.open;
  int _trackTime = 0;

  @override
  Widget build(BuildContext context) {
    final viewModel = Provider.of<PMAlatModel>(context, listen: true);

    return Scaffold(
      appBar: AppBar(centerTitle: true, title: Text(viewModel.EditingTask!.taskName)),
      body: SafeArea(
        child: Center(
          child: Padding(
            padding: const EdgeInsets.all(40),
            child: SingleChildScrollView(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Text("Zabilježi sate:", style: TextStyle(fontSize: 16)),
                  const SizedBox(height: 10),
                  DropdownButton(
                    items: _timeValues.map<DropdownMenuItem<int>>((int value) {
                      return DropdownMenuItem(value: value, child: Text(value.toString()));
                    }).toList(),
                    value: _trackTime,
                    onChanged: (int? value) {
                      if (value is int) setState(() => _trackTime = value);
                    },
                  ),
                  const SizedBox(height: 40),
                  const Text("Status:", style: TextStyle(fontSize: 16)),
                  const SizedBox(height: 10),
                  DropdownButton(
                    items: const [
                      DropdownMenuItem(value: TaskStatus.open, child: Text("Otvoreno")),
                      DropdownMenuItem(value: TaskStatus.active, child: Text("Aktivno")),
                      DropdownMenuItem(value: TaskStatus.closed, child: Text("Zatvoreno")),
                    ],
                    value: _taskStatus,
                    onChanged: (TaskStatus? value) {
                      if (value is TaskStatus) setState(() => _taskStatus = value);
                    },
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () async {
          viewModel.EditingTask!.trackedTime += _trackTime;
          viewModel.EditingTask!.taskStatus = _taskStatus;

          String taskId = '';
          await FirebaseFirestore.instance
              .collection('projects')
              .doc(viewModel.CurrentProject!.projectId)
              .collection('tasks')
              .get()
              .then((snapshot) {
            snapshot.docs.map((doc) {
              var task = Task.fromjson(doc.data());
              if (task.taskId == viewModel.EditingTask!.taskId) {
                taskId = doc.id;
              }
            }).toList();
          });

          await FirebaseFirestore.instance
              .collection('projects')
              .doc(viewModel.CurrentProject!.projectId)
              .collection('tasks')
              .doc(taskId)
              .update(viewModel.EditingTask!.tojson());

          viewModel.UpdateEditingTask(viewModel.EditingTask!);
          Navigator.pop(context);
        },
        child: const Icon(Icons.check),
      ),
    );
  }
}
