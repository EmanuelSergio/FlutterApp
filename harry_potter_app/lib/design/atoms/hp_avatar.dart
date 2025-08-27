import 'package:flutter/material.dart';

class HPAvatar extends StatelessWidget {
  final String? imageUrl;
  final String label;
  final double radius;
  const HPAvatar({
    super.key,
    required this.label,
    this.imageUrl,
    this.radius = 20,
  });

  @override
  Widget build(BuildContext context) {
    if (imageUrl != null && imageUrl!.isNotEmpty) {
      return CircleAvatar(
        radius: radius,
        backgroundImage: NetworkImage(imageUrl!),
      );
    }
    return CircleAvatar(
      radius: radius,
      child: Text(label.isNotEmpty ? label[0] : '?'),
    );
  }
}
