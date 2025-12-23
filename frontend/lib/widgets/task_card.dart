import 'package:flutter/material.dart';
import '../models/task.dart';
import '../services/api_service.dart';

class TaskCard extends StatefulWidget {
  final Task task;
  final VoidCallback onRefresh;

  const TaskCard({
    super.key,
    required this.task,
    required this.onRefresh,
  });

  @override
  State<TaskCard> createState() => _TaskCardState();
}

class _TaskCardState extends State<TaskCard> {
  late String status;
  late String priority;
  final api = ApiService();

  @override
  void initState() {
    super.initState();
    status = widget.task.status;
    priority = widget.task.priority;
  }

  Color priorityColor(String p) {
    switch (p) {
      case 'high':
        return Colors.red;
      case 'medium':
        return Colors.orange;
      default:
        return Colors.green;
    }
  }

  Widget menuChip({
    required String value,
    required List<String> options,
    required Color color,
    required Function(String) onSelected,
  }) {
    return PopupMenuButton<String>(
      onSelected: onSelected,
      itemBuilder: (_) => options
          .map(
            (o) => PopupMenuItem(
              value: o,
              child: Text(o.toUpperCase()),
            ),
          )
          .toList(),
      child: Chip(
        label: Text(value.toUpperCase(),
            style: const TextStyle(color: Colors.white)),
        backgroundColor: color,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Dismissible(
      key: ValueKey(widget.task.id),
      direction: DismissDirection.endToStart,
      background: Container(
        alignment: Alignment.centerRight,
        padding: const EdgeInsets.only(right: 20),
        color: Colors.red,
        child: const Icon(Icons.delete, color: Colors.white),
      ),
      onDismissed: (_) async {
        await api.deleteTask(widget.task.id);
        widget.onRefresh();
      },
      child: Card(
        margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [

            Row(
              children: [
                Expanded(
                  child: Text(
                    widget.task.title,
                    style: const TextStyle(
                        fontSize: 17, fontWeight: FontWeight.bold),
                  ),
                ),
                IconButton(
                  icon: const Icon(Icons.delete, color: Colors.red),
                  onPressed: () async {
                    await api.deleteTask(widget.task.id);
                    widget.onRefresh();
                  },
                )
              ],
            ),

            Text(widget.task.description,
                style: TextStyle(color: Colors.grey[700])),

            const SizedBox(height: 12),

            Row(
              children: [

                menuChip(
                  value: status,
                  options: ['pending', 'completed'],
                  color: status == 'completed'
                      ? Colors.green
                      : Colors.grey,
                  onSelected: (v) async {
                    setState(() => status = v);
                    await api.updateTask(widget.task.id, status: v);
                  },
                ),

                const SizedBox(width: 10),

                menuChip(
                  value: priority,
                  options: ['low', 'medium', 'high'],
                  color: priorityColor(priority),
                  onSelected: (v) async {
                    setState(() => priority = v);
                    await api.updateTask(widget.task.id, priority: v);
                  },
                ),

                const Spacer(),

                IconButton(
                  icon: const Icon(Icons.info_outline),
                  onPressed: () {
                    showModalBottomSheet(
                      context: context,
                      shape: const RoundedRectangleBorder(
                        borderRadius:
                            BorderRadius.vertical(top: Radius.circular(24)),
                      ),
                      builder: (_) => Padding(
                        padding: const EdgeInsets.all(20),
                        child: Column(
                          mainAxisSize: MainAxisSize.min,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(widget.task.title,
                                style: const TextStyle(
                                    fontSize: 18,
                                    fontWeight: FontWeight.bold)),
                            const SizedBox(height: 10),
                            Text(widget.task.description),
                            const SizedBox(height: 10),
                            Text("Status: $status"),
                            Text("Priority: $priority"),
                          ],
                        ),
                      ),
                    );
                  },
                )
              ],
            )
          ]),
        ),
      ),
    );
  }
}
