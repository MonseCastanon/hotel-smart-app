import 'package:flutter/material.dart';

class ServiceActionButton extends StatelessWidget {
  final IconData icon;
  final String title;
  final String subtitle;
  final bool isHighlighted;
  final VoidCallback onTap;

  const ServiceActionButton({
    super.key,
    required this.icon,
    required this.title,
    required this.subtitle,
    this.isHighlighted = false,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final backgroundColor = isHighlighted ? Colors.orange : Colors.white;
    final textColor = isHighlighted ? Colors.white : Colors.black;
    final iconColor = isHighlighted ? Colors.white : Colors.blueGrey;

    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(12.0),
      child: Container(
        padding: const EdgeInsets.all(24.0),
        decoration: BoxDecoration(
          color: backgroundColor,
          borderRadius: BorderRadius.circular(12.0),
          border: isHighlighted ? null : Border.all(color: Colors.grey.shade300),
          boxShadow: const [
            BoxShadow(
              color: Colors.black12,
              blurRadius: 4.0,
              offset: Offset(0, 2),
            ),
          ],
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(icon, size: 48.0, color: iconColor),
            const SizedBox(height: 16.0),
            Text(
              title,
              style: TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 18.0,
                color: textColor,
              ),
            ),
            const SizedBox(height: 8.0),
            Text(
              subtitle,
              style: TextStyle(
                fontSize: 14.0,
                color: isHighlighted ? Colors.white70 : Colors.grey.shade600,
              ),
              textAlign: TextAlign.center,
            ),
          ],
        ),
      ),
    );
  }
}
