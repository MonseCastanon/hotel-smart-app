import 'package:flutter/material.dart';
import '../models/task_model.dart';
import 'status_badge.dart';

class ActivityRow extends StatelessWidget {
  final TaskModel task;

  const ActivityRow({super.key, required this.task});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0, horizontal: 16.0),
      child: Row(
        children: [
          Expanded(
            flex: 2,
            child: Row(
              children: [
                Container(
                  width: 12,
                  height: 12,
                  decoration: const BoxDecoration(
                    color: Colors.blue,
                    shape: BoxShape.circle,
                  ),
                ),
                const SizedBox(width: 8.0),
                Text(task.serviceType),
              ],
            ),
          ),
          Expanded(flex: 2, child: Text(task.assignedTo)),
          Expanded(flex: 1, child: Text(task.room)),
          Expanded(flex: 2, child: Text(task.date)),
          Expanded(flex: 2, child: StatusBadge(status: task.status)),
        ],
      ),
    );
  }
}
