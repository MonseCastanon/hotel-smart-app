import 'package:flutter/material.dart';

class StatusBadge extends StatelessWidget {
  final String status;

  const StatusBadge({super.key, required this.status});

  Color _getColor() {
    switch (status.toLowerCase()) {
      case 'limpia':
      case 'completado':
        return Colors.green;
      case 'sucia':
        return Colors.red;
      case 'en limpieza':
      case 'en proceso':
        return Colors.blue;
      case 'ocupada':
      case 'pendiente':
        return Colors.orange;
      default:
        return Colors.grey;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8.0, vertical: 4.0),
      decoration: BoxDecoration(
        color: _getColor(),
        borderRadius: BorderRadius.circular(8.0),
      ),
      child: Text(
        status,
        style: const TextStyle(color: Colors.white, fontSize: 12.0),
      ),
    );
  }
}
