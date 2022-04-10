import 'package:flutter/material.dart';

class NotificationBadge extends StatelessWidget {
  final int notificationValue;
  NotificationBadge({Key? key, required this.notificationValue})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 40,
      height: 40,
      decoration: BoxDecoration(color: Colors.orange, shape: BoxShape.circle),
      child: Center(
        child: Text(
          '$notificationValue',
          style: TextStyle(fontSize: 20, color: Colors.white),
        ),
      ),
    );
  }
}
