/// Estados posibles de una reservación (subconjunto relevante para Smart TV)
enum ReservationStatus {
  pending,
  confirmed,
  checkedIn,
  checkedOut,
  cancelled;

  String get label => switch (this) {
        ReservationStatus.pending => 'Pendiente',
        ReservationStatus.confirmed => 'Confirmada',
        ReservationStatus.checkedIn => 'Check-in realizado',
        ReservationStatus.checkedOut => 'Check-out realizado',
        ReservationStatus.cancelled => 'Cancelada',
      };
}

/// Modelo simplificado de reservación para la Smart TV.
/// Contiene únicamente la información necesaria para el dashboard
/// (identificador, habitación asociada y estado), sin la lógica de
/// negocio completa de hotel_app.
class ReservationModel {
  final String id;
  final String roomId;
  final String roomNumber;
  final String guestName;
  final DateTime checkIn;
  final DateTime checkOut;
  final ReservationStatus status;
  final double total;

  const ReservationModel({
    required this.id,
    required this.roomId,
    required this.roomNumber,
    required this.guestName,
    required this.checkIn,
    required this.checkOut,
    required this.status,
    required this.total,
  });

  /// Número de noches de la reservación
  int get nights => checkOut.difference(checkIn).inDays;

  /// Retorna true si está activa (pendiente o confirmada)
  bool get isActive =>
      status == ReservationStatus.pending ||
      status == ReservationStatus.confirmed;

  /// Retorna true si ya se realizó check-in
  bool get hasCheckedIn => status == ReservationStatus.checkedIn;

  /// Crea un [ReservationModel] desde un mapa de Firestore.
  factory ReservationModel.fromFirestore(
    String docId,
    Map<String, dynamic> data,
  ) {
    return ReservationModel(
      id: docId,
      roomId: data['roomId'] as String? ?? '',
      roomNumber: data['roomNumber'] as String? ?? '',
      guestName: data['guestName'] as String? ?? '',
      checkIn: _parseDate(data['checkIn']),
      checkOut: _parseDate(data['checkOut']),
      status: _parseStatus(data['status'] as String?),
      total: (data['total'] as num?)?.toDouble() ?? 0.0,
    );
  }

  /// Convierte el modelo a un mapa compatible con Firestore.
  Map<String, dynamic> toFirestore() => {
        'roomId': roomId,
        'roomNumber': roomNumber,
        'guestName': guestName,
        'checkIn': checkIn.toIso8601String(),
        'checkOut': checkOut.toIso8601String(),
        'status': status.name,
        'total': total,
      };

  // ---------------------------------------------------------------------------
  // Helpers privados
  // ---------------------------------------------------------------------------

  static DateTime _parseDate(dynamic value) {
    if (value == null) return DateTime.now();
    if (value is String) return DateTime.tryParse(value) ?? DateTime.now();
    // Firestore Timestamp
    try {
      return (value as dynamic).toDate() as DateTime;
    } catch (_) {
      return DateTime.now();
    }
  }

  static ReservationStatus _parseStatus(String? raw) {
    return ReservationStatus.values.firstWhere(
      (s) => s.name == raw,
      orElse: () => ReservationStatus.pending,
    );
  }

  ReservationModel copyWith({
    String? id,
    String? roomId,
    String? roomNumber,
    String? guestName,
    DateTime? checkIn,
    DateTime? checkOut,
    ReservationStatus? status,
    double? total,
  }) {
    return ReservationModel(
      id: id ?? this.id,
      roomId: roomId ?? this.roomId,
      roomNumber: roomNumber ?? this.roomNumber,
      guestName: guestName ?? this.guestName,
      checkIn: checkIn ?? this.checkIn,
      checkOut: checkOut ?? this.checkOut,
      status: status ?? this.status,
      total: total ?? this.total,
    );
  }

  @override
  String toString() =>
      'ReservationModel(id: $id, guest: $guestName, room: $roomNumber, status: ${status.label})';

  @override
  bool operator ==(Object other) =>
      identical(this, other) || other is ReservationModel && other.id == id;

  @override
  int get hashCode => id.hashCode;
}
