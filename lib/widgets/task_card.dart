import 'package:flutter/material.dart';

/// Tarjeta visual para cada tarea dentro del tablero Kanban.
///
/// Muestra el tipo de servicio, persona asignada, habitación y tiempo.
/// Los colores se diferencian por tipo de servicio:
///   - Limpieza → azul
///   - Mantenimiento → naranja
///   - Room Service → verde
///   - Otros → gris
class TaskCard extends StatelessWidget {
  final String serviceType;
  final String assignedTo;
  final String room;
  final String timeLabel;
  final String status;

  const TaskCard({
    super.key,
    required this.serviceType,
    required this.assignedTo,
    required this.room,
    required this.timeLabel,
    required this.status,
  });

  /// Traduce el tipo de servicio al español si viene en inglés desde Hotel-Project.
  String get _serviceLabel => switch (serviceType.toLowerCase()) {
        'cleaning' => 'Limpieza',
        'maintenance' => 'Mantenimiento',
        'inspection' => 'Inspección',
        'delivery' => 'Entrega',
        'guest_request' => 'Sol. Huésped',
        _ => serviceType,
      };

  /// Color principal según el tipo de servicio.
  Color get _serviceColor {
    switch (serviceType.toLowerCase()) {
      case 'limpieza':
      case 'cleaning':
        return const Color(0xFF3B82F6); // Azul
      case 'mantenimiento':
      case 'maintenance':
        return const Color(0xFFFF661A); // Naranja (marca)
      case 'inspección':
      case 'inspection':
        return const Color(0xFF8B5CF6); // Violeta
      case 'entrega':
      case 'delivery':
        return const Color(0xFF10B981); // Verde esmeralda
      case 'sol. huésped':
      case 'guest_request':
        return const Color(0xFFF59E0B); // Ámbar
      case 'room service':
        return const Color(0xFF10B981); // Verde esmeralda
      default:
        return const Color(0xFF6B7280); // Gris
    }
  }

  /// Icono según el tipo de servicio.
  IconData get _serviceIcon {
    switch (serviceType.toLowerCase()) {
      case 'limpieza':
      case 'cleaning':
        return Icons.cleaning_services_rounded;
      case 'mantenimiento':
      case 'maintenance':
        return Icons.build_rounded;
      case 'inspección':
      case 'inspection':
        return Icons.search_rounded;
      case 'entrega':
      case 'delivery':
        return Icons.local_shipping_rounded;
      case 'sol. huésped':
      case 'guest_request':
        return Icons.support_agent_rounded;
      case 'room service':
        return Icons.room_service_rounded;
      default:
        return Icons.task_alt_rounded;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(bottom: 10),
      decoration: BoxDecoration(
        color: const Color(0xFF1E2030),
        borderRadius: BorderRadius.circular(12),
        border: Border(
          left: BorderSide(color: _serviceColor, width: 4),
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.2),
            blurRadius: 4,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Padding(
        padding: const EdgeInsets.all(14),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // ── Encabezado: Tipo de servicio + tiempo ──────────────────
            Row(
              children: [
                Container(
                  padding: const EdgeInsets.all(6),
                  decoration: BoxDecoration(
                    color: _serviceColor.withValues(alpha: 0.15),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Icon(
                    _serviceIcon,
                    size: 18,
                    color: _serviceColor,
                  ),
                ),
                const SizedBox(width: 10),
                Expanded(
                  child: Text(
                    _serviceLabel,
                    style: TextStyle(
                      color: _serviceColor,
                      fontWeight: FontWeight.w700,
                      fontSize: 14,
                    ),
                  ),
                ),
                Text(
                  timeLabel,
                  style: TextStyle(
                    color: Colors.white.withValues(alpha: 0.4),
                    fontSize: 11,
                  ),
                ),
              ],
            ),

            const SizedBox(height: 10),

            // ── Persona asignada ───────────────────────────────────────
            Row(
              children: [
                Icon(
                  Icons.person_outline_rounded,
                  size: 16,
                  color: Colors.white.withValues(alpha: 0.6),
                ),
                const SizedBox(width: 6),
                Expanded(
                  child: Text(
                    assignedTo,
                    style: TextStyle(
                      color: Colors.white.withValues(alpha: 0.85),
                      fontSize: 13,
                      fontWeight: FontWeight.w500,
                    ),
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
              ],
            ),

            const SizedBox(height: 6),

            // ── Habitación ─────────────────────────────────────────────
            Row(
              children: [
                Icon(
                  Icons.door_front_door_outlined,
                  size: 16,
                  color: Colors.white.withValues(alpha: 0.6),
                ),
                const SizedBox(width: 6),
                Text(
                  'Hab. $room',
                  style: TextStyle(
                    color: Colors.white.withValues(alpha: 0.6),
                    fontSize: 12,
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
