import 'package:flutter/material.dart';
import '../models/notification_model.dart';

/// Panel de alertas con scroll vertical para la Smart TV.
///
/// Reemplaza la notificación flotante que causaba desbordamiento visual
/// cuando llegaban más de 5 alertas simultáneas.
///
/// Características:
///   - Scroll vertical con [ListView.builder] para manejar N alertas
///   - Máximo 10 alertas visibles (limitado en la consulta de Firestore)
///   - Ordenado por fecha de creación descendente
///   - Banner colapsable en la parte superior del tablero
///   - Diseño compacto para no robar espacio al Kanban
class AlertsPanel extends StatefulWidget {
  final List<NotificationModel> alerts;

  const AlertsPanel({super.key, required this.alerts});

  @override
  State<AlertsPanel> createState() => _AlertsPanelState();
}

class _AlertsPanelState extends State<AlertsPanel>
    with SingleTickerProviderStateMixin {
  bool _isExpanded = true;
  late final AnimationController _animController;
  late final Animation<double> _expandAnimation;

  @override
  void initState() {
    super.initState();
    _animController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 300),
    );
    _expandAnimation = CurvedAnimation(
      parent: _animController,
      curve: Curves.easeInOut,
    );
    // Iniciar expandido
    _animController.value = 1.0;
  }

  @override
  void dispose() {
    _animController.dispose();
    super.dispose();
  }

  void _toggleExpand() {
    setState(() {
      _isExpanded = !_isExpanded;
      if (_isExpanded) {
        _animController.forward();
      } else {
        _animController.reverse();
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    if (widget.alerts.isEmpty) return const SizedBox.shrink();

    return Container(
      margin: const EdgeInsets.fromLTRB(24, 16, 24, 0),
      decoration: BoxDecoration(
        color: const Color(0xFF1A1520),
        borderRadius: BorderRadius.circular(14),
        border: Border.all(
          color: const Color(0xFFFF661A).withValues(alpha: 0.3),
          width: 1,
        ),
        boxShadow: [
          BoxShadow(
            color: const Color(0xFFFF661A).withValues(alpha: 0.08),
            blurRadius: 12,
            spreadRadius: 0,
          ),
        ],
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          // ── Header clickeable ─────────────────────────────────────────
          InkWell(
            onTap: _toggleExpand,
            borderRadius: const BorderRadius.vertical(
              top: Radius.circular(14),
            ),
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
              child: Row(
                children: [
                  // Icono de alerta con pulso
                  Container(
                    padding: const EdgeInsets.all(6),
                    decoration: BoxDecoration(
                      color: const Color(0xFFFF661A).withValues(alpha: 0.15),
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: const Icon(
                      Icons.notifications_active_rounded,
                      size: 20,
                      color: Color(0xFFFF661A),
                    ),
                  ),
                  const SizedBox(width: 10),
                  Text(
                    'Alertas Activas',
                    style: TextStyle(
                      color: Colors.white.withValues(alpha: 0.9),
                      fontWeight: FontWeight.w700,
                      fontSize: 14,
                    ),
                  ),
                  const SizedBox(width: 8),
                  // Badge contador
                  Container(
                    padding:
                        const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                    decoration: BoxDecoration(
                      color: const Color(0xFFFF661A).withValues(alpha: 0.2),
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: Text(
                      '${widget.alerts.length}',
                      style: const TextStyle(
                        color: Color(0xFFFF661A),
                        fontWeight: FontWeight.w800,
                        fontSize: 12,
                      ),
                    ),
                  ),
                  const Spacer(),
                  // Flecha expandir/colapsar
                  AnimatedRotation(
                    turns: _isExpanded ? 0 : -0.25,
                    duration: const Duration(milliseconds: 300),
                    child: Icon(
                      Icons.keyboard_arrow_down_rounded,
                      color: Colors.white.withValues(alpha: 0.5),
                      size: 24,
                    ),
                  ),
                ],
              ),
            ),
          ),

          // ── Cuerpo expandible con scroll ──────────────────────────────
          SizeTransition(
            sizeFactor: _expandAnimation,
            child: ConstrainedBox(
              constraints: const BoxConstraints(maxHeight: 160),
              child: ListView.builder(
                padding:
                    const EdgeInsets.only(left: 16, right: 16, bottom: 12),
                shrinkWrap: true,
                itemCount: widget.alerts.length,
                itemBuilder: (context, index) {
                  final alert = widget.alerts[index];
                  return _AlertItem(alert: alert);
                },
              ),
            ),
          ),
        ],
      ),
    );
  }
}

/// Item individual de alerta dentro del panel.
class _AlertItem extends StatelessWidget {
  final NotificationModel alert;

  const _AlertItem({required this.alert});

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(bottom: 6),
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
      decoration: BoxDecoration(
        color: Colors.white.withValues(alpha: 0.04),
        borderRadius: BorderRadius.circular(10),
      ),
      child: Row(
        children: [
          // Indicador de urgencia
          Container(
            width: 6,
            height: 6,
            decoration: const BoxDecoration(
              color: Color(0xFFFF661A),
              shape: BoxShape.circle,
            ),
          ),
          const SizedBox(width: 10),

          // Contenido de la alerta
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  alert.title,
                  style: const TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.w600,
                    fontSize: 13,
                  ),
                  overflow: TextOverflow.ellipsis,
                ),
                const SizedBox(height: 2),
                Text(
                  alert.description,
                  style: TextStyle(
                    color: Colors.white.withValues(alpha: 0.5),
                    fontSize: 11,
                  ),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
              ],
            ),
          ),
          const SizedBox(width: 8),

          // Habitación
          if (alert.relatedRoom.isNotEmpty) ...[
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 3),
              decoration: BoxDecoration(
                color: Colors.white.withValues(alpha: 0.08),
                borderRadius: BorderRadius.circular(6),
              ),
              child: Text(
                alert.relatedRoom,
                style: TextStyle(
                  color: Colors.white.withValues(alpha: 0.6),
                  fontSize: 10,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ),
            const SizedBox(width: 8),
          ],

          // Tiempo
          Text(
            alert.timeAgo,
            style: TextStyle(
              color: Colors.white.withValues(alpha: 0.35),
              fontSize: 10,
            ),
          ),
        ],
      ),
    );
  }
}
