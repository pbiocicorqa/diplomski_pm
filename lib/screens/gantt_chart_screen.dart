import 'package:dynamic_timeline/dynamic_timeline.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:pm_alat/models/pm_alat_model.dart';
import 'package:pm_alat/models/task_type.dart';
import 'package:pm_alat/widgets/event.dart';
import 'package:provider/provider.dart';

class GanttChartScreen extends StatefulWidget {
  static const String id = 'gantt_chart_screen';
  const GanttChartScreen({super.key});

  @override
  State<GanttChartScreen> createState() => _GanttChartScreenState();
}

class _GanttChartScreenState extends State<GanttChartScreen> {
  late final ScrollController scrollController;

  @override
  void initState() {
    super.initState();
    scrollController = ScrollController();
  }

  @override
  void dispose() {
    scrollController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final viewModel = Provider.of<PMAlatModel>(context, listen: true);
    int index = -1;

    String getTaskTypeName(TaskType taskType) {
      switch (taskType) {
        case TaskType.story:
          return "Korisnička priča";
        case TaskType.epic:
          return "Epic";
        case TaskType.initiative:
          return "Inicijativa";
      }
    }

    return Scaffold(
      appBar: AppBar(centerTitle: true, title: const Text("Gantogram")),
      body: SafeArea(
        child: Center(
          child: Padding(
            padding: const EdgeInsets.all(10),
            child: Scrollbar(
              controller: scrollController,
              thumbVisibility: true,
              child: SingleChildScrollView(
                scrollDirection: Axis.horizontal,
                controller: scrollController,
                child: DynamicTimeline(
                  firstDateTime: DateTime.now(),
                  lastDateTime: DateTime(2023, 12, 31),
                  labelBuilder: (date) => DateFormat('dd.MM.').format(date),
                  axis: Axis.horizontal,
                  intervalDuration: const Duration(days: 1),
                  minItemDuration: const Duration(days: 1),
                  crossAxisCount: 12,
                  intervalExtent: 50,
                  maxCrossAxisItemExtent: 30,
                  items: viewModel.CurrentProject!.projectTasks
                      .where(
                    (task) =>
                        task.taskType == TaskType.epic || task.taskType == TaskType.initiative,
                  )
                      .map<TimelineItem>((task) {
                    index++;
                    return TimelineItem(
                      startDateTime: task.startDate,
                      endDateTime: task.endDate,
                      position: index,
                      child: Event(title: "${task.taskName} (${getTaskTypeName(task.taskType)})"),
                    );
                  }).toList(),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
