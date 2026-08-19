import 'package:flutter/material.dart';

class StatusBadge extends StatelessWidget {
  final String status;

  const StatusBadge({super.key, required this.status});

  Color _getColor() {
    switch (status.toLowerCase()) {
      // Habitaciones
      case 'limpia':
      case 'available':
      case 'completado':
        return Colors.green.shade600;
      case 'sucia':
      case 'dirty':
        return Colors.red.shade600;
      case 'en limpieza':
      case 'maintenance':
      case 'en proceso':
      case 'inprogress':
        return Colors.blue.shade600;
      case 'ocupada':
      case 'occupied':
      case 'pendiente':
      case 'pending':
        return Colors.orange.shade700;
      case 'reservada':
      case 'reserved':
        return Colors.purple.shade600;
      case 'cancelado':
      case 'cancelled':
        return Colors.grey.shade600;
      default:
        return Colors.grey.shade500;
    }
  }

  String _getLabel() {
    switch (status.toLowerCase()) {
      case 'available': return 'Limpia';
      case 'occupied': return 'Ocupada';
      case 'reserved': return 'Reservada';
      case 'dirty': return 'Sucia';
      case 'maintenance': return 'En Limpieza';
      case 'pending': return 'Pendiente';
      case 'inprogress': return 'En proceso';
      case 'completed': return 'Completado';
      case 'cancelled': return 'Cancelado';
      default: return status;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10.0, vertical: 4.0),
      decoration: BoxDecoration(
        color: _getColor(),
        borderRadius: BorderRadius.circular(20.0),
      ),
      child: Text(
        _getLabel(),
        style: const TextStyle(
          color: Colors.white,
          fontSize: 11.0,
          fontWeight: FontWeight.w600,
        ),
      ),
    );
  }
}
