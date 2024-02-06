import 'package:flutter/material.dart';

class ForcastItems extends StatelessWidget {
  final String time;
  final IconData icons;
  final String temp;
  const ForcastItems(
      {super.key, required this.icons, required this.time, required this.temp});

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 6,
      child: Container(
        width: 100,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(18),
        ),
        padding: const EdgeInsets.all(8.0),
        child: Column(
          children: [
            Text(
              time,
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
              style: const TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(
              height: 8,
            ),
            Icon(
              icons,
              size: 32,
            ),
            const SizedBox(
              height: 8,
            ),
            Text(temp),
          ],
        ),
      ),
    );
  }
}
