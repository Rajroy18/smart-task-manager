import 'package:flutter/material.dart';
import '../services/api_service.dart';

class AddTaskDialog extends StatefulWidget {
  final VoidCallback onAdded;
  const AddTaskDialog({super.key, required this.onAdded});

  @override
  State<AddTaskDialog> createState() => _AddTaskDialogState();
}

class _AddTaskDialogState extends State<AddTaskDialog> {
  final titleController = TextEditingController();
  final descController = TextEditingController();
  final api = ApiService();

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: const Text("Add Task"),
      content: Column(mainAxisSize: MainAxisSize.min, children: [
        TextField(
          controller: titleController,
          decoration: const InputDecoration(labelText: "Title"),
        ),
        TextField(
          controller: descController,
          decoration: const InputDecoration(labelText: "Description"),
        ),
      ]),
      actions: [
        TextButton(
          onPressed: () => Navigator.pop(context),
          child: const Text("Cancel"),
        ),
        ElevatedButton(
          onPressed: () async {
            await api.addTask(
              titleController.text,
              descController.text,
            );
            widget.onAdded();
            Navigator.pop(context);
          },
          child: const Text("Add"),
        ),
      ],
    );
  }
}
