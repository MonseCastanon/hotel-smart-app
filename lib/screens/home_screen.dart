import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:hotel_smart_app/providers/notifications_provider.dart';
import 'package:hotel_smart_app/providers/tasks_provider.dart';
import 'package:hotel_smart_app/models/notification_model.dart';
import 'package:hotel_smart_app/models/task_model.dart';
import 'package:hotel_smart_app/widgets/alerts_panel.dart';
import 'package:hotel_smart_app/widgets/kanban_column.dart';

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
///   │      (pending)        │         (inProgress)         │
///   │                       │                              │
///   └───────────────────────┴──────────────────────────────┘
///
/// Se excluyen tareas completadas del tablero.
/// Las alertas se limitan a 10, ordenadas por fecha descendente.
/// Usa Riverpod para suscribirse a Firestore en tiempo real.
class HomeScreen extends ConsumerWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    // ── Streams de Firestore via Riverpod ─────────────────────────────────────
    final pendingAsync = ref.watch(pendingTasksStreamProvider);
    final inProgressAsync = ref.watch(inProgressTasksStreamProvider);
    final alertsAsync = ref.watch(notificationsProvider);

    // ── Extraer datos con manejo de estado ───────────────────────────────────
    final pendingTasks = pendingAsync.valueOrNull ?? <TaskModel>[];
    final inProgressTasks = inProgressAsync.valueOrNull ?? <TaskModel>[];
    final alerts = alertsAsync.valueOrNull ?? <NotificationModel>[];

    final isLoadingTasks = pendingAsync.isLoading || inProgressAsync.isLoading;
    final isLoadingAlerts = alertsAsync.isLoading;

    // ── Errores de Firestore en debug ─────────────────────────────────────────
    assert(() {
      if (pendingAsync.hasError) {
        debugPrint('[HomeScreen] Error en tareas pendientes: ${pendingAsync.error}');
      }
      if (inProgressAsync.hasError) {
        debugPrint('[HomeScreen] Error en tareas en progreso: ${inProgressAsync.error}');
      }
      if (alertsAsync.hasError) {
        debugPrint('[HomeScreen] Error en alertas: ${alertsAsync.error}');
      }
      return true;
    }());

    return Scaffold(
      backgroundColor: const Color(0xFF0F1117),
      body: SafeArea(
        child: Column(
          children: [
            // ── AppBar personalizada ──────────────────────────────────────
            _buildAppBar(),

            // ── Panel de Alertas (colapsable) ────────────────────────────
            if (!isLoadingAlerts) AlertsPanel(alerts: alerts),

            // ── Tablero Kanban (2 columnas) ──────────────────────────────
            Expanded(
              child: isLoadingTasks
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
                              tasks: pendingTasks,
                            ),
                          ),

                          const SizedBox(width: 16),

                          // ── Columna 2: En Progreso ─────────────────────
                          Expanded(
                            child: KanbanColumn(
                              title: 'En Progreso',
                              icon: Icons.trending_up_rounded,
                              color: const Color(0xFF3B82F6), // Azul
                              tasks: inProgressTasks,
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
