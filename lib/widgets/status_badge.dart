import 'package:flutter/material.dart';
import '../models/room_model.dart';

class StatusBadge extends StatelessWidget {
  final RoomStatus estado;

  const StatusBadge({Key? key, required this.estado}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    // Instancia ficticia para acceder al mapeo de colores definido en el modelo
    final dummyRoom = RoomModel(
      numero: '',
      piso: 0,
      tipo: RoomType.estandar,
      estado: estado,
    );

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
      decoration: BoxDecoration(
        color: dummyRoom.statusColor,
        borderRadius: BorderRadius.circular(20),
      ),
      child: Text(
        dummyRoom.statusText,
        style: const TextStyle(
          color: Colors.white,
          fontWeight: FontWeight.bold,
          fontSize: 12,
        ),
      ),
    );
  }
}
