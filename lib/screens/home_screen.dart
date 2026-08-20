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
///   ├──────────────┬──────────────┬─────────────────────────┤
///   │  Pendientes  │  En Progreso │  Personal Asignado      │
///   │  (pending)   │  (in_progress)│  (agrupado por persona) │
///   │              │              │                         │
///   └──────────────┴──────────────┴─────────────────────────┘
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
  bool _usingDummyTasks = false;
  bool _usingDummyAlerts = false;

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
  /// Si la colección está vacía o falla, usa datos dummy como fallback.
  void _subscribeToFirestore() {
    // ── Tareas Pendientes ────────────────────────────────────────────────────
    _tasksDatasource.watchPendingTasks().listen(
      (tasks) {
        if (mounted) {
          setState(() {
            if (tasks.isNotEmpty) {
              _pendingTasks = tasks;
              _usingDummyTasks = false;
            } else if (_pendingTasks.isEmpty) {
              _pendingTasks = TasksDatasource.getDummyPendingTasks();
              _usingDummyTasks = true;
            }
            _isLoadingTasks = false;
          });
        }
      },
      onError: (error) {
        if (mounted) {
          setState(() {
            _pendingTasks = TasksDatasource.getDummyPendingTasks();
            _usingDummyTasks = true;
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
            if (tasks.isNotEmpty) {
              _inProgressTasks = tasks;
            } else if (_inProgressTasks.isEmpty) {
              _inProgressTasks = TasksDatasource.getDummyInProgressTasks();
            }
          });
        }
      },
      onError: (error) {
        if (mounted) {
          setState(() {
            _inProgressTasks = TasksDatasource.getDummyInProgressTasks();
          });
        }
      },
    );

    // ── Alertas ──────────────────────────────────────────────────────────────
    _notificationsDatasource.watchActiveNotifications().listen(
      (alerts) {
        if (mounted) {
          setState(() {
            if (alerts.isNotEmpty) {
              _alerts = alerts;
              _usingDummyAlerts = false;
            } else if (_alerts.isEmpty) {
              _alerts = NotificationsDatasource.getDummyNotifications();
              _usingDummyAlerts = true;
            }
            _isLoadingAlerts = false;
          });
        }
      },
      onError: (error) {
        if (mounted) {
          setState(() {
            _alerts = NotificationsDatasource.getDummyNotifications();
            _usingDummyAlerts = true;
            _isLoadingAlerts = false;
          });
        }
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    // Combinar todas las tareas activas para la columna "Personal Asignado"
    final allActiveTasks = [..._pendingTasks, ..._inProgressTasks];

    return Scaffold(
      backgroundColor: const Color(0xFF0F1117),
      body: SafeArea(
        child: Column(
          children: [
            // ── AppBar personalizada ──────────────────────────────────────
            _buildAppBar(),

            // ── Panel de Alertas (colapsable) ────────────────────────────
            if (!_isLoadingAlerts) AlertsPanel(alerts: _alerts),

            // ── Tablero Kanban (3 columnas) ──────────────────────────────
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

                          const SizedBox(width: 16),

                          // ── Columna 3: Personal Asignado ───────────────
                          Expanded(
                            child: KanbanColumn(
                              title: 'Personal Asignado',
                              icon: Icons.groups_rounded,
                              color: const Color(0xFF10B981), // Verde
                              tasks: allActiveTasks,
                              isStaffColumn: true,
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

          // Indicador de datos dummy vs live
          if (_usingDummyTasks || _usingDummyAlerts)
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
              decoration: BoxDecoration(
                color: Colors.amber.withValues(alpha: 0.1),
                borderRadius: BorderRadius.circular(8),
                border: Border.all(
                  color: Colors.amber.withValues(alpha: 0.3),
                  width: 1,
                ),
              ),
              child: const Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Icon(Icons.info_outline, size: 14, color: Colors.amber),
                  SizedBox(width: 6),
                  Text(
                    'Datos de demostración',
                    style: TextStyle(
                      color: Colors.amber,
                      fontSize: 11,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ],
              ),
            ),

          const SizedBox(width: 16),

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
