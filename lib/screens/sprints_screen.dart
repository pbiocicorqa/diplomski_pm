import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:pm_alat/models/pm_alat_model.dart';
import 'package:pm_alat/screens/add_sprint_screen.dart';

class SprintsScreen extends StatelessWidget {
  static const String id = 'sprints_screen';
  SprintsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final viewModel = Provider.of<PMAlatModel>(context, listen: true);

    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: const Text("Popis sprinteva"),
      ),
      body: SafeArea(
        child: Center(
          child: Padding(
            padding: const EdgeInsets.all(50),
            child: viewModel.CreationProject.projectSprints.isNotEmpty
                ? ListView.builder(
                    shrinkWrap: true,
                    itemCount: viewModel.CreationProject.projectSprints.length,
                    itemBuilder: (BuildContext context, int index) {
                      return Padding(
                        padding: const EdgeInsets.symmetric(vertical: 5),
                        child: FilledButton(
                          onPressed: () {},
                          child: Text("Sprint #${index + 1}"),
                        ),
                      );
                    },
                  )
                : const Text("Nema sprinteva"),
          ),
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.pushNamed(context, AddSprintScreen.id);
        },
        child: const Icon(Icons.add),
      ),
    );
  }
}
