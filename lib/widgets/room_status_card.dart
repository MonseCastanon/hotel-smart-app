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
    return InkWell(
      onTap: widget.onTap ?? () {},
      onFocusChange: (focused) {
        setState(() {
          _isFocused = focused;
        });
      },
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(16),
          border: Border.all(
            color: _isFocused ? Colors.blueAccent : Colors.grey.shade300,
            width: _isFocused ? 4 : 1,
          ),
          boxShadow: _isFocused
              ? [
                  BoxShadow(
                    color: Colors.blueAccent.withValues(alpha: 0.3),
                    blurRadius: 8,
                    spreadRadius: 2,
                  ),
                ]
              : [const BoxShadow(color: Colors.black12, blurRadius: 4)],
        ),
        padding: const EdgeInsets.all(16),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              widget.room.numero,
              style: const TextStyle(
                fontSize: 32,
                fontWeight: FontWeight.bold,
                color: Colors.black87,
              ),
            ),
            const SizedBox(height: 12),
            StatusBadge(status: widget.room.estado.name),
          ],
        ),
      ),
    );
  }
}
