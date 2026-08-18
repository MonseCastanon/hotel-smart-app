import 'package:flutter/material.dart';

class FloorSelector extends StatelessWidget {
  final List<int> floors;
  final int selectedFloor;
  final ValueChanged<int?> onChanged;

  const FloorSelector({
    Key? key,
    required this.floors,
    required this.selectedFloor,
    required this.onChanged,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: Colors.grey.shade300),
      ),
      child: DropdownButtonHideUnderline(
        child: DropdownButton<int>(
          value: selectedFloor,
          icon: const Icon(Icons.arrow_drop_down, color: Colors.black54),
          focusColor: Colors.blue.withOpacity(0.1),
          items: floors.map((int floor) {
            return DropdownMenuItem<int>(
              value: floor,
              child: Text(
                'Piso $floor',
                style: const TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.w600,
                  color: Colors.black87,
                ),
              ),
            );
          }).toList(),
          onChanged: onChanged,
        ),
      ),
    );
  }
}
