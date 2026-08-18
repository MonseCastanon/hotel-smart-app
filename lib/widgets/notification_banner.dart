import 'package:flutter/material.dart';
import '../models/notification_model.dart';

class NotificationBanner extends StatelessWidget {
  final NotificationModel notification;

  const NotificationBanner({super.key, required this.notification});

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
      padding: const EdgeInsets.all(16.0),
      decoration: BoxDecoration(
        color: Colors.orange.shade100,
        borderRadius: BorderRadius.circular(12.0),
      ),
      child: Row(
        children: [
          const Icon(Icons.notifications, color: Colors.orange),
          const SizedBox(width: 16.0),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  notification.title,
                  style: const TextStyle(fontWeight: FontWeight.bold),
                ),
                Text(notification.description),
              ],
            ),
          ),
          Column(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              Text(
                notification.relatedRoom,
                style: const TextStyle(fontWeight: FontWeight.bold),
              ),
              Text(notification.time),
            ],
          )
        ],
      ),
    );
  }
}
