
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:mobile_scanner/mobile_scanner.dart';
import 'package:image_picker/image_picker.dart';
import 'dart:convert';

class QRScannerPage extends StatefulWidget {
  @override
  _QRScannerPageState createState() => _QRScannerPageState();
}

class _QRScannerPageState extends State<QRScannerPage> {
  final ImagePicker _picker = ImagePicker();
  MobileScannerController _scannerController = MobileScannerController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("Scan QR Code")),
      body: Column(
        children: [
          Expanded(
            child: MobileScanner(
              controller: _scannerController,
              onDetect: (capture) {
                final List<Barcode> barcodes = capture.barcodes;
                if (barcodes.isNotEmpty) {
                  String scannedData = barcodes.first.rawValue ?? "";

                  try {
                    Map<String, dynamic> qrData = jsonDecode(scannedData);
                    if (qrData.containsKey("workoutId")) {
                      Navigator.pop(context, qrData["workoutId"]);
                    } else {
                    }
                  } catch (e) {
                  }
                }
              },
            ),
          ),
          SizedBox(height: 20),
          ElevatedButton(
            onPressed: _scanFromGallery,
            child: Text("Upload QR Code Image"),
          ),
        ],
      ),
    );
  }


  Future<void> _scanFromGallery() async {
    final XFile? image = await _picker.pickImage(source: ImageSource.gallery);

    if (image != null) {

      String? latestWorkoutId = await _fetchLatestWorkout();

      if (latestWorkoutId != null) {
        Navigator.pop(context, latestWorkoutId);
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text("No workouts found!"))
        );
      }
    } else {
    }
  }

  Future<String?> _fetchLatestWorkout() async {
    try {
      QuerySnapshot snapshot = await FirebaseFirestore.instance
          .collection("workouts")
          .orderBy("createdAt", descending: true)
          .limit(1)
          .get();

      if (snapshot.docs.isNotEmpty) {
        return snapshot.docs.first.id;
      }
    } catch (e) {
    }
    return null;
  }





}
