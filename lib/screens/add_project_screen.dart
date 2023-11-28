import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:pm_alat/models/pm_alat_model.dart';
import 'package:pm_alat/screens/sprints_screen.dart';
import 'package:pm_alat/screens/tasks_screen.dart';
import 'package:provider/provider.dart';

class AddProjectScreen extends StatefulWidget {
  static const String id = 'add_project_screen';
  const AddProjectScreen({super.key});

  @override
  State<AddProjectScreen> createState() => _AddProjectScreenState();
}

class _AddProjectScreenState extends State<AddProjectScreen> {
  final TextEditingController _controllerName = TextEditingController();
  final TextEditingController _controllerMembers = TextEditingController();

  @override
  Widget build(BuildContext context) {
    final viewModel = Provider.of<PMAlatModel>(context, listen: true);
    _controllerName.text = viewModel.CreationProject.projectName;
    _controllerMembers.text = viewModel.CreationProject.projectMembers.join(',');

    final isEditMode = ModalRoute.of(context)!.settings.arguments as bool;

    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        centerTitle: true,
        title: const Text("Izrada projekta"),
        leading: IconButton(
          icon: Icon(Icons.arrow_back),
          onPressed: () {
            viewModel.clearCreationProject();
            Navigator.pop(context);
          },
        ),
      ),
      body: SafeArea(
        child: Center(
          child: Padding(
            padding: const EdgeInsets.all(50),
            child: SingleChildScrollView(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  TextField(
                    controller: _controllerName,
                    decoration: const InputDecoration(
                      border: OutlineInputBorder(),
                      labelText: "Naziv projekta",
                    ),
                  ),
                  const SizedBox(height: 40),
                  TextField(
                    controller: _controllerMembers,
                    decoration: const InputDecoration(
                      border: OutlineInputBorder(),
                      labelText: "Članovi",
                    ),
                  ),
                  const SizedBox(height: 40),
                  const Text("Zadaci:", style: TextStyle(fontSize: 18)),
                  const SizedBox(height: 20),
                  SizedBox(
                    width: double.infinity,
                    child: FilledButton(
                      onPressed: () {
                        updateProject();
                        Navigator.pushNamed(context, TasksScreen.id);
                      },
                      child: const Text("Popis zadataka"),
                    ),
                  ),
                  const SizedBox(height: 40),
                  const Text("Sprintevi:", style: TextStyle(fontSize: 18)),
                  const SizedBox(height: 20),
                  SizedBox(
                    width: double.infinity,
                    child: FilledButton(
                      onPressed: () {
                        updateProject();
                        Navigator.pushNamed(context, SprintsScreen.id);
                      },
                      child: const Text("Popis sprinteva"),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () async {
          final viewModel = Provider.of<PMAlatModel>(context, listen: false);

          viewModel.CreationProject.projectName = _controllerName.text;
          viewModel.CreationProject.projectMembers = _controllerMembers.text.split(',');
          viewModel.CreationProject.projectCreator = FirebaseAuth.instance.currentUser!.email!;

          var projectsCollection = FirebaseFirestore.instance.collection('projects');

          if (isEditMode) {
            await projectsCollection.get().then((snapshot) {
              for (var ds in snapshot.docs) {
                if (ds.id == viewModel.CreationProject.projectId) {
                  ds.reference.delete();
                }
              }
            });
          }

          await projectsCollection.add(viewModel.CreationProject.tojson()).then((value) {
            var tasksCollection = projectsCollection.doc(value.id).collection('tasks');
            for (var task in viewModel.CreationProject.projectTasks) {
              tasksCollection.add(task.tojson());
            }

            var sprintsCollection = projectsCollection.doc(value.id).collection('sprints');
            for (var sprint in viewModel.CreationProject.projectSprints) {
              sprintsCollection.add(sprint.tojson());
            }
          });

          // viewModel.UpdateCurrentProject(viewModel.CreationProject);
          viewModel.clearCreationProject();
          Navigator.pop(context);
        },
        child: const Icon(Icons.check),
      ),
    );
  }

  void updateProject() {
    final viewModel = Provider.of<PMAlatModel>(context, listen: false);

    viewModel.CreationProject.projectName = _controllerName.text;
    viewModel.CreationProject.projectMembers = _controllerMembers.text.split(',');
    viewModel.CreationProject.projectCreator = FirebaseAuth.instance.currentUser!.email!;
  }
}
