
import 'package:flutter/material.dart';
import '../models/task.dart';

class TaskScreen extends StatefulWidget {
  const TaskScreen({super.key});

  @override
  State<TaskScreen> createState() => _TaskScreenState();
}

class _TaskScreenState extends State<TaskScreen> {
  final TextEditingController titleController =
      TextEditingController();

  final TextEditingController descriptionController =
      TextEditingController();

  final List<Task> tasks = [
    Task(
      id: 1,
      title: 'Hoàn thành bài tập Flutter',
      description: 'Xây dựng giao diện SonaTasks',
      isDone: true,
      dueDate: DateTime(2026, 10, 24),
    ),
    Task(
      id: 2,
      title: 'Ôn tập Dart',
      description: 'Ôn tập class và null safety',
      isDone: true,
    ),
    Task(
      id: 3,
      title: 'Thiết kế giao diện',
      description: 'Hoàn thiện màn hình Home và About',
    ),
    Task(
      id: 4,
      title: 'Kiểm tra ứng dụng',
      description: 'Chạy thử trên Android Emulator',
    ),
    Task(
      id: 5,
      title: 'Nộp bài thực hành',
      description: 'Chuẩn bị mã nguồn và README',
    ),
  ];

  @override
  void initState() {
    super.initState();

    // In danh sách 5 công việc mẫu ra console.
    for (final task in tasks) {
      debugPrint(
        'ID: ${task.id} | ${task.title} | '
        'isDone: ${task.isDone}',
      );
    }
  }

  @override
  void dispose() {
    titleController.dispose();
    descriptionController.dispose();
    super.dispose();
  }

  int get totalTasks => tasks.length;

  int get completedTasks =>
      tasks.where((task) => task.isDone).length;

  int get pendingTasks => totalTasks - completedTasks;

  void showMessage(String message) {
    ScaffoldMessenger.of(context)
      ..hideCurrentSnackBar()
      ..showSnackBar(
        SnackBar(content: Text(message)),
      );
  }

  void addTask() {
    final title = titleController.text.trim();
    final description = descriptionController.text.trim();

    // Tên công việc không được để trống.
    if (title.isEmpty) {
      showMessage('Vui lòng nhập tên công việc!');
      return;
    }

    // Không cho phép trùng tên, không phân biệt chữ hoa/thường.
    final duplicated = tasks.any(
      (task) =>
          task.title.trim().toLowerCase() ==
          title.toLowerCase(),
    );

    if (duplicated) {
      showMessage('Tên công việc đã tồn tại!');
      return;
    }

    // Tạo ID mới, không trùng ID hiện có.
    final newId = tasks.isEmpty
        ? 1
        : tasks
                .map((task) => task.id)
                .reduce((a, b) => a > b ? a : b) +
            1;

    final newTask = Task(
      id: newId,
      title: title,
      description: description,
      isDone: false,
      dueDate: null,
    );

    setState(() {
      tasks.add(newTask);
    });

    debugPrint(
      'Đã thêm công việc: '
      'ID=${newTask.id}, '
      'title=${newTask.title}, '
      'description=${newTask.description}, '
      'isDone=${newTask.isDone}, '
      'dueDate=${newTask.dueDate}',
    );

    titleController.clear();
    descriptionController.clear();

    FocusScope.of(context).unfocus();
    showMessage('Đã thêm công việc thành công!');
  }

  void toggleTask(Task task, bool? value) {
    setState(() {
      task.isDone = value ?? false;
    });

    debugPrint(
      'Cập nhật công việc: '
      'ID=${task.id}, '
      'title=${task.title}, '
      'isDone=${task.isDone}',
    );
  }

