// lib/models/todo_model.dart

class TodoTask {
  final String taskDetails;
  final bool taskDone;
  final DateTime? taskDoneTime;
  final int thread_id; // added
  final int taskIndex; // added

  TodoTask({
    required this.taskDetails,
    required this.taskDone,
    this.taskDoneTime,
    required this.thread_id,
    required this.taskIndex,
  });

  factory TodoTask.fromJson(Map<String, dynamic> j) {
    return TodoTask(
      taskDetails: j['taskDetails'] as String? ?? '',
      taskDone: j['taskDone'] as bool? ?? false,
      taskDoneTime: j['taskDoneTime'] != null
          ? DateTime.parse(j['taskDoneTime'] as String)
          : null,
      thread_id: j['thread_id'] as int? ?? 0,
      taskIndex: j['taskIndex'] as int? ?? 0,
    );
  }
}

class TodoResponse {
  final List<TodoTask> tasks;
  final int total;
  TodoResponse({required this.tasks, required this.total});
  factory TodoResponse.fromJson(Map<String, dynamic> j) {
    final raw = (j['tasks'] as List).cast<Map<String, dynamic>>();
    return TodoResponse(
      tasks: raw.map((e) => TodoTask.fromJson(e)).toList(),
      total: j['total'] as int? ?? raw.length,
    );
  }
}
