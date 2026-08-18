import 'package:flutter/material.dart';
import '../data/rooms_datasource.dart';
import '../models/room_model.dart';
import '../models/notification_model.dart';
import '../widgets/floor_selector.dart';
import '../widgets/notification_banner.dart';
import '../widgets/room_status_card.dart';

class RoomsScreen extends StatefulWidget {
  const RoomsScreen({super.key});

  @override
  State<RoomsScreen> createState() => _RoomsScreenState();
}

class _RoomsScreenState extends State<RoomsScreen> {
  final RoomsDatasource _roomsDatasource = RoomsDatasource();
  List<RoomModel> _rooms = [];
  int _selectedFloor = 1;
  final List<int> _availableFloors = [1, 2, 3, 4, 5];

  final NotificationModel _demoNotification = NotificationModel(
    title: 'Limpieza Solicitada',
    description: 'Se necesita limpieza urgente',
    relatedRoom: '201',
    time: 'Ahora',
  );

  @override
  void initState() {
    super.initState();
    _loadRooms();
  }

  Future<void> _loadRooms() async {
    final rooms = await _roomsDatasource.getRoomsByFloor(_selectedFloor);
    setState(() {
      _rooms = rooms;
    });
  }

  void _onFloorChanged(int? newFloor) {
    if (newFloor != null && newFloor != _selectedFloor) {
      setState(() {
        _selectedFloor = newFloor;
      });
      _loadRooms();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey.shade100,
      appBar: AppBar(
        title: const Text('Estado de Habitaciones'),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () {
            if (Navigator.canPop(context)) {
              Navigator.pop(context);
            }
          },
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(24.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                const Text(
                  'Filtrar por piso:',
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.w500),
                ),
                const SizedBox(width: 16),
                FloorSelector(
                  floors: _availableFloors,
                  selectedFloor: _selectedFloor,
                  onChanged: _onFloorChanged,
                ),
              ],
            ),
            const SizedBox(height: 16),
            NotificationBanner(notification: _demoNotification),
            const SizedBox(height: 24),
            const Text(
              'Habitaciones',
              style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 16),
            Expanded(
              child: _rooms.isEmpty
                  ? const Center(child: Text('No hay habitaciones en este piso.'))
                  : GridView.builder(
                      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                        crossAxisCount: 4,
                        crossAxisSpacing: 16,
                        mainAxisSpacing: 16,
                        childAspectRatio: 1.2,
                      ),
                      itemCount: _rooms.length,
                      itemBuilder: (context, index) {
                        return RoomStatusCard(
                          room: _rooms[index],
                          onTap: () {
                            // Acción al seleccionar habitación
                          },
                        );
                      },
                    ),
            ),
          ],
        ),
      ),
    );
  }
}
