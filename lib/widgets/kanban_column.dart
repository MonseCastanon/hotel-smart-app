import 'dart:async';
import 'package:flutter/material.dart';
import '../models/task_model.dart';
import 'task_card.dart';

/// Columna del tablero Kanban para la Smart TV.
///
/// Cada columna tiene:
///   - Header con icono, título y badge con contador de items
///   - Cuerpo scrolleable con tarjetas de tarea (ListView.builder)
///   - Autoscroll si hay más de 3 tareas
///   - Diseño adaptado al tema oscuro de la app
class KanbanColumn extends StatefulWidget {
  final String title;
  final IconData icon;
  final Color color;
  final List<TaskModel> tasks;

  const KanbanColumn({
    super.key,
    required this.title,
    required this.icon,
    required this.color,
    required this.tasks,
  });

  @override
  State<KanbanColumn> createState() => _KanbanColumnState();
}

class _KanbanColumnState extends State<KanbanColumn> {
  final ScrollController _scrollController = ScrollController();
  bool _isScrolling = false;

  @override
  void initState() {
    super.initState();
    _checkAutoScroll();
  }

  @override
  void didUpdateWidget(covariant KanbanColumn oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.tasks.length != oldWidget.tasks.length) {
      _checkAutoScroll();
    }
  }

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  void _checkAutoScroll() {
    if (widget.tasks.length > 3 && !_isScrolling) {
      _isScrolling = true;
      Future.delayed(const Duration(seconds: 2), _autoScrollLoop);
    } else if (widget.tasks.length <= 3) {
      _isScrolling = false;
    }
  }

  Future<void> _autoScrollLoop() async {
    while (_isScrolling && mounted) {
      if (!_scrollController.hasClients) {
        await Future.delayed(const Duration(seconds: 1));
        continue;
      }

      final maxScroll = _scrollController.position.maxScrollExtent;
      if (maxScroll <= 0) {
        await Future.delayed(const Duration(seconds: 2));
        continue;
      }

      // Scroll hacia abajo
      await _scrollController.animateTo(
        maxScroll,
        duration: const Duration(seconds: 8),
        curve: Curves.linear,
      );

      if (!mounted || !_isScrolling) break;
      await Future.delayed(const Duration(seconds: 2));

      if (!mounted || !_isScrolling) break;

      // Scroll rápido hacia arriba
      await _scrollController.animateTo(
        0,
        duration: const Duration(milliseconds: 800),
        curve: Curves.easeOut,
      );

      if (!mounted || !_isScrolling) break;
      await Future.delayed(const Duration(seconds: 2));
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: const Color(0xFF161825),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color: widget.color.withValues(alpha: 0.2),
          width: 1,
        ),
      ),
      child: Column(
        children: [
          // ── Header ─────────────────────────────────────────────────────
          _buildHeader(),

          // ── Cuerpo scrolleable ─────────────────────────────────────────
          Expanded(
            child: widget.tasks.isEmpty
                ? _buildEmptyState()
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
        color: widget.color.withValues(alpha: 0.08),
        borderRadius: const BorderRadius.vertical(top: Radius.circular(16)),
        border: Border(
          bottom: BorderSide(
            color: widget.color.withValues(alpha: 0.15),
            width: 1,
          ),
        ),
      ),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(6),
            decoration: BoxDecoration(
              color: widget.color.withValues(alpha: 0.15),
              borderRadius: BorderRadius.circular(8),
            ),
            child: Icon(widget.icon, size: 20, color: widget.color),
          ),
          const SizedBox(width: 10),
          Expanded(
            child: Text(
              widget.title,
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
              color: widget.color.withValues(alpha: 0.2),
              borderRadius: BorderRadius.circular(12),
            ),
            child: Text(
              '${widget.tasks.length}',
              style: TextStyle(
                color: widget.color,
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
      controller: _scrollController,
      physics: const BouncingScrollPhysics(),
      padding: const EdgeInsets.all(12),
      itemCount: widget.tasks.length,
      itemBuilder: (context, index) {
        final task = widget.tasks[index];
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
