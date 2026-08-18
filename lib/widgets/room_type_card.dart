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
      onTap: () {}, // Necesario para que sea interactivo con control remoto / teclado
      onFocusChange: (focused) {
        setState(() {
          _isFocused = focused;
        });
      },
      borderRadius: BorderRadius.circular(16.0),
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        decoration: BoxDecoration(
          color: widget.color, // Toda la card tiene su color correspondiente
          borderRadius: BorderRadius.circular(16.0),
          border: Border.all(
            color: _isFocused ? Colors.white : Colors.transparent,
            width: _isFocused ? 3 : 1,
          ),
          boxShadow: _isFocused
              ? [
                  BoxShadow(
                    color: widget.color.withValues(alpha: 0.4),
                    blurRadius: 12,
                    spreadRadius: 3,
                  ),
                ]
              : [const BoxShadow(color: Colors.black26, blurRadius: 6)],
        ),
        padding: const EdgeInsets.all(16.0),
        child: FittedBox(
          fit: BoxFit.scaleDown,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(
                widget.icon,
                size: 44.0,
                color: Colors.white,
              ),
              const SizedBox(height: 12.0),
              Text(
                widget.title,
                style: const TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 30.0, // Título centrado y más grande
                  color: Colors.white,
                ),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 12.0),
              Text(
                '${widget.count}',
                style: const TextStyle(
                  fontSize: 52.0, // Número grande y blanco
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
