import 'package:flutter/material.dart';
import 'package:calendar_date_picker2/calendar_date_picker2.dart';
import 'package:pm_alat/models/pm_alat_model.dart';
import 'package:pm_alat/models/sprint.dart';
import 'package:pm_alat/models/task_type.dart';
import 'package:provider/provider.dart';

class AddSprintScreen extends StatefulWidget {
  static const String id = 'add_sprint_screen';
  const AddSprintScreen({super.key});

  @override
  State<AddSprintScreen> createState() => _AddSprintScreenState();
}

class _AddSprintScreenState extends State<AddSprintScreen> {
  List<bool> values = [];
  List<DateTime?> _dates = [];

  @override
  Widget build(BuildContext context) {
    final viewModel = Provider.of<PMAlatModel>(context, listen: false);

    for (var task in viewModel.CreationProject.projectTasks) {
      if (task.taskType == TaskType.story) {
        values.add(false);
      }
    }

    return Scaffold(
      appBar: AppBar(centerTitle: true, title: const Text("Izrada sprinta")),
      body: SafeArea(
        child: Center(
          child: Padding(
            padding: const EdgeInsets.all(25),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Text("Datum početka i završetka:", style: TextStyle(fontSize: 16)),
                const SizedBox(height: 20),
                CalendarDatePicker2(
                  config: CalendarDatePicker2Config(calendarType: CalendarDatePicker2Type.range),
                  value: _dates,
                  onValueChanged: (dates) => _dates = dates,
                ),
                const Text("Odabrani zadaci:", style: TextStyle(fontSize: 16)),
                const SizedBox(height: 20),
                Expanded(
                  child: ListView.builder(
                    shrinkWrap: true,
                    itemCount: viewModel.CreationProject.projectTasks
                        .where((task) => task.taskType == TaskType.story)
                        .length,
                    itemBuilder: (BuildContext context, int index) {
                      return Visibility(
                        visible: viewModel.CreationProject.projectTasks
                                .where((task) => task.taskType == TaskType.story)
                                .elementAt(index)
                                .sprintId ==
                            -1,
                        child: CheckboxListTile(
                          title: Text(viewModel.CreationProject.projectTasks
                              .where((task) => task.taskType == TaskType.story)
                              .elementAt(index)
                              .taskName),
                          controlAffinity: ListTileControlAffinity.leading,
                          value: values[index],
                          onChanged: (bool? value) {
                            if (value is bool) setState(() => values[index] = value);
                          },
                        ),
                      );
                    },
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          final viewModel = Provider.of<PMAlatModel>(context, listen: false);

          var project = viewModel.CreationProject;
          var sprintId = project.projectSprints.length;

          for (int i = 0; i < project.projectTasks.length; i++) {
            if (values[i]) project.projectTasks[i].sprintId = sprintId;
          }

          var sprint = Sprint(
            sprintId: sprintId,
            startDate: _dates[0]!,
            endDate: _dates[1]!,
          );

          viewModel.addSprint(sprint);
          Navigator.pop(context);
        },
        child: const Icon(Icons.check),
      ),
    );
  }
}
