import '../models/room_model.dart';

class RoomsDatasource {
  final List<RoomModel> _dummyRooms = [
    RoomModel(numero: '101', piso: 1, tipo: RoomType.estandar, estado: RoomStatus.limpia),
    RoomModel(numero: '102', piso: 1, tipo: RoomType.doble, estado: RoomStatus.ocupada),
    RoomModel(numero: '201', piso: 2, tipo: RoomType.deluxe, estado: RoomStatus.sucia),
    RoomModel(numero: '202', piso: 2, tipo: RoomType.suite, estado: RoomStatus.enLimpieza),
    RoomModel(numero: '203', piso: 2, tipo: RoomType.estandar, estado: RoomStatus.limpia),
    RoomModel(numero: '301', piso: 3, tipo: RoomType.doble, estado: RoomStatus.ocupada),
  ];

  Future<List<RoomModel>> getRoomsByFloor(int floor) async {
    return _dummyRooms.where((room) => room.piso == floor).toList();
  }

  Future<List<RoomModel>> getAllRooms() async {
    return _dummyRooms;
  }
}
