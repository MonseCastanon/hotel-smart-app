import 'dart:async';
import 'package:flutter/material.dart';
import '../models/notification_model.dart';

class NotificationBanner extends StatelessWidget {
  final NotificationModel notification;

  const NotificationBanner({super.key, required this.notification});

  /// Muestra una notificación push flotante en la parte superior de la pantalla.
  /// Aparece por 5 segundos con un efecto de deslizamiento y desvanecimiento,
  /// y luego se desvanece y auto-destruye.
  static void show(BuildContext context, NotificationModel notification) {
    final overlayState = Overlay.of(context);
    late OverlayEntry overlayEntry;

    overlayEntry = OverlayEntry(
      builder: (context) => _FloatingNotification(
        notification: notification,
        onDismiss: () {
          overlayEntry.remove();
        },
      ),
    );

    overlayState.insert(overlayEntry);
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
      padding: const EdgeInsets.symmetric(horizontal: 20.0, vertical: 16.0),
      decoration: BoxDecoration(
        color: Colors.orange,
        borderRadius: BorderRadius.circular(12.0),
        boxShadow: const [
          BoxShadow(
            color: Colors.black26,
            blurRadius: 10,
            offset: Offset(0, 4),
          ),
        ],
      ),
      child: Row(
        children: [
          const Icon(Icons.notifications, color: Colors.white, size: 28.0),
          const SizedBox(width: 16.0),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  notification.title,
                  style: const TextStyle(
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                    fontSize: 16.0,
                  ),
                ),
                const SizedBox(height: 2.0),
                Text(
                  notification.description,
                  style: const TextStyle(
                    color: Colors.white70,
                    fontSize: 14.0,
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(width: 16.0),
          Column(
            crossAxisAlignment: CrossAxisAlignment.end,
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                notification.relatedRoom,
                style: const TextStyle(
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                  fontSize: 15.0,
                ),
              ),
              const SizedBox(height: 2.0),
              Text(
                notification.time,
                style: const TextStyle(
                  color: Colors.white70,
                  fontSize: 13.0,
                ),
              ),
            ],
          )
        ],
      ),
    );
  }
}

/// Widget interno para manejar la animación y tiempo de vida de la notificación push flotante.
class _FloatingNotification extends StatefulWidget {
  final NotificationModel notification;
  final VoidCallback onDismiss;

  const _FloatingNotification({
    required this.notification,
    required this.onDismiss,
  });

  @override
  State<_FloatingNotification> createState() => _FloatingNotificationState();
}

class _FloatingNotificationState extends State<_FloatingNotification>
    with SingleTickerProviderStateMixin {
  late final AnimationController _controller;
  late final Animation<double> _opacityAnimation;
  late final Animation<Offset> _slideAnimation;
  Timer? _dismissTimer;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 500),
    );

    _opacityAnimation = CurvedAnimation(
      parent: _controller,
      curve: Curves.easeInOut,
    );

    _slideAnimation = Tween<Offset>(
      begin: const Offset(0.0, -1.2),
      end: Offset.zero,
    ).animate(CurvedAnimation(
      parent: _controller,
      curve: Curves.easeOutCubic,
    ));

    // Animación de entrada
    _controller.forward().then((_) {
      // Iniciar temporizador de 5 segundos
      _dismissTimer = Timer(const Duration(seconds: 5), () {
        if (mounted) {
          // Animación de salida (desvanecimiento y deslizamiento hacia arriba)
          _controller.reverse().then((_) {
            widget.onDismiss();
          });
        }
      });
    });
  }

  @override
  void dispose() {
    _dismissTimer?.cancel();
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Align(
        alignment: Alignment.topCenter,
        child: FractionallySizedBox(
          widthFactor: 0.9,
          child: SlideTransition(
            position: _slideAnimation,
            child: FadeTransition(
              opacity: _opacityAnimation,
              child: Material(
                color: Colors.transparent,
                child: Padding(
                  padding: const EdgeInsets.only(top: 16.0),
                  child: NotificationBanner(notification: widget.notification),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
