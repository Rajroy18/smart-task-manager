import 'dart:convert';
import 'package:http/http.dart' as http;
import '../models/task.dart';

class ApiService {
  static const String baseUrl =
      "https://smart-task-manager-wqa7.onrender.com/api/tasks";

  /// FETCH TASKS
  Future<List<Task>> fetchTasks({String? status}) async {
    final uri = status == null
        ? Uri.parse(baseUrl)
        : Uri.parse("$baseUrl?status=$status");

    final response = await http.get(uri);

    if (response.statusCode != 200) {
      throw Exception("Failed to fetch tasks");
    }

    final data = json.decode(response.body);

    return (data['data'] as List)
        .map((task) => Task.fromJson(task))
        .toList();
  }

  /// ADD TASK
  Future<void> addTask(String title, String description) async {
    final res = await http.post(
      Uri.parse(baseUrl),
      headers: {"Content-Type": "application/json"},
      body: json.encode({
        "title": title,
        "description": description,
      }),
    );

    if (res.statusCode != 201) {
      throw Exception("Failed to add task");
    }
  }

  /// UPDATE TASK (FIXED)
  Future<void> updateTask(
    String id, {
    String? status,
    String? priority,
  }) async {
    final body = <String, dynamic>{};

    if (status != null) body['status'] = status;
    if (priority != null) body['priority'] = priority;

    final res = await http.patch(
      Uri.parse("$baseUrl/$id"),
      headers: {"Content-Type": "application/json"},
      body: json.encode(body),
    );

    if (res.statusCode != 200) {
      throw Exception("Failed to update task");
    }
  }

  /// DELETE TASK
  Future<void> deleteTask(String id) async {
    final res = await http.delete(Uri.parse("$baseUrl/$id"));

    if (res.statusCode != 200) {
      throw Exception("Failed to delete task");
    }
  }
}
