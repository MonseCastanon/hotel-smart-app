import 'package:flutter/material.dart';
import '../models/task_model.dart';
import 'status_badge.dart';

class ActivityRow extends StatefulWidget {
  final TaskModel task;

  const ActivityRow({super.key, required this.task});

  @override
  State<ActivityRow> createState() => _ActivityRowState();
}

class _ActivityRowState extends State<ActivityRow> {
  bool _isFocused = false;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () {},
      onFocusChange: (focused) {
        setState(() {
          _isFocused = focused;
        });
      },
      child: Container(
        color: _isFocused ? Colors.white.withValues(alpha: 0.1) : Colors.transparent,
        padding: const EdgeInsets.symmetric(vertical: 12.0, horizontal: 16.0),
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
                  Text(widget.task.serviceType),
                ],
              ),
            ),
            Expanded(flex: 2, child: Text(widget.task.assignedTo)),
            Expanded(flex: 1, child: Text(widget.task.room)),
            Expanded(flex: 2, child: Text(widget.task.formattedDate)),
            Expanded(flex: 2, child: StatusBadge(status: widget.task.status)),
          ],
        ),
      ),
    );
  }
}
