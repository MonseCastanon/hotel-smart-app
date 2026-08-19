import 'package:flutter/material.dart';

enum RoomType {
  single,
  double_,
  deluxe,
  suite,
  penthouse;

  /// Retorna el label legible para mostrar en UI
  String get label => switch (this) {
        RoomType.single => 'Sencilla',
        RoomType.double_ => 'Doble',
        RoomType.deluxe => 'Deluxe',
        RoomType.suite => 'Suite',
        RoomType.penthouse => 'Penthouse',
      };

  /// Parsea el string proveniente de Firestore al enum
  static RoomType fromString(String? raw) {
    switch (raw?.toLowerCase()) {
      case 'double':
        return RoomType.double_;
      case 'deluxe':
        return RoomType.deluxe;
      case 'suite':
        return RoomType.suite;
      case 'penthouse':
        return RoomType.penthouse;
      default:
        return RoomType.single;
    }
  }
}

enum RoomStatus {
  available,
  occupied,
  reserved,
  dirty,
  maintenance;

  /// Retorna el label en español para mostrar en UI
  String get label => switch (this) {
        RoomStatus.available => 'Limpia',
        RoomStatus.occupied => 'Ocupada',
        RoomStatus.reserved => 'Reservada',
        RoomStatus.dirty => 'Sucia',
        RoomStatus.maintenance => 'En Limpieza',
      };

  /// Parsea el string proveniente de Firestore al enum
  static RoomStatus fromString(String? raw) {
    switch (raw?.toLowerCase()) {
      case 'occupied':
        return RoomStatus.occupied;
      case 'reserved':
        return RoomStatus.reserved;
      case 'dirty':
        return RoomStatus.dirty;
      case 'maintenance':
        return RoomStatus.maintenance;
      default:
        return RoomStatus.available;
    }
  }
}

class RoomModel {
  final String id;
  final String numero;
  final int piso;
  final RoomType tipo;
  final RoomStatus estado;
  final double? precio;
  final String? descripcion;

  const RoomModel({
    this.id = '',
    required this.numero,
    required this.piso,
    required this.tipo,
    required this.estado,
    this.precio,
    this.descripcion,
  });

  /// Crea un [RoomModel] desde un documento de Firestore.
  /// Compatible con el esquema que guarda Hotel-Project.
  factory RoomModel.fromFirestore(String docId, Map<String, dynamic> data) {
    final rawNumber = data['roomNumber'] ?? data['number'];
    final numero = rawNumber?.toString() ?? docId;

    final rawFloor = data['floor'];
    int piso = 0;
    if (rawFloor is int) {
      piso = rawFloor;
    } else if (rawFloor is String) {
      piso = int.tryParse(rawFloor) ?? 0;
    } else if (numero.isNotEmpty) {
      // Infiere el piso del número de habitación (ej: "201" → piso 2)
      piso = int.tryParse(numero[0]) ?? 0;
    }

    return RoomModel(
      id: docId,
      numero: numero,
      piso: piso,
      tipo: RoomType.fromString(data['roomType'] ?? data['type']),
      estado: RoomStatus.fromString(data['status']),
      precio: (data['pricePerNight'] as num?)?.toDouble(),
      descripcion: data['description'] as String?,
    );
  }

  /// Crea un [RoomModel] desde un mapa JSON (respuesta del API REST).
  factory RoomModel.fromJson(Map<String, dynamic> json) {
    final rawNumber = json['roomNumber'] ?? json['number'];
    final numero = rawNumber?.toString() ?? '';

    final rawFloor = json['floor'];
    int piso = 0;
    if (rawFloor is int) {
      piso = rawFloor;
    } else if (rawFloor is String) {
      piso = int.tryParse(rawFloor) ?? 0;
    } else if (numero.isNotEmpty) {
      piso = int.tryParse(numero[0]) ?? 0;
    }

    return RoomModel(
      id: json['id']?.toString() ?? json['_id']?.toString() ?? numero,
      numero: numero,
      piso: piso,
      tipo: RoomType.fromString(json['roomType'] ?? json['type']),
      estado: RoomStatus.fromString(json['status']),
      precio: (json['pricePerNight'] as num?)?.toDouble(),
      descripcion: json['description'] as String?,
    );
  }

  Color get statusColor => switch (estado) {
        RoomStatus.available => const Color(0xFF4CAF50),
        RoomStatus.occupied => const Color(0xFFFF9800),
        RoomStatus.reserved => const Color(0xFF2196F3),
        RoomStatus.dirty => const Color(0xFFF44336),
        RoomStatus.maintenance => const Color(0xFF9C27B0),
      };

  String get statusText => estado.label;

  RoomModel copyWith({
    String? id,
    String? numero,
    int? piso,
    RoomType? tipo,
    RoomStatus? estado,
    double? precio,
    String? descripcion,
  }) {
    return RoomModel(
      id: id ?? this.id,
      numero: numero ?? this.numero,
      piso: piso ?? this.piso,
      tipo: tipo ?? this.tipo,
      estado: estado ?? this.estado,
      precio: precio ?? this.precio,
      descripcion: descripcion ?? this.descripcion,
    );
  }
}