  @override
  Widget build(BuildContext context) {
    return ListView(
      padding: const EdgeInsets.all(16),
      children: [
        // THỐNG KÊ CÔNG VIỆC
        const Text(
          'Thống kê công việc',
          style: TextStyle(
            fontSize: 22,
            fontWeight: FontWeight.bold,
          ),
        ),
        const SizedBox(height: 12),

        Row(
          children: [
            Expanded(
              child: _statCard(
                'Tổng cộng',
                totalTasks,
                Colors.blue,
                Icons.list_alt,
              ),
            ),
            const SizedBox(width: 8),
            Expanded(
              child: _statCard(
                'Đã xong',
                completedTasks,
                Colors.green,
                Icons.check_circle_outline,
              ),
            ),
            const SizedBox(width: 8),
            Expanded(
              child: _statCard(
                'Chưa xong',
                pendingTasks,
                Colors.orange,
                Icons.pending_actions,
              ),
            ),
          ],
        ),

        const SizedBox(height: 24),

        // FORM THÊM CÔNG VIỆC
        const Text(
          'Thêm công việc mới',
          style: TextStyle(
            fontSize: 20,
            fontWeight: FontWeight.bold,
          ),
        ),
        const SizedBox(height: 12),

        TextField(
          controller: titleController,
          textInputAction: TextInputAction.next,
          decoration: InputDecoration(
            labelText: 'Tên công việc',
            hintText: 'Nhập tên công việc',
            prefixIcon: const Icon(Icons.edit_note),
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
            ),
          ),
        ),

        const SizedBox(height: 12),

        TextField(
          controller: descriptionController,
          minLines: 2,
          maxLines: 4,
          textInputAction: TextInputAction.newline,
          decoration: InputDecoration(
            labelText: 'Mô tả',
            hintText: 'Nhập mô tả (không bắt buộc)',
            prefixIcon: const Icon(Icons.description_outlined),
            alignLabelWithHint: true,
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
            ),
          ),
        ),

        const SizedBox(height: 12),

        SizedBox(
          width: double.infinity,
          child: ElevatedButton.icon(
            onPressed: addTask,
            icon: const Icon(Icons.add),
            label: const Text('Lưu công việc'),
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.blue,
              foregroundColor: Colors.white,
              padding: const EdgeInsets.symmetric(vertical: 15),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
            ),
          ),
        ),

        const SizedBox(height: 24),

        // DANH SÁCH CÔNG VIỆC
        Text(
          'Danh sách công việc ($totalTasks)',
          style: const TextStyle(
            fontSize: 20,
            fontWeight: FontWeight.bold,
          ),
        ),
        const SizedBox(height: 8),

        if (tasks.isEmpty)
          const Padding(
            padding: EdgeInsets.all(24),
            child: Text(
              'Chưa có công việc nào.',
              textAlign: TextAlign.center,
            ),
          ),

        ...tasks.map(
          (task) => Card(
            margin: const EdgeInsets.only(bottom: 10),
            child: CheckboxListTile(
              value: task.isDone,
              onChanged: (value) => toggleTask(task, value),
              controlAffinity: ListTileControlAffinity.leading,
              isThreeLine: true,
              secondary: CircleAvatar(
                backgroundColor: task.isDone
                    ? Colors.green.shade100
                    : Colors.blue.shade100,
                child: Icon(
                  task.isDone
                      ? Icons.check
                      : Icons.assignment_outlined,
                  color: task.isDone
                      ? Colors.green
                      : Colors.blue,
                ),
              ),
              title: Text(
                task.title,
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  decoration: task.isDone
                      ? TextDecoration.lineThrough
                      : TextDecoration.none,
                ),
              ),
              subtitle: Padding(
                padding: const EdgeInsets.only(top: 5),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      task.description.isEmpty
                          ? 'Không có mô tả'
                          : task.description,
                    ),
                    const SizedBox(height: 5),
                    Text('ID: ${task.id}'),
                    Text(
                      task.dueDate == null
                          ? 'Hạn hoàn thành: Chưa đặt'
                          : 'Hạn hoàn thành: '
                              '${task.dueDate!.day}/'
                              '${task.dueDate!.month}/'
                              '${task.dueDate!.year}',
                    ),
                    const SizedBox(height: 4),
                    Text(
                      task.isDone
                          ? 'Đã hoàn thành'
                          : 'Chưa hoàn thành',
                      style: TextStyle(
                        color: task.isDone
                            ? Colors.green
                            : Colors.orange,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ],
    );
  }

  Widget _statCard(
    String label,
    int count,
    Color color,
    IconData icon,
  ) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.symmetric(
          vertical: 14,
          horizontal: 4,
        ),
        child: Column(
          children: [
            Icon(icon, color: color, size: 25),
            const SizedBox(height: 8),
            Text(
              '$count',
              style: TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
                color: color,
              ),
            ),
            const SizedBox(height: 4),
            Text(
              label,
              textAlign: TextAlign.center,
              style: const TextStyle(fontSize: 12),
            ),
          ],
        ),
      ),
    );
  }
}
