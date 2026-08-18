import 'package:flutter/material.dart';

class RoomTypeCard extends StatefulWidget {
  final String title;
  final int count;
  final IconData icon;
  final Color color;

  const RoomTypeCard({
    super.key,
    required this.title,
    required this.count,
    required this.icon,
    required this.color,
  });

  @override
  State<RoomTypeCard> createState() => _RoomTypeCardState();
}

class _RoomTypeCardState extends State<RoomTypeCard> {
  bool _isFocused = false;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () {}, // Necesario para que sea interactivo con Enter
      onFocusChange: (focused) {
        setState(() {
          _isFocused = focused;
        });
      },
      borderRadius: BorderRadius.circular(16.0),
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        decoration: BoxDecoration(
          color: Theme.of(context).cardColor,
          borderRadius: BorderRadius.circular(16.0),
          border: Border.all(
            color: _isFocused ? widget.color : Colors.transparent,
            width: _isFocused ? 3 : 1,
          ),
          boxShadow: _isFocused
              ? [
                  BoxShadow(
                    color: widget.color.withValues(alpha: 0.3),
                    blurRadius: 8,
                    spreadRadius: 2,
                  ),
                ]
              : [const BoxShadow(color: Colors.black12, blurRadius: 4)],
        ),
        padding: const EdgeInsets.all(16.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(widget.icon, size: 48.0, color: widget.color),
            const SizedBox(height: 8.0),
            Text(
              widget.title,
              style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 18.0),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 8.0),
            Text(
              '${widget.count}',
              style: TextStyle(
                fontSize: 32.0,
                fontWeight: FontWeight.bold,
                color: widget.color,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
