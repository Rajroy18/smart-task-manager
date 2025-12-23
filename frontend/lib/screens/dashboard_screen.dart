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

class _DashboardScreenState extends State<DashboardScreen>
    with SingleTickerProviderStateMixin {
  final api = ApiService();
  late TabController tabController;

  List<Task> tasks = [];
  bool loading = true;
  String? status;

  @override
  void initState() {
    super.initState();
    tabController = TabController(length: 3, vsync: this);
    tabController.addListener(onTabChange);
    fetchTasks();
  }

  void onTabChange() {
    if (!tabController.indexIsChanging) {
      if (tabController.index == 0) status = null;
      if (tabController.index == 1) status = "pending";
      if (tabController.index == 2) status = "completed";
      fetchTasks();
    }
  }

  Future<void> fetchTasks() async {
    setState(() => loading = true);
    tasks = await api.fetchTasks(status: status);
    setState(() => loading = false);
  }

  @override
  void dispose() {
    tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Smart Task Manager"),
        bottom: TabBar(
          controller: tabController,
          tabs: const [
            Tab(text: "All"),
            Tab(text: "Pending"),
            Tab(text: "Completed"),
          ],
        ),
      ),

      // Pull to refresh
      body: RefreshIndicator(
        onRefresh: fetchTasks,
        child: loading
            ? const Center(child: CircularProgressIndicator())
            : tasks.isEmpty
                ? const Center(child: Text("No tasks found"))
                : ListView.builder(
                    physics: const AlwaysScrollableScrollPhysics(),
                    itemCount: tasks.length,
                    itemBuilder: (_, i) => TaskCard(
                      task: tasks[i],
                      onRefresh: fetchTasks,
                    ),
                  ),
      ),

      // ADD TASK BUTTON (RESTORED)
      floatingActionButton: FloatingActionButton.extended(
        icon: const Icon(Icons.add),
        label: const Text("Add Task"),
        onPressed: () async {
          await showDialog(
            context: context,
            builder: (_) => AddTaskDialog(
              onAdded: fetchTasks,
            ),
          );
        },
      ),
    );
  }
}
