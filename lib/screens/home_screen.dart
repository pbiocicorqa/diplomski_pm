import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:pm_alat/models/pm_alat_model.dart';
import 'package:pm_alat/models/task_priority.dart';
import 'package:pm_alat/models/task_status.dart';
import 'package:pm_alat/screens/add_project_screen.dart';
import 'package:pm_alat/screens/gantt_chart_screen.dart';
import 'package:pm_alat/screens/task_screen.dart';
import 'package:pm_alat/screens/welcome_screen.dart';
import 'package:provider/provider.dart';
import 'package:intl/intl.dart';

class HomeScreen extends StatelessWidget {
  static const String id = 'home_screen';
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final viewModel = Provider.of<PMAlatModel>(context, listen: true);

    return WillPopScope(
      onWillPop: () async => false,
      child: Scaffold(
        appBar: AppBar(
          automaticallyImplyLeading: false,
          title: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Row(
                children: [
                  Text(viewModel.CurrentProject!.projectName, style: TextStyle(fontSize: 16)),
                  TextButton(
                    onPressed: () {
                      Navigator.pop(context);
                    },
                    child: const Icon(Icons.arrow_drop_down, color: Colors.white),
                  ),
                ],
              ),
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
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Expanded(
                  child: ListView.builder(
                    shrinkWrap: true,
                    itemCount: viewModel.CurrentProject!.projectSprints.length,
                    itemBuilder: (context, index) {
                      return Visibility(
                        visible: viewModel.CurrentProject!.projectTasks
                            .where((task) =>
                                (task.sprintId ==
                                    viewModel.CurrentProject!.projectSprints[index].sprintId) &&
                                (task.assignedUser.trim() ==
                                        FirebaseAuth.instance.currentUser?.email ||
                                    viewModel.CurrentProject!.projectCreator ==
                                        FirebaseAuth.instance.currentUser?.email))
                            .isNotEmpty,
                        child: Padding(
                          padding: const EdgeInsets.symmetric(vertical: 25, horizontal: 50),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                  "Sprint #${index + 1} (${DateFormat('dd.MM.').format(viewModel.CurrentProject!.projectSprints[index].startDate)} - ${DateFormat('dd.MM.').format(viewModel.CurrentProject!.projectSprints[index].endDate)})",
                                  style: const TextStyle(fontSize: 18)),
                              const SizedBox(height: 20),
                              ListView.builder(
                                itemCount: viewModel.CurrentProject!.projectTasks
                                    .where((task) =>
                                        (task.sprintId ==
                                            viewModel
                                                .CurrentProject!.projectSprints[index].sprintId) &&
                                        (task.assignedUser.trim() ==
                                                FirebaseAuth.instance.currentUser?.email ||
                                            viewModel.CurrentProject!.projectCreator ==
                                                FirebaseAuth.instance.currentUser?.email))
                                    .length,
                                shrinkWrap: true,
                                physics: const ClampingScrollPhysics(),
                                itemBuilder: (context, jndex) {
                                  return Padding(
                                    padding: const EdgeInsets.symmetric(vertical: 10),
                                    child: OutlinedButton(
                                      style: OutlinedButton.styleFrom(
                                        padding:
                                            const EdgeInsets.symmetric(vertical: 5, horizontal: 15),
                                      ),
                                      onPressed: () {
                                        viewModel.UpdateEditingTask(viewModel
                                            .CurrentProject!.projectTasks
                                            .where((task) =>
                                                task.sprintId ==
                                                viewModel
                                                    .CurrentProject!.projectSprints[index].sprintId)
                                            .elementAt(jndex));
                                        Navigator.pushNamed(context, TaskScreen.id);
                                      },
                                      child: Column(
                                        children: [
                                          Text(
                                            viewModel.CurrentProject!.projectTasks
                                                .where((task) =>
                                                    task.sprintId ==
                                                    viewModel.CurrentProject!.projectSprints[index]
                                                        .sprintId)
                                                .elementAt(jndex)
                                                .taskName,
                                            style: const TextStyle(
                                                fontSize: 16, fontWeight: FontWeight.bold),
                                          ),
                                          SizedBox(height: 10),
                                          Text(
                                            viewModel.CurrentProject!.projectTasks
                                                .where((task) =>
                                                    task.sprintId ==
                                                    viewModel.CurrentProject!.projectSprints[index]
                                                        .sprintId)
                                                .elementAt(jndex)
                                                .taskDescription,
                                            style: const TextStyle(fontSize: 16),
                                          ),
                                          SizedBox(height: 10),
                                          Row(
                                            mainAxisAlignment: MainAxisAlignment.center,
                                            children: [
                                              Text(
                                                "${viewModel.CurrentProject!.projectTasks.where((task) => task.sprintId == viewModel.CurrentProject!.projectSprints[index].sprintId).elementAt(jndex).trackedTime}h",
                                                style: const TextStyle(fontSize: 16),
                                              ),
                                              const Text("   -   "),
                                              Text(
                                                viewModel.CurrentProject!.projectTasks
                                                            .where((task) =>
                                                                task.sprintId ==
                                                                viewModel.CurrentProject!
                                                                    .projectSprints[index].sprintId)
                                                            .elementAt(jndex)
                                                            .taskPriority ==
                                                        TaskPriority.low
                                                    ? "Niski"
                                                    : viewModel.CurrentProject!.projectTasks
                                                                .where((task) =>
                                                                    task.sprintId ==
                                                                    viewModel
                                                                        .CurrentProject!
                                                                        .projectSprints[index]
                                                                        .sprintId)
                                                                .elementAt(jndex)
                                                                .taskPriority ==
                                                            TaskPriority.medium
                                                        ? "Srednji"
                                                        : "Visoki",
                                                style: TextStyle(
                                                    fontSize: 16,
                                                    color: viewModel.CurrentProject!.projectTasks
                                                                .where((task) =>
                                                                    task.sprintId ==
                                                                    viewModel
                                                                        .CurrentProject!
                                                                        .projectSprints[index]
                                                                        .sprintId)
                                                                .elementAt(jndex)
                                                                .taskPriority ==
                                                            TaskPriority.low
                                                        ? Colors.green
                                                        : viewModel.CurrentProject!.projectTasks
                                                                    .where((task) =>
                                                                        task.sprintId ==
                                                                        viewModel
                                                                            .CurrentProject!
                                                                            .projectSprints[index]
                                                                            .sprintId)
                                                                    .elementAt(jndex)
                                                                    .taskPriority ==
                                                                TaskPriority.medium
                                                            ? Colors.orange
                                                            : Colors.red),
                                              ),
                                              const Text("   -   "),
                                              Text(
                                                viewModel.CurrentProject!.projectTasks
                                                            .where((task) =>
                                                                task.sprintId ==
                                                                viewModel.CurrentProject!
                                                                    .projectSprints[index].sprintId)
                                                            .elementAt(jndex)
                                                            .taskStatus ==
                                                        TaskStatus.open
                                                    ? "Otvoreno"
                                                    : viewModel.CurrentProject!.projectTasks
                                                                .where((task) =>
                                                                    task.sprintId ==
                                                                    viewModel
                                                                        .CurrentProject!
                                                                        .projectSprints[index]
                                                                        .sprintId)
                                                                .elementAt(jndex)
                                                                .taskStatus ==
                                                            TaskStatus.active
                                                        ? "Aktivno"
                                                        : "Zatvoreno",
                                                style: const TextStyle(fontSize: 16),
                                              ),
                                            ],
                                          )
                                        ],
                                      ),
                                    ),
                                  );
                                },
                              ),
                            ],
                          ),
                        ),
                      );
                    },
                  ),
                )
              ],
            ),
          ),
        ),
        bottomNavigationBar: Visibility(
          visible:
              viewModel.CurrentProject!.projectCreator == FirebaseAuth.instance.currentUser!.email,
          child: Container(
            height: 56,
            color: Colors.blue,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                TextButton(
                  onPressed: () {
                    viewModel.CreationProject = viewModel.CurrentProject!;
                    Navigator.popAndPushNamed(context, AddProjectScreen.id, arguments: true);
                  },
                  child: const Text(
                    "Upravljanje projektom",
                    style: TextStyle(color: Colors.white),
                  ),
                ),
                TextButton(
                  onPressed: () {
                    Navigator.pushNamed(context, GanttChartScreen.id);
                  },
                  child: const Text(
                    "Gantogram",
                    style: TextStyle(color: Colors.white),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
