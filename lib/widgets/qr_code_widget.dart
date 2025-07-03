import 'package:flutter/material.dart';
import 'package:qr_flutter/qr_flutter.dart';  // ✅ Import this package

class QRCodeWidget extends StatelessWidget {
  final String workoutId;

  const QRCodeWidget({super.key, required this.workoutId});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        QrImageView(  // ✅ Use `QrImageView` (latest name in `qr_flutter`)
          data: workoutId,
          version: QrVersions.auto,
          size: 200,
          backgroundColor: Colors.white,
        ),
        SizedBox(height: 10),
        SelectableText(
          "Workout ID: $workoutId",
          style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
        ),
      ],
    );
  }
}
