import 'package:flutter/material.dart';
import '../models/task_model.dart';
import 'activity_row.dart';

class ActivityTable extends StatelessWidget {
  final List<TaskModel> tasks;

  const ActivityTable({super.key, required this.tasks});

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 2.0,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12.0)),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          const Padding(
            padding: EdgeInsets.all(16.0),
            child: Row(
              children: [
                Expanded(flex: 2, child: Text('Servicio', style: TextStyle(fontWeight: FontWeight.bold))),
                Expanded(flex: 2, child: Text('Encargado', style: TextStyle(fontWeight: FontWeight.bold))),
                Expanded(flex: 1, child: Text('Habitación', style: TextStyle(fontWeight: FontWeight.bold))),
                Expanded(flex: 2, child: Text('Fecha', style: TextStyle(fontWeight: FontWeight.bold))),
                Expanded(flex: 2, child: Text('Estado', style: TextStyle(fontWeight: FontWeight.bold))),
              ],
            ),
          ),
          const Divider(height: 1),
          Expanded(
            child: ListView.separated(
              itemCount: tasks.length,
              separatorBuilder: (context, index) => const Divider(height: 1),
              itemBuilder: (context, index) {
                return ActivityRow(task: tasks[index]);
              },
            ),
          ),
        ],
      ),
    );
  }
}
