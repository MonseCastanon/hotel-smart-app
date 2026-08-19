import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../providers/rooms_provider.dart';
import '../providers/notifications_provider.dart';
import '../widgets/floor_selector.dart';
import '../widgets/notification_banner.dart';
import '../widgets/room_status_card.dart';

class RoomsScreen extends ConsumerStatefulWidget {
  const RoomsScreen({super.key});

  @override
  ConsumerState<RoomsScreen> createState() => _RoomsScreenState();
}

class _RoomsScreenState extends ConsumerState<RoomsScreen> {
  int _selectedFloor = 1;
  bool _notificationShown = false;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _scheduleNotification();
    });
  }

  void _scheduleNotification() {
    Future.delayed(const Duration(milliseconds: 800), () {
      if (!mounted || _notificationShown) return;
      final notificationsAsync = ref.read(notificationsProvider);
      notificationsAsync.whenData((notifications) {
        if (notifications.isNotEmpty && mounted && !_notificationShown) {
          _notificationShown = true;
          NotificationBanner.show(context, notifications.first);
        }
      });
    });
  }

  void _onFloorChanged(int? newFloor) {
    if (newFloor != null && newFloor != _selectedFloor) {
      setState(() => _selectedFloor = newFloor);
    }
  }

  @override
  Widget build(BuildContext context) {
    // Escucha las habitaciones del piso seleccionado en tiempo real
    final roomsAsync = ref.watch(roomsByFloorProvider(_selectedFloor));
    // Pisos disponibles dinámicamente desde Firestore
    final floorsAsync = ref.watch(availableFloorsProvider);

    return Scaffold(
      backgroundColor: Theme.of(context).scaffoldBackgroundColor,
      appBar: AppBar(
        title: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Text('Estado de Habitaciones'),
            const SizedBox(width: 10),
            // Indicador de conexión en tiempo real
            roomsAsync.when(
              data: (_) => _buildLiveBadge(),
              loading: () => const SizedBox(
                width: 14,
                height: 14,
                child: CircularProgressIndicator(
                    strokeWidth: 2, color: Colors.white),
              ),
              error: (e, _) =>
                  const Icon(Icons.wifi_off, size: 16, color: Colors.white70),
            ),
          ],
        ),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () {
            if (Navigator.canPop(context)) Navigator.pop(context);
          },
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(24.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // ── Selector de piso ──────────────────────────────────────────────
            Row(
              children: [
                const Text(
                  'Filtrar por piso:',
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.w500),
                ),
                const SizedBox(width: 16),
                floorsAsync.when(
                  data: (floors) => FloorSelector(
                    floors: floors.isEmpty ? [1, 2, 3, 4, 5] : floors,
                    selectedFloor: _selectedFloor,
                    onChanged: _onFloorChanged,
                  ),
                  loading: () => FloorSelector(
                    floors: const [1, 2, 3, 4, 5],
                    selectedFloor: _selectedFloor,
                    onChanged: _onFloorChanged,
                  ),
                  error: (e, _) => FloorSelector(
                    floors: const [1, 2, 3, 4, 5],
                    selectedFloor: _selectedFloor,
                    onChanged: _onFloorChanged,
                  ),
                ),
                const SizedBox(width: 24),
                // Leyenda de colores
                _buildLegend(),
              ],
            ),
            const SizedBox(height: 16),

            // ── Subtítulo con piso y cantidad ─────────────────────────────────
            roomsAsync.when(
              data: (rooms) => Text(
                'Piso $_selectedFloor — ${rooms.length} habitación${rooms.length != 1 ? 'es' : ''}',
                style:
                    const TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
              ),
              loading: () => const Text('Cargando…',
                  style: TextStyle(fontSize: 16, color: Colors.white54)),
              error: (e, _) => const SizedBox.shrink(),
            ),
            const SizedBox(height: 16),

            // ── Grid de habitaciones ──────────────────────────────────────────
            Expanded(
              child: roomsAsync.when(
                data: (rooms) {
                  if (rooms.isEmpty) {
                    return Center(
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          const Icon(Icons.hotel_outlined,
                              size: 56, color: Colors.white24),
                          const SizedBox(height: 12),
                          Text(
                            'No hay habitaciones registradas en el piso $_selectedFloor',
                            style: const TextStyle(
                                color: Colors.white54, fontSize: 15),
                          ),
                        ],
                      ),
                    );
                  }
                  return GridView.builder(
                    gridDelegate:
                        const SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: 5,
                      crossAxisSpacing: 16,
                      mainAxisSpacing: 16,
                      childAspectRatio: 1.1,
                    ),
                    itemCount: rooms.length,
                    itemBuilder: (context, index) {
                      return RoomStatusCard(
                        room: rooms[index],
                        onTap: () {
                          // TODO: navegar al detalle de la habitación
                        },
                      );
                    },
                  );
                },
                loading: () =>
                    const Center(child: CircularProgressIndicator()),
                error: (e, _) => Center(
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      const Icon(Icons.cloud_off,
                          size: 48, color: Colors.orange),
                      const SizedBox(height: 12),
                      const Text(
                        'Error al cargar habitaciones',
                        style: TextStyle(color: Colors.orange),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        e.toString(),
                        style: const TextStyle(
                            color: Colors.white38, fontSize: 12),
                        textAlign: TextAlign.center,
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildLiveBadge() {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
      decoration: BoxDecoration(
        color: Colors.green.withValues(alpha: 0.2),
        borderRadius: BorderRadius.circular(10),
        border: Border.all(color: Colors.green, width: 1),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(
            width: 6,
            height: 6,
            decoration: const BoxDecoration(
              color: Colors.green,
              shape: BoxShape.circle,
            ),
          ),
          const SizedBox(width: 4),
          const Text(
            'EN VIVO',
            style: TextStyle(
              fontSize: 10,
              color: Colors.green,
              fontWeight: FontWeight.w700,
              letterSpacing: 0.5,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildLegend() {
    final items = [
      ('Limpia', Colors.green.shade600),
      ('Ocupada', Colors.orange.shade700),
      ('Sucia', Colors.red.shade600),
      ('En Limpieza', Colors.blue.shade600),
      ('Reservada', Colors.purple.shade600),
    ];
    return Wrap(
      spacing: 12,
      children: items
          .map(
            (item) => Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Container(
                  width: 10,
                  height: 10,
                  decoration: BoxDecoration(
                    color: item.$2,
                    shape: BoxShape.circle,
                  ),
                ),
                const SizedBox(width: 4),
                Text(
                  item.$1,
                  style:
                      const TextStyle(fontSize: 11, color: Colors.white70),
                ),
              ],
            ),
          )
          .toList(),
    );
  }
}
