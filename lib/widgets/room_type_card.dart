import 'package:flutter/material.dart';

class RoomTypeCard extends StatelessWidget {
  final String roomType;
  final int availableCount;

  const RoomTypeCard({
    super.key,
    required this.roomType,
    required this.availableCount,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 2.0,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12.0)),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Icon(Icons.bed, size: 48.0, color: Colors.blueGrey),
            const SizedBox(height: 8.0),
            Text(
              roomType,
              style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16.0),
            ),
            const SizedBox(height: 4.0),
            Text(
              '$availableCount disponibles',
              style: const TextStyle(color: Colors.grey),
            ),
          ],
        ),
      ),
    );
  }
}
