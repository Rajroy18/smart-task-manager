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
    status = widget.task.status.toLowerCase();
    priority = widget.task.priority.toLowerCase();
  }

  Color priorityColor(String p) {
    switch (p) {
      case 'high':
        return Colors.redAccent;
      case 'medium':
        return Colors.orangeAccent;
      default:
        return Colors.green;
    }
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
        elevation: 3,
        margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(18)),
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [

            /// TITLE + DELETE
            Row(
              children: [
                Expanded(
                  child: Text(
                    widget.task.title,
                    style: const TextStyle(
                      fontSize: 17,
                      fontWeight: FontWeight.bold,
                    ),
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

            Text(
              widget.task.description,
              style: TextStyle(color: Colors.grey[700]),
            ),

            const SizedBox(height: 14),

            /// ACTION BAR
            Row(
              children: [

                /// STATUS
                DropdownButton<String>(
                  value: status,
                  underline: const SizedBox(),
                  items: ['pending', 'completed']
                      .map((s) => DropdownMenuItem(
                            value: s,
                            child: Text(s.toUpperCase()),
                          ))
                      .toList(),
                  onChanged: (v) async {
                    if (v == null || v == status) return;
                    setState(() => status = v);
                    await api.updateTask(widget.task.id, status: v);
                  },
                ),

                const SizedBox(width: 12),

                /// PRIORITY (THIS NOW WORKS)
                DropdownButton<String>(
                  value: priority,
                  underline: const SizedBox(),
                  items: ['low', 'medium', 'high']
                      .map((p) => DropdownMenuItem(
                            value: p,
                            child: Text(p.toUpperCase()),
                          ))
                      .toList(),
                  onChanged: (v) async {
                    if (v == null || v == priority) return;
                    setState(() => priority = v);
                    await api.updateTask(widget.task.id, priority: v);
                  },
                ),

                const SizedBox(width: 12),

                /// PRIORITY BADGE
                Container(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 12, vertical: 5),
                  decoration: BoxDecoration(
                    color: priorityColor(priority),
                    borderRadius: BorderRadius.circular(14),
                  ),
                  child: Text(
                    priority.toUpperCase(),
                    style: const TextStyle(
                        color: Colors.white, fontSize: 12),
                  ),
                ),

                const Spacer(),

                /// DETAILS
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
                            Text("Status: ${status.toUpperCase()}"),
                            Text("Priority: ${priority.toUpperCase()}"),
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
