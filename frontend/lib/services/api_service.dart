import 'dart:convert';
import 'package:http/http.dart' as http;
import '../models/task.dart';

class ApiService {
  static const String baseUrl =
      "https://smart-task-manager-wqa7.onrender.com/api";

  static Future<List<Task>> fetchTasks({String? status}) async {
    final uri = Uri.parse("$baseUrl/tasks")
        .replace(queryParameters: status != null ? {"status": status} : null);

    final res = await http.get(uri);

    if (res.statusCode == 200) {
      final body = jsonDecode(res.body);
      return (body['data'] as List)
          .map((e) => Task.fromJson(e))
          .toList();
    } else {
      throw Exception("Failed to load tasks");
    }
  }

  static Future<void> createTask(
      String title, String description) async {
    await http.post(
      Uri.parse("$baseUrl/tasks"),
      headers: {"Content-Type": "application/json"},
      body: jsonEncode({
        "title": title,
        "description": description,
      }),
    );
  }

  static Future<void> deleteTask(String id) async {
    await http.delete(Uri.parse("$baseUrl/tasks/$id"));
  }
}
