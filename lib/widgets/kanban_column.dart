import 'package:flutter/material.dart';
import '../models/task_model.dart';
import 'task_card.dart';

/// Columna del tablero Kanban para la Smart TV.
///
/// Cada columna tiene:
///   - Header con icono, título y badge con contador de items
///   - Cuerpo scrolleable con tarjetas de tarea (ListView.builder)
///   - Diseño adaptado al tema oscuro de la app
///
/// Se usa en el [HomeScreen] para las columnas:
///   "Tareas Pendientes", "En Progreso" y "Personal Asignado".
class KanbanColumn extends StatelessWidget {
  final String title;
  final IconData icon;
  final Color color;
  final List<TaskModel> tasks;
  final bool isStaffColumn;

  const KanbanColumn({
    super.key,
    required this.title,
    required this.icon,
    required this.color,
    required this.tasks,
    this.isStaffColumn = false,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: const Color(0xFF161825),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color: color.withValues(alpha: 0.2),
          width: 1,
        ),
      ),
      child: Column(
        children: [
          // ── Header ─────────────────────────────────────────────────────
          _buildHeader(),

          // ── Cuerpo scrolleable ─────────────────────────────────────────
          Expanded(
            child: tasks.isEmpty
                ? _buildEmptyState()
                : isStaffColumn
                    ? _buildStaffList()
                    : _buildTaskList(),
          ),
        ],
      ),
    );
  }

  /// Header de la columna con icono, título y badge contador.
  Widget _buildHeader() {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
      decoration: BoxDecoration(
        color: color.withValues(alpha: 0.08),
        borderRadius: const BorderRadius.vertical(top: Radius.circular(16)),
        border: Border(
          bottom: BorderSide(
            color: color.withValues(alpha: 0.15),
            width: 1,
          ),
        ),
      ),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(6),
            decoration: BoxDecoration(
              color: color.withValues(alpha: 0.15),
              borderRadius: BorderRadius.circular(8),
            ),
            child: Icon(icon, size: 20, color: color),
          ),
          const SizedBox(width: 10),
          Expanded(
            child: Text(
              title,
              style: const TextStyle(
                color: Colors.white,
                fontWeight: FontWeight.w700,
                fontSize: 15,
                letterSpacing: 0.3,
              ),
            ),
          ),
          // Badge contador
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
            decoration: BoxDecoration(
              color: color.withValues(alpha: 0.2),
              borderRadius: BorderRadius.circular(12),
            ),
            child: Text(
              '${tasks.length}',
              style: TextStyle(
                color: color,
                fontWeight: FontWeight.w800,
                fontSize: 14,
              ),
            ),
          ),
        ],
      ),
    );
  }

  /// Lista de tareas con scroll vertical.
  Widget _buildTaskList() {
    return ListView.builder(
      padding: const EdgeInsets.all(12),
      itemCount: tasks.length,
      itemBuilder: (context, index) {
        final task = tasks[index];
        return TaskCard(
          serviceType: task.serviceType,
          assignedTo: task.assignedTo,
          room: task.room,
          timeLabel: task.formattedDate,
          status: task.status,
        );
      },
    );
  }

  /// Lista agrupada por personal asignado.
  Widget _buildStaffList() {
    // Agrupar tareas por persona asignada
    final staffMap = <String, List<TaskModel>>{};
    for (final task in tasks) {
      staffMap.putIfAbsent(task.assignedTo, () => []).add(task);
    }

    final staffEntries = staffMap.entries.toList();

    return ListView.builder(
      padding: const EdgeInsets.all(12),
      itemCount: staffEntries.length,
      itemBuilder: (context, index) {
        final entry = staffEntries[index];
        final name = entry.key;
        final staffTasks = entry.value;

        return Container(
          margin: const EdgeInsets.only(bottom: 10),
          decoration: BoxDecoration(
            color: const Color(0xFF1E2030),
            borderRadius: BorderRadius.circular(12),
            border: Border(
              left: BorderSide(color: color, width: 4),
            ),
          ),
          child: Padding(
            padding: const EdgeInsets.all(14),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // ── Nombre del empleado ──────────────────────────────────
                Row(
                  children: [
                    CircleAvatar(
                      radius: 16,
                      backgroundColor: color.withValues(alpha: 0.2),
                      child: Text(
                        name.isNotEmpty ? name[0].toUpperCase() : '?',
                        style: TextStyle(
                          color: color,
                          fontWeight: FontWeight.w700,
                          fontSize: 14,
                        ),
                      ),
                    ),
                    const SizedBox(width: 10),
                    Expanded(
                      child: Text(
                        name,
                        style: const TextStyle(
                          color: Colors.white,
                          fontWeight: FontWeight.w600,
                          fontSize: 14,
                        ),
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                    // Badge tareas activas
                    Container(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 8, vertical: 3),
                      decoration: BoxDecoration(
                        color: color.withValues(alpha: 0.15),
                        borderRadius: BorderRadius.circular(10),
                      ),
                      child: Text(
                        '${staffTasks.length} tarea${staffTasks.length != 1 ? 's' : ''}',
                        style: TextStyle(
                          color: color,
                          fontSize: 11,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ),
                  ],
                ),

                const SizedBox(height: 8),

                // ── Lista de tareas del empleado ─────────────────────────
                ...staffTasks.map((task) => Padding(
                      padding: const EdgeInsets.only(top: 6),
                      child: Row(
                        children: [
                          Container(
                            width: 8,
                            height: 8,
                            decoration: BoxDecoration(
                              color: task.status == 'in_progress'
                                  ? const Color(0xFF3B82F6)
                                  : const Color(0xFFFF661A),
                              shape: BoxShape.circle,
                            ),
                          ),
                          const SizedBox(width: 8),
                          Expanded(
                            child: Text(
                              '${task.serviceType} — Hab. ${task.room}',
                              style: TextStyle(
                                color: Colors.white.withValues(alpha: 0.65),
                                fontSize: 12,
                              ),
                              overflow: TextOverflow.ellipsis,
                            ),
                          ),
                          Text(
                            task.statusLabel,
                            style: TextStyle(
                              color: task.status == 'in_progress'
                                  ? const Color(0xFF3B82F6)
                                  : const Color(0xFFFF661A),
                              fontSize: 11,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ],
                      ),
                    )),
              ],
            ),
          ),
        );
      },
    );
  }

  /// Estado vacío cuando no hay tareas.
  Widget _buildEmptyState() {
    return Center(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(
            Icons.check_circle_outline_rounded,
            size: 40,
            color: Colors.white.withValues(alpha: 0.15),
          ),
          const SizedBox(height: 12),
          Text(
            'Sin tareas',
            style: TextStyle(
              color: Colors.white.withValues(alpha: 0.3),
              fontSize: 14,
              fontWeight: FontWeight.w500,
            ),
          ),
        ],
      ),
    );
  }
}
