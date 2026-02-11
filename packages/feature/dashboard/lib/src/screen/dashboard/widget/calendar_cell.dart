import 'package:flutter/material.dart';

class CalendarCell extends StatelessWidget {
  final String day;
  final Color? color;

  const CalendarCell({
    super.key,
    required this.day,
    this.color,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.all(2),
      decoration: BoxDecoration(
        color: color?.withOpacity(0.2),
        borderRadius: BorderRadius.circular(4),
        border: color != null ? Border.all(color: color!, width: 1) : null,
      ),
      alignment: Alignment.center,
      child: Text(
        day,
        style: TextStyle(
          fontSize: 12,
          fontWeight: color != null ? FontWeight.bold : FontWeight.normal,
          color: color ?? Colors.black87,
        ),
      ),
    );
  }
}
