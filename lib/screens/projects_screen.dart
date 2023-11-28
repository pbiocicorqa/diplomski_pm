import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:pm_alat/models/pm_alat_model.dart';
import 'package:pm_alat/models/project.dart';
import 'package:pm_alat/models/sprint.dart';
import 'package:pm_alat/models/task.dart';
import 'package:pm_alat/screens/add_project_screen.dart';
import 'package:pm_alat/screens/home_screen.dart';
import 'package:pm_alat/screens/welcome_screen.dart';
import 'package:provider/provider.dart';

class ProjectsScreen extends StatelessWidget {
  static const String id = 'projects_screen';
  ProjectsScreen({super.key});

  Stream<List<Project>> getProjects() {
    var project = FirebaseFirestore.instance
        .collection('projects')
        .snapshots(includeMetadataChanges: true)
        .map((snapshot) => snapshot.docs.map((doc) {
              var project = Project.fromjson(doc.data(), doc.id);
              getTasks(project, doc.id);
              getSprints(project, doc.id);
              return project;
            }).toList());

    return project;
  }

  void getTasks(Project project, String docId) async {
    List<Task> tasks = [];

    await FirebaseFirestore.instance
        .collection('projects')
        .doc(docId)
        .collection('tasks')
        .get()
        .then((snapshot) {
      tasks = snapshot.docs.map((doc) => Task.fromjson(doc.data())).toList();
    });

    project.projectTasks = tasks;
  }

  void getSprints(Project project, String docId) async {
    List<Sprint> sprints = [];

    await FirebaseFirestore.instance
        .collection('projects')
        .doc(docId)
        .collection('sprints')
        .get()
        .then((snapshot) {
      sprints = snapshot.docs.map((doc) => Sprint.fromjson(doc.data())).toList();
    });

    project.projectSprints = sprints;
  }

  @override
  Widget build(BuildContext context) {
    getProjects();
    return WillPopScope(
      onWillPop: () async => false,
      child: Scaffold(
        appBar: AppBar(
          automaticallyImplyLeading: false,
          centerTitle: true,
          title: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Container(width: 35),
              const Text("Popis projekata"),
              IconButton(
                onPressed: () {
                  FirebaseAuth.instance.signOut().then((value) {
                    Navigator.popUntil(context, ModalRoute.withName(WelcomeScreen.id));
                  }).onError((error, stackTrace) {
                    print(error.toString());
                  });
                },
                icon: const Icon(Icons.logout),
              ),
            ],
          ),
        ),
        body: SafeArea(
          child: Center(
            child: Padding(
              padding: const EdgeInsets.all(50),
              child: StreamBuilder(
                stream: getProjects(),
                builder: (context, snapshot) {
                  if (snapshot.hasData && snapshot.data!.isNotEmpty) {
                    var userProjects = snapshot.data!.where((project) {
                      List<String> members = [];
                      for (var member in project.projectMembers) {
                        members.add(member.trim());
                      }

                      return project.projectCreator == FirebaseAuth.instance.currentUser?.email ||
                          members.contains(FirebaseAuth.instance.currentUser?.email);
                    }).toList();

                    return ListView.builder(
                      shrinkWrap: true,
                      itemCount: userProjects.length,
                      itemBuilder: (BuildContext context, int index) {
                        return Padding(
                          padding: const EdgeInsets.symmetric(vertical: 5),
                          child: FilledButton(
                            onPressed: () {
                              final viewModel = Provider.of<PMAlatModel>(context, listen: false);
                              viewModel.UpdateCurrentProject(userProjects[index]);
                              Navigator.pushNamed(context, HomeScreen.id);
                            },
                            child: Text(userProjects[index].projectName),
                          ),
                        );
                      },
                    );
                  } else {
                    return const Text("Nema projekata");
                  }
                },
              ),
            ),
          ),
        ),
        floatingActionButton: FloatingActionButton(
          onPressed: () {
            Navigator.pushNamed(context, AddProjectScreen.id, arguments: false);
          },
          child: const Icon(Icons.add),
        ),
      ),
    );
  }
}
