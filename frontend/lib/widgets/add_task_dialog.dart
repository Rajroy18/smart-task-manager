import 'package:flutter/material.dart';
import '../services/api_service.dart';

class AddTaskDialog extends StatefulWidget {
  final VoidCallback onAdded;

  const AddTaskDialog({super.key, required this.onAdded});

  @override
  State<AddTaskDialog> createState() => _AddTaskDialogState();
}

class _AddTaskDialogState extends State<AddTaskDialog> {
  final titleCtrl = TextEditingController();
  final descCtrl = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: const Text("Add Task"),
      content: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          TextField(controller: titleCtrl, decoration: const InputDecoration(labelText: "Title")),
          TextField(controller: descCtrl, decoration: const InputDecoration(labelText: "Description")),
        ],
      ),
      actions: [
        TextButton(
          onPressed: () async {
            await ApiService.createTask(
              titleCtrl.text,
              descCtrl.text,
            );
            widget.onAdded();
            Navigator.pop(context);
          },
          child: const Text("ADD"),
        )
      ],
    );
  }
}
