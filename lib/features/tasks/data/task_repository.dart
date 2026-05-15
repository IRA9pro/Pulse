import 'package:supabase_flutter/supabase_flutter.dart';
import '../domain/tasks_model.dart';

class TaskRepository {
  final _client = Supabase.instance.client;

  Future<List<Task>> fetchTasks() async {
    final response = await _client
        .from('tasks')
        .select()
        .order('created_at', ascending: false);

    return (response as List).map((json) => Task.fromJson(json)).toList();
  }

  Future<void> addTask(String title) async {
    await _client.from('tasks').insert({'title': title});
  }

  Future<void> toggleTask(String id, bool currentState) async {
    await _client
        .from('tasks')
        .update({'is_completed': !currentState})
        .eq('id', id);
  }
}
