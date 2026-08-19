import 'package:flutter/material.dart';
import '../models/room_model.dart';
import 'status_badge.dart';

class RoomStatusCard extends StatefulWidget {
  final RoomModel room;
  final VoidCallback? onTap;

  const RoomStatusCard({super.key, required this.room, this.onTap});

  @override
  State<RoomStatusCard> createState() => _RoomStatusCardState();
}

class _RoomStatusCardState extends State<RoomStatusCard> {
  bool _isFocused = false;

  @override
  Widget build(BuildContext context) {
    final room = widget.room;

    return InkWell(
      onTap: widget.onTap ?? () {},
      onFocusChange: (focused) => setState(() => _isFocused = focused),
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        decoration: BoxDecoration(
          color: Theme.of(context).cardColor,
          borderRadius: BorderRadius.circular(16),
          border: Border.all(
            color: _isFocused
                ? room.statusColor
                : room.statusColor.withValues(alpha: 0.3),
            width: _isFocused ? 3 : 1.5,
          ),
          boxShadow: _isFocused
              ? [
                  BoxShadow(
                    color: room.statusColor.withValues(alpha: 0.35),
                    blurRadius: 12,
                    spreadRadius: 2,
                  ),
                ]
              : [
                  const BoxShadow(color: Colors.black26, blurRadius: 4),
                ],
        ),
        padding: const EdgeInsets.all(14),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            // Número de habitación
            Text(
              'Hab. ${room.numero}',
              style: TextStyle(
                fontSize: 22,
                fontWeight: FontWeight.bold,
                color: _isFocused ? room.statusColor : null,
              ),
            ),
            const SizedBox(height: 8),
            // Badge de estado
            StatusBadge(status: room.estado.name),
            const SizedBox(height: 6),
            // Tipo de habitación
            Text(
              room.tipo.label,
              style: const TextStyle(
                fontSize: 11,
                color: Colors.white54,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
