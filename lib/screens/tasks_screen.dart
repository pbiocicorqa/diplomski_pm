import 'package:flutter/material.dart';
import 'package:pm_alat/models/pm_alat_model.dart';
import 'package:pm_alat/screens/add_task_screen.dart';
import 'package:provider/provider.dart';

class TasksScreen extends StatelessWidget {
  static const String id = 'tasks_screen';
  TasksScreen({super.key});

  final List<String> entries = <String>['Zadatak #1', 'Zadatak #2', 'Zadatak #3'];

  @override
  Widget build(BuildContext context) {
    final viewModel = Provider.of<PMAlatModel>(context, listen: true);

    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: const Text("Popis zadataka"),
      ),
      body: SafeArea(
        child: Center(
          child: Padding(
            padding: const EdgeInsets.all(50),
            child: viewModel.CreationProject.projectTasks.isNotEmpty
                ? ListView.builder(
                    shrinkWrap: true,
                    itemCount: viewModel.CreationProject.projectTasks.length,
                    itemBuilder: (BuildContext context, int index) {
                      return Padding(
                        padding: const EdgeInsets.symmetric(vertical: 5),
                        child: FilledButton(
                          onPressed: () {
                            Navigator.pushNamed(context, AddTaskScreen.id,
                                arguments: viewModel.CreationProject.projectTasks[index]);
                          },
                          child: Text(viewModel.CreationProject.projectTasks[index].taskName),
                        ),
                      );
                    },
                  )
                : const Text("Nema zadataka"),
          ),
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.pushNamed(context, AddTaskScreen.id);
        },
        child: const Icon(Icons.add),
      ),
    );
  }
}
