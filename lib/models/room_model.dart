import 'package:flutter/material.dart';

enum RoomType {
  estandar,
  doble,
  deluxe,
  suite
}

enum RoomStatus {
  ocupada,
  limpia,
  sucia,
  enLimpieza
}

class RoomModel {
  final String numero;
  final int piso;
  final RoomType tipo;
  final RoomStatus estado;

  RoomModel({
    required this.numero,
    required this.piso,
    required this.tipo,
    required this.estado,
  });

  Color get statusColor {
    switch (estado) {
      case RoomStatus.ocupada:
        return Colors.orange;
      case RoomStatus.limpia:
        return Colors.green;
      case RoomStatus.sucia:
        return Colors.red;
      case RoomStatus.enLimpieza:
        return Colors.blue;
    }
  }

  String get statusText {
    switch (estado) {
      case RoomStatus.ocupada:
        return 'Ocupada';
      case RoomStatus.limpia:
        return 'Limpia';
      case RoomStatus.sucia:
        return 'Sucia';
      case RoomStatus.enLimpieza:
        return 'En Limpieza';
    }
  }
}
