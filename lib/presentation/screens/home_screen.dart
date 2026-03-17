import 'package:flutter/material.dart';
import 'package:taskmanagement_app/data/models/task_model.dart';
import 'package:taskmanagement_app/data/repositories/task_repository.dart';
import 'package:taskmanagement_app/presentation/widgets/task_item.dart';
import 'package:taskmanagement_app/presentation/widgets/empty_state.dart';
import 'add_task_screen.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final TaskRepository _repository = TaskRepository();
  List<Task> tasks = [];

  @override
  void initState() {
    super.initState();
    loadTasks();
  }

  void loadTasks() async {
    final fetchedTasks = await _repository.fetchTasks();
    setState(() => tasks = fetchedTasks);
  }

  void saveTasks() async => await _repository.saveTasks(tasks);

  void addTask(String title) {
    setState(() {
      tasks.add(Task(title: title));
      saveTasks();
    });
  }

  void deleteTask(int index) {
    setState(() {
      tasks.removeAt(index);
      saveTasks();
    });
  }

  void toggleTask(int index, bool? value) {
    setState(() {
      tasks[index].isCompleted = value ?? false;
      saveTasks();
    });
  }

  @override
  Widget build(BuildContext context) {
    final int completedCount = tasks.where((t) => t.isCompleted).length;
    final double completionPercent = tasks.isEmpty
        ? 0.0
        : completedCount / tasks.length;

    return Scaffold(
      backgroundColor: const Color(0xFFF3F6FD),
      body: CustomScrollView(
        physics: const BouncingScrollPhysics(),
        slivers: [
          SliverAppBar(
            expandedHeight: 220.0,
            collapsedHeight: 80,
            pinned: true,
            elevation: 0,
            backgroundColor: Colors.indigoAccent,
            flexibleSpace: FlexibleSpaceBar(
              background: _buildModernHeader(completedCount, completionPercent),
              stretchModes: const [StretchMode.zoomBackground],
            ),
          ),

          SliverToBoxAdapter(
            child: Padding(
              padding: const EdgeInsets.fromLTRB(24, 24, 24, 8),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const Text(
                    "Ongoing Tasks",
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.w800,
                      color: Color(0xFF2D3243),
                    ),
                  ),
                  Text(
                    "${tasks.length}",
                    style: const TextStyle(
                      color: Colors.indigoAccent,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ],
              ),
            ),
          ),

          SliverPadding(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            sliver: tasks.isEmpty
                ? const SliverFillRemaining(child: EmptyState())
                : SliverList(
                    delegate: SliverChildBuilderDelegate((context, index) {
                      return Padding(
                        padding: const EdgeInsets.only(bottom: 8),
                        child: TaskItem(
                          task: tasks[index],
                          onChanged: (value) => toggleTask(index, value),
                          onDelete: () => deleteTask(index),
                        ),
                      );
                    }, childCount: tasks.length),
                  ),
          ),

          const SliverToBoxAdapter(child: SizedBox(height: 100)),
        ],
      ),

      floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
      floatingActionButton: Container(
        height: 64,
        margin: const EdgeInsets.symmetric(horizontal: 24),
        child: ElevatedButton(
          onPressed: () => Navigator.push(
            context,
            MaterialPageRoute(builder: (_) => AddTaskScreen(onAdd: addTask)),
          ),
          style: ElevatedButton.styleFrom(
            backgroundColor: const Color(0xFF1E1E2C),
            foregroundColor: Colors.white,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(20),
            ),
            elevation: 12,
            shadowColor: Colors.black.withOpacity(0.4),
          ),
          child: const Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(Icons.add_rounded, size: 28),
              SizedBox(width: 8),
              Text(
                "Add New Task",
                style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildModernHeader(int completed, double percent) {
    return Container(
      decoration: const BoxDecoration(
        gradient: LinearGradient(
          colors: [Color(0xFF6366F1), Color(0xFF4F46E5)],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
      ),
      child: Stack(
        children: [
          Positioned(
            top: -20,
            right: -20,
            child: CircleAvatar(
              radius: 80,
              backgroundColor: Colors.white.withOpacity(0.05),
            ),
          ),
          SafeArea(
            child: Padding(
              padding: const EdgeInsets.all(24.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    "Hello there!",
                    style: TextStyle(color: Colors.white70, fontSize: 16),
                  ),
                  const Text(
                    "Manage your time",
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 26,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const Spacer(),

                  Container(
                    padding: const EdgeInsets.all(16),
                    decoration: BoxDecoration(
                      color: Colors.white.withOpacity(0.15),
                      borderRadius: BorderRadius.circular(20),
                      border: Border.all(color: Colors.white.withOpacity(0.2)),
                    ),
                    child: Column(
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            const Text(
                              "Daily Progress",
                              style: TextStyle(
                                color: Colors.white,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                            Text(
                              "${(percent * 100).toInt()}%",
                              style: const TextStyle(
                                color: Colors.white,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 12),
                        ClipRRect(
                          borderRadius: BorderRadius.circular(10),
                          child: LinearProgressIndicator(
                            value: percent,
                            minHeight: 8,
                            backgroundColor: Colors.white.withOpacity(0.2),
                            valueColor: const AlwaysStoppedAnimation(
                              Colors.white,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
