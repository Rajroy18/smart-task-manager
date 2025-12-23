import 'package:flutter/material.dart';
import '../models/task.dart';

class TaskCard extends StatelessWidget {
  final Task task;
  final VoidCallback onDelete;

  const TaskCard({
    super.key,
    required this.task,
    required this.onDelete,
  });

  Color getPriorityColor() {
    switch (task.priority) {
      case "high":
        return Colors.red;
      case "medium":
        return Colors.orange;
      default:
        return Colors.green;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 3,
      margin: const EdgeInsets.symmetric(vertical: 8),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: Padding(
        padding: const EdgeInsets.all(14),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Expanded(
                  child: Text(
                    task.title,
                    style: const TextStyle(
                        fontSize: 16, fontWeight: FontWeight.w600),
                  ),
                ),
                IconButton(
                  icon: const Icon(Icons.delete_outline, color: Colors.red),
                  onPressed: onDelete,
                )
              ],
            ),
            const SizedBox(height: 4),
            Text(task.description,
                style: TextStyle(color: Colors.grey[700])),
            const SizedBox(height: 10),
            Row(
              children: [
                Chip(
                  label: Text(task.status),
                  backgroundColor: Colors.indigo.shade100,
                ),
                const SizedBox(width: 8),
                Chip(
                  label: Text(task.priority.toUpperCase()),
                  backgroundColor:
                      getPriorityColor().withOpacity(0.2),
                ),
              ],
            )
          ],
        ),
      ),
    );
  }
}
