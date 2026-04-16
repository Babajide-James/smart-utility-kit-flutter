import 'package:flutter/material.dart';
import '../helpers/database_helper.dart';
import '../models/task.dart';

class TasksProvider with ChangeNotifier {
  List<Task> _tasks = [];
  bool _isLoading = true;

  List<Task> get tasks => _tasks;
  bool get isLoading => _isLoading;

  int get totalTasks => _tasks.length;
  int get completedTasks => _tasks.where((t) => t.isCompleted).length;
  int get pendingTasks => _tasks.where((t) => !t.isCompleted).length;

  TasksProvider() {
    loadTasks();
  }

  Future<void> loadTasks() async {
    _isLoading = true;
    notifyListeners();

    _tasks = await DatabaseHelper.instance.getAllTasks();

    _isLoading = false;
    notifyListeners();
  }

  Future<void> addTask(String title, {String description = ''}) async {
    final now = DateTime.now();
    final task = Task(
      title: title,
      description: description,
      createdAt: now,
      updatedAt: now,
    );
    final inserted = await DatabaseHelper.instance.insertTask(task);
    _tasks.insert(0, inserted);
    notifyListeners();
  }

  Future<void> toggleTask(int id) async {
    final index = _tasks.indexWhere((t) => t.id == id);
    if (index == -1) return;

    final task = _tasks[index];
    final updated = task.copyWith(
      isCompleted: !task.isCompleted,
      updatedAt: DateTime.now(),
    );
    await DatabaseHelper.instance.updateTask(updated);
    _tasks[index] = updated;
    notifyListeners();
  }

  Future<void> updateTask(int id, {required String title, String description = ''}) async {
    final index = _tasks.indexWhere((t) => t.id == id);
    if (index == -1) return;

    final updated = _tasks[index].copyWith(
      title: title,
      description: description,
      updatedAt: DateTime.now(),
    );
    await DatabaseHelper.instance.updateTask(updated);
    _tasks[index] = updated;
    notifyListeners();
  }

  Future<void> deleteTask(int id) async {
    await DatabaseHelper.instance.deleteTask(id);
    _tasks.removeWhere((t) => t.id == id);
    notifyListeners();
  }
}
