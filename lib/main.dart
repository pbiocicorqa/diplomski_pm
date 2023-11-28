import 'package:flutter/material.dart';
import 'package:pm_alat/models/pm_alat_model.dart';
import 'package:pm_alat/screens/gantt_chart_screen.dart';
import 'package:provider/provider.dart';
import 'package:pm_alat/firebase_options.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:pm_alat/screens/add_project_screen.dart';
import 'package:pm_alat/screens/add_sprint_screen.dart';
import 'package:pm_alat/screens/add_task_screen.dart';
import 'package:pm_alat/screens/home_screen.dart';
import 'package:pm_alat/screens/projects_screen.dart';
import 'package:pm_alat/screens/sprints_screen.dart';
import 'package:pm_alat/screens/task_screen.dart';
import 'package:pm_alat/screens/tasks_screen.dart';
import 'package:pm_alat/screens/welcome_screen.dart';
import 'package:pm_alat/screens/login_register_screen.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);
  runApp(const PMAlat());
}

class PMAlat extends StatelessWidget {
  const PMAlat({super.key});

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (context) => PMAlatModel(),
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        title: 'PM Alat',
        initialRoute: WelcomeScreen.id,
        routes: {
          WelcomeScreen.id: (context) => WelcomeScreen(),
          LoginRegisterScreen.id: (context) => LoginRegisterScreen(),
          ProjectsScreen.id: (context) => ProjectsScreen(),
          AddProjectScreen.id: (context) => AddProjectScreen(),
          TasksScreen.id: (context) => TasksScreen(),
          AddTaskScreen.id: (context) => AddTaskScreen(),
          SprintsScreen.id: (context) => SprintsScreen(),
          AddSprintScreen.id: (context) => AddSprintScreen(),
          HomeScreen.id: (context) => HomeScreen(),
          TaskScreen.id: (context) => TaskScreen(),
          GanttChartScreen.id: (context) => GanttChartScreen(),
        },
      ),
    );
  }
}
