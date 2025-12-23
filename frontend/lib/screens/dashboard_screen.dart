import 'package:flutter/material.dart';
import '../models/task.dart';
import '../services/api_service.dart';
import '../widgets/task_card.dart';
import '../widgets/add_task_dialog.dart';

class DashboardScreen extends StatefulWidget {
  const DashboardScreen({super.key});

  @override
  State<DashboardScreen> createState() => _DashboardScreenState();
}

class _DashboardScreenState extends State<DashboardScreen> {
  String selectedStatus = "all";
  late Future<List<Task>> tasksFuture;

  void loadTasks() {
    tasksFuture = ApiService.fetchTasks(
      status: selectedStatus == "all" ? null : selectedStatus,
    );
  }

  @override
  void initState() {
    super.initState();
    loadTasks();
  }

  void deleteTask(String id) async {
    await ApiService.deleteTask(id);
    setState(loadTasks);
  }

  Widget statusTab(String label, String value) {
    return ChoiceChip(
      label: Text(label),
      selected: selectedStatus == value,
      onSelected: (_) {
        setState(() {
          selectedStatus = value;
          loadTasks();
        });
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Smart Task Manager")),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          showDialog(
            context: context,
            builder: (_) => AddTaskDialog(onAdded: () {
              setState(loadTasks);
            }),
          );
        },
        child: const Icon(Icons.add),
      ),
      body: Column(
        children: [
          const SizedBox(height: 8),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              statusTab("All", "all"),
              const SizedBox(width: 8),
              statusTab("Pending", "pending"),
              const SizedBox(width: 8),
              statusTab("Completed", "completed"),
            ],
          ),
          const SizedBox(height: 8),
          Expanded(
            child: FutureBuilder<List<Task>>(
              future: tasksFuture,
              builder: (context, snapshot) {
                if (snapshot.connectionState ==
                    ConnectionState.waiting) {
                  return const Center(
                      child: CircularProgressIndicator());
                }

                if (snapshot.hasError) {
                  return const Center(
                      child: Text("Failed to load tasks"));
                }

                final tasks = snapshot.data!;
                if (tasks.isEmpty) {
                  return const Center(
                      child: Text("No tasks found"));
                }

                return RefreshIndicator(
                  onRefresh: () async {
                    setState(loadTasks);
                  },
                  child: ListView.builder(
                    padding: const EdgeInsets.all(16),
                    itemCount: tasks.length,
                    itemBuilder: (_, i) => TaskCard(
                      task: tasks[i],
                      onDelete: () {
                        showDialog(
                          context: context,
                          builder: (_) => AlertDialog(
                            title: const Text("Delete Task"),
                            content: const Text(
                                "Are you sure you want to delete this task?"),
                            actions: [
                              TextButton(
                                onPressed: () =>
                                    Navigator.pop(context),
                                child: const Text("Cancel"),
                              ),
                              TextButton(
                                onPressed: () {
                                  Navigator.pop(context);
                                  deleteTask(tasks[i].id);
                                },
                                child: const Text(
                                  "Delete",
                                  style:
                                      TextStyle(color: Colors.red),
                                ),
                              ),
                            ],
                          ),
                        );
                      },
                    ),
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}
