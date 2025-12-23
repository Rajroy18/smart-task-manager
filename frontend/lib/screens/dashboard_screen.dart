import 'package:flutter/material.dart';
import '../services/api_service.dart';
import '../widgets/task_card.dart';
import '../widgets/add_task_dialog.dart';
import '../models/task.dart';

class DashboardScreen extends StatefulWidget {
  const DashboardScreen({super.key});

  @override
  State<DashboardScreen> createState() => _DashboardScreenState();
}

class _DashboardScreenState extends State<DashboardScreen> {
  final api = ApiService();
  String? filter;

  Future<List<Task>> loadTasks() => api.fetchTasks(status: filter);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Smart Task Manager")),
      body: Column(
        children: [
          // FILTERS
          Padding(
            padding: const EdgeInsets.all(8),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                filterButton("All", null),
                filterButton("Pending", "pending"),
                filterButton("Completed", "completed"),
              ],
            ),
          ),

          Expanded(
            child: FutureBuilder<List<Task>>(
              future: loadTasks(),
              builder: (context, snapshot) {
                if (!snapshot.hasData) {
                  return const Center(child: CircularProgressIndicator());
                }
                return ListView(
                  children: snapshot.data!
                      .map((task) => TaskCard(
                            task: task,
                            onRefresh: () => setState(() {}),
                          ))
                      .toList(),
                );
              },
            ),
          ),
        ],
      ),

      floatingActionButton: FloatingActionButton(
        child: const Icon(Icons.add),
        onPressed: () {
          showDialog(
            context: context,
            builder: (_) =>
                AddTaskDialog(onAdded: () => setState(() {})),
          );
        },
      ),
    );
  }

  Widget filterButton(String text, String? value) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 4),
      child: ChoiceChip(
        label: Text(text),
        selected: filter == value,
        onSelected: (_) => setState(() => filter = value),
      ),
    );
  }
}
