import 'package:flutter/material.dart';
import '../data/notifications_datasource.dart';
import '../data/tasks_datasource.dart';
import '../models/notification_model.dart';
import '../models/task_model.dart';
import '../widgets/alerts_panel.dart';
import '../widgets/kanban_column.dart';

/// Pantalla principal de la Smart TV — Tablero de Control Kanban.
///
/// Centro de mando visual (Back of House) para que gerentes o coordinadores
/// monitoreen en tiempo real el estado de las tareas del personal.
///
/// Layout en landscape:
///   ┌──────────────────────────────────────────────────────┐
///   │  🔔 Panel de Alertas (colapsable, scrolleable)       │
///   ├───────────────────────┬──────────────────────────────┤
///   │      Pendientes       │         En Progreso          │
///   │      (pending)        │         (in_progress)        │
///   │                       │                              │
///   └───────────────────────┴──────────────────────────────┘
///
/// Se excluyen tareas completadas del tablero.
/// Las alertas se limitan a 10, ordenadas por fecha descendente.
class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  // ── Datos ──────────────────────────────────────────────────────────────────
  List<TaskModel> _pendingTasks = [];
  List<TaskModel> _inProgressTasks = [];
  List<NotificationModel> _alerts = [];
  bool _isLoadingTasks = true;
  bool _isLoadingAlerts = true;

  // ── Firestore streams ─────────────────────────────────────────────────────
  final TasksDatasource _tasksDatasource = TasksDatasource();
  final NotificationsDatasource _notificationsDatasource =
      NotificationsDatasource();

  @override
  void initState() {
    super.initState();
    _subscribeToFirestore();
  }

  /// Suscribirse a los streams de Firestore.
  void _subscribeToFirestore() {
    // ── Tareas Pendientes ────────────────────────────────────────────────────
    _tasksDatasource.watchPendingTasks().listen(
      (tasks) {
        if (mounted) {
          setState(() {
            _pendingTasks = tasks;
            _isLoadingTasks = false;
          });
        }
      },
      onError: (error) {
        if (mounted) {
          setState(() {
            _pendingTasks = [];
            _isLoadingTasks = false;
          });
        }
      },
    );

    // ── Tareas En Progreso ───────────────────────────────────────────────────
    _tasksDatasource.watchInProgressTasks().listen(
      (tasks) {
        if (mounted) {
          setState(() {
            _inProgressTasks = tasks;
          });
        }
      },
      onError: (error) {
        if (mounted) {
          setState(() {
            _inProgressTasks = [];
          });
        }
      },
    );

    // ── Alertas ──────────────────────────────────────────────────────────────
    _notificationsDatasource.watchActiveNotifications().listen(
      (alerts) {
        if (mounted) {
          setState(() {
            _alerts = alerts;
            _isLoadingAlerts = false;
          });
        }
      },
      onError: (error) {
        if (mounted) {
          setState(() {
            _alerts = [];
            _isLoadingAlerts = false;
          });
        }
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF0F1117),
      body: SafeArea(
        child: Column(
          children: [
            // ── AppBar personalizada ──────────────────────────────────────
            _buildAppBar(),

            // ── Panel de Alertas (colapsable) ────────────────────────────
            if (!_isLoadingAlerts) AlertsPanel(alerts: _alerts),

            // ── Tablero Kanban (2 columnas) ──────────────────────────────
            Expanded(
              child: _isLoadingTasks
                  ? const Center(
                      child: CircularProgressIndicator(
                        color: Color(0xFFFF661A),
                      ),
                    )
                  : Padding(
                      padding: const EdgeInsets.all(20),
                      child: Row(
                        children: [
                          // ── Columna 1: Tareas Pendientes ───────────────
                          Expanded(
                            child: KanbanColumn(
                              title: 'Tareas Pendientes',
                              icon: Icons.pending_actions_rounded,
                              color: const Color(0xFFFF661A), // Naranja
                              tasks: _pendingTasks,
                            ),
                          ),

                          const SizedBox(width: 16),

                          // ── Columna 2: En Progreso ─────────────────────
                          Expanded(
                            child: KanbanColumn(
                              title: 'En Progreso',
                              icon: Icons.trending_up_rounded,
                              color: const Color(0xFF3B82F6), // Azul
                              tasks: _inProgressTasks,
                            ),
                          ),
                        ],
                      ),
                    ),
            ),
          ],
        ),
      ),
    );
  }

  /// AppBar personalizada para el tablero Kanban.
  Widget _buildAppBar() {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
      decoration: BoxDecoration(
        color: const Color(0xFF0F1117),
        border: Border(
          bottom: BorderSide(
            color: Colors.white.withValues(alpha: 0.06),
            width: 1,
          ),
        ),
      ),
      child: Row(
        children: [
          // Logo
          Container(
            padding: const EdgeInsets.all(8),
            decoration: BoxDecoration(
              color: const Color(0xFFFF661A).withValues(alpha: 0.15),
              borderRadius: BorderRadius.circular(10),
            ),
            child: const Icon(
              Icons.hotel_rounded,
              size: 24,
              color: Color(0xFFFF661A),
            ),
          ),
          const SizedBox(width: 14),
          // Título
          const Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Centro de Mando',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 18,
                  fontWeight: FontWeight.w700,
                  letterSpacing: 0.5,
                ),
              ),
              Text(
                'Tablero Kanban — Tareas del Personal',
                style: TextStyle(
                  color: Color(0xFF6B7280),
                  fontSize: 12,
                  fontWeight: FontWeight.w400,
                ),
              ),
            ],
          ),

          const Spacer(),

          // Reloj
          StreamBuilder(
            stream: Stream.periodic(const Duration(seconds: 30)),
            builder: (context, _) {
              final now = DateTime.now();
              return Text(
                '${now.hour.toString().padLeft(2, '0')}:${now.minute.toString().padLeft(2, '0')}',
                style: TextStyle(
                  color: Colors.white.withValues(alpha: 0.5),
                  fontSize: 22,
                  fontWeight: FontWeight.w300,
                  letterSpacing: 2,
                ),
              );
            },
          ),
        ],
      ),
    );
  }
}
