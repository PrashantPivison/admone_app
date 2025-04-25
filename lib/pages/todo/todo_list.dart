// lib/pages/todo/todo_list.dart

import 'package:flutter/material.dart';
import 'package:my_app/backend/api_requests/todo_api.dart';
import 'package:my_app/pages/todo/todo_model.dart';
import '../../config/theme.dart';

class TodoList extends StatefulWidget {
  const TodoList({Key? key}) : super(key: key);

  @override
  State<TodoList> createState() => _TodoListState();
}

class _TodoListState extends State<TodoList> {
  late Future<TodoResponse> _futureTodos;

  @override
  void initState() {
    super.initState();
    _loadTodos();
  }

  void _loadTodos() {
    _futureTodos = TodoApi.fetchTodos().then((j) => TodoResponse.fromJson(j));
    setState(() {});
  }

  Widget _buildSection(BuildContext context,
      {required String title, required List<Widget> items}) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 30),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(title,
              style: Theme.of(context).textTheme.bodySmall?.copyWith(
                    fontFamily: 'Inter',
                    color: CustomColors.text,
                    fontWeight: FontWeight.w600,
                  )),
          const SizedBox(height: 10),
          ...items,
        ],
      ),
    );
  }

  // unchanged for COMPLETED items
  List<Widget> _buildCompletedItems(
      BuildContext context, List<TodoTask> completed) {
    return completed.map((task) {
      return Padding(
        padding: const EdgeInsets.only(bottom: 10),
        child: Container(
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(10),
            border: Border.all(width: 1.0, color: const Color(0xFFDDDDDD)),
          ),
          child: Padding(
            padding: const EdgeInsets.fromLTRB(10, 14, 10, 14),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Icon(Icons.check_circle_outline, size: 25, color: Colors.green),
                const SizedBox(width: 15),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(task.taskDetails,
                          overflow: TextOverflow.ellipsis,
                          style:
                              Theme.of(context).textTheme.labelMedium?.copyWith(
                                    fontFamily: 'Inter',
                                    color: CustomColors.text,
                                    fontWeight: FontWeight.w600,
                                  )),
                      if (task.taskDoneTime != null)
                        Text(
                          'Done: ${task.taskDoneTime}',
                          style:
                              Theme.of(context).textTheme.labelSmall?.copyWith(
                                    fontFamily: 'Inter',
                                    color: Colors.grey,
                                    fontWeight: FontWeight.w600,
                                  ),
                        ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      );
    }).toList();
  }

  // NEW: build PENDING with confirmation & update
  List<Widget> _buildPendingItems(
      BuildContext context, List<TodoTask> pending) {
    return pending.map((task) {
      return Padding(
        padding: const EdgeInsets.only(bottom: 10),
        child: Container(
          decoration: BoxDecoration(
            color: const Color(0xFFFFE2E2),
            borderRadius: BorderRadius.circular(10),
            border: Border.all(width: 1.0, color: const Color(0xFFDDDDDD)),
          ),
          child: Padding(
            padding: const EdgeInsets.fromLTRB(10, 14, 10, 14),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // replace icon with a checkbox
                Checkbox(
                  value: false,
                  onChanged: (_) async {
                    final confirm = await showDialog<bool>(
                      context: context,
                      builder: (ctx) => AlertDialog(
                        title: const Text('Mark task complete?'),
                        content: Text(task.taskDetails),
                        actions: [
                          TextButton(
                              onPressed: () => Navigator.pop(ctx, false),
                              child: const Text('Cancel')),
                          TextButton(
                              onPressed: () => Navigator.pop(ctx, true),
                              child: const Text('Yes')),
                        ],
                      ),
                    );
                    if (confirm == true) {
                      try {
                        await TodoApi.updateTask(
                          threadId: task.thread_id,
                          taskIndex: task.taskIndex,
                        );
                        _loadTodos();
                      } catch (e) {
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(content: Text('Update failed: $e')),
                        );
                      }
                    }
                  },
                ),
                const SizedBox(width: 15),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(task.taskDetails,
                          overflow: TextOverflow.ellipsis,
                          style:
                              Theme.of(context).textTheme.labelMedium?.copyWith(
                                    fontFamily: 'Inter',
                                    color: CustomColors.text,
                                    fontWeight: FontWeight.w600,
                                  )),
                      Text(
                        task.taskDoneTime != null
                            ? 'Done: ${task.taskDoneTime}'
                            : 'Pending',
                        style: Theme.of(context).textTheme.labelSmall?.copyWith(
                              fontFamily: 'Inter',
                              color: Colors.grey,
                              fontWeight: FontWeight.w600,
                            ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      );
    }).toList();
  }

  Widget _buildDashboardContent(TodoResponse data) {
    final pending = data.tasks.where((t) => t.taskDone == false).toList();
    final completed = data.tasks.where((t) => t.taskDone == true).toList();

    return SingleChildScrollView(
      child: Column(
        children: [
          const SizedBox(height: 20),
          if (pending.isNotEmpty)
            _buildSection(
              context,
              title: 'Pending',
              items: _buildPendingItems(context, pending),
            ),
          if (completed.isNotEmpty) ...[
            const SizedBox(height: 20),
            _buildSection(
              context,
              title: 'Completed',
              items: _buildCompletedItems(context, completed),
            ),
          ],
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        toolbarHeight: 130,
        backgroundColor: Colors.transparent,
        elevation: 0,
        flexibleSpace: Stack(children: [
          Container(color: Theme.of(context).colorScheme.primary),
          Padding(
            padding: const EdgeInsets.symmetric(vertical: 15, horizontal: 25),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Row(children: [
                  GestureDetector(
                    onTap: () => Navigator.pop(context),
                    child: const Icon(Icons.arrow_back,
                        color: Colors.white, size: 20),
                  ),
                  const SizedBox(width: 10),
                  Text('To Dos',
                      style: Theme.of(context)
                          .textTheme
                          .headlineMedium
                          ?.copyWith(
                            fontFamily: 'Poppins',
                            color: Theme.of(context).colorScheme.onSecondary,
                          )),
                ]),
                const SizedBox(height: 15),
                TextField(
                  decoration: InputDecoration(
                    contentPadding:
                        const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                    hintText: 'Search tasks...',
                    filled: true,
                    fillColor: Colors.white,
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(14),
                      borderSide: BorderSide.none,
                    ),
                    prefixIcon: const Icon(Icons.search, size: 18),
                    isDense: true,
                  ),
                  style: const TextStyle(fontSize: 12),
                  onChanged: (_) {},
                ),
              ],
            ),
          ),
        ]),
      ),
      body: FutureBuilder<TodoResponse>(
        future: _futureTodos,
        builder: (ctx, snap) {
          if (snap.connectionState != ConnectionState.done) {
            return const Center(child: CircularProgressIndicator());
          }
          if (snap.hasError) {
            return Center(child: Text('Error: ${snap.error}'));
          }
          return _buildDashboardContent(snap.data!);
        },
      ),
    );
  }
}
