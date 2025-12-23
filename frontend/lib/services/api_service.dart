import 'dart:convert';
import 'package:http/http.dart' as http;
import '../models/task.dart';

class ApiService {
  static const String baseUrl =
      "https://smart-task-manager-wqa7.onrender.com/api/tasks";

  Future<List<Task>> fetchTasks({String? status}) async {
    final uri = status == null
        ? Uri.parse(baseUrl)
        : Uri.parse("$baseUrl?status=$status");

    final res = await http.get(uri);

    if (res.statusCode != 200) {
      throw Exception("Failed to fetch tasks");
    }

    final data = json.decode(res.body);
    return (data['data'] as List)
        .map((t) => Task.fromJson(t))
        .toList();
  }

  Future<void> addTask(String title, String description) async {
    await http.post(
      Uri.parse(baseUrl),
      headers: {"Content-Type": "application/json"},
      body: jsonEncode({
        "title": title,
        "description": description,
      }),
    );
  }

  Future<void> updateTask(
    String id, {
    String? status,
    String? priority,
  }) async {
    final body = <String, dynamic>{};
    if (status != null) body['status'] = status;
    if (priority != null) body['priority'] = priority;

    await http.patch(
      Uri.parse("$baseUrl/$id"),
      headers: {"Content-Type": "application/json"},
      body: jsonEncode(body),
    );
  }

  Future<void> deleteTask(String id) async {
    await http.delete(Uri.parse("$baseUrl/$id"));
  }
}
