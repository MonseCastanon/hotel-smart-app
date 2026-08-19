import '../models/room_model.dart';

/// Datasource local con datos de prueba para desarrollo sin Firebase.
/// Usa los mismos valores de enum que el esquema de Firestore (Hotel-Project).
/// Solo se utiliza como fallback o en testing.
class RoomsDatasource {
  final List<RoomModel> _dummyRooms = [
    const RoomModel(id: '1', numero: '101', piso: 1, tipo: RoomType.single, estado: RoomStatus.available),
    const RoomModel(id: '2', numero: '102', piso: 1, tipo: RoomType.double_, estado: RoomStatus.occupied),
    const RoomModel(id: '3', numero: '201', piso: 2, tipo: RoomType.deluxe, estado: RoomStatus.dirty),
    const RoomModel(id: '4', numero: '202', piso: 2, tipo: RoomType.suite, estado: RoomStatus.maintenance),
    const RoomModel(id: '5', numero: '203', piso: 2, tipo: RoomType.single, estado: RoomStatus.available),
    const RoomModel(id: '6', numero: '301', piso: 3, tipo: RoomType.double_, estado: RoomStatus.occupied),
  ];

  Future<List<RoomModel>> getRoomsByFloor(int floor) async {
    return _dummyRooms.where((room) => room.piso == floor).toList();
  }

  Future<List<RoomModel>> getAllRooms() async {
    return _dummyRooms;
  }
}
