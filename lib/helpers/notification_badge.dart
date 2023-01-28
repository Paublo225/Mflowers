import 'package:flutter/material.dart';

class NotificationBadge extends StatelessWidget {
  final int totalNotifications;

  const NotificationBadge({this.totalNotifications});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 15.0,
      height: 15.0,
      decoration: new BoxDecoration(
        color: Colors.red,
        shape: BoxShape.circle,
      ),
      child: Center(
        child: Padding(
          padding: const EdgeInsets.all(3.0),
          child: Text(
            totalNotifications.toString(),
            style: TextStyle(
                color: Colors.white, fontSize: 8, fontWeight: FontWeight.bold),
          ),
        ),
      ),
    );
  }
}
