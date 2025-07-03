import 'package:flutter/material.dart';
import 'package:workoutapp/screens/workout_results_page.dart';
import '../models/workout_plan.dart';
import '../database/app_database.dart';
import 'workout_recording_page.dart';
import '../widgets/qr_code_widget.dart';
import '../services/firestore_services.dart';
import 'qr_scanner_page.dart';

class GroupWorkoutPage extends StatefulWidget {
  final AppDatabase database;
  final WorkoutPlan plan;
  final String mode;

  GroupWorkoutPage({required this.database, required this.plan, required this.mode});

  @override
  _GroupWorkoutPageState createState() => _GroupWorkoutPageState();
}

class _GroupWorkoutPageState extends State<GroupWorkoutPage> {
  String? workoutId;
  WorkoutPlan? workoutPlan;
  bool isHost = false;
  bool isLoading = false;

  @override
  void initState() {
    super.initState();
  }

  void _createSession() async {
    setState(() => isLoading = true);

    workoutId = await FirestoreService().createWorkoutSession(widget.plan, widget.mode);
    isHost = true;
    workoutPlan = widget.plan;
    setState(() => isLoading = false);
  }

  void _scanQRCode() async {
    String? scannedCode = await Navigator.push(
      context,
      MaterialPageRoute(builder: (_) => QRScannerPage()),
    );

    if (scannedCode != null && scannedCode.isNotEmpty) {
      setState(() {
        workoutId = scannedCode;
        isHost = false;
        isLoading = true;
      });

      try {
        WorkoutPlan? fetchedPlan = await FirestoreService().fetchWorkoutPlan(workoutId!);

        if (fetchedPlan != null) {
          setState(() {
            workoutPlan = fetchedPlan;
          });
        } else {
          ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text("Workout plan not found. Try again!")));
        }
      } catch (e) {
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text("Error retrieving workout. Try again!")));
      }

      setState(() => isLoading = false);
    }
  }



  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("${widget.mode} Workout")),
      body: isLoading
          ? Center(child: CircularProgressIndicator())
          : Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          if (workoutId == null) ...[
            ElevatedButton(
              onPressed: _createSession,
              child: Text("Create Workout & Generate QR Code"),
            ),
            SizedBox(height: 20),
            ElevatedButton(
              onPressed: _scanQRCode,
              child: Text("Join Workout via QR Code"),
            ),
          ] else ...[
            if (isHost)
              QRCodeWidget(workoutId: workoutId!) // Show QR code if host
            else
              Text("Joined Workout: $workoutId", style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),

            SizedBox(height: 20),

            ElevatedButton(
              onPressed: (workoutPlan != null)
                  ? () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (_) => WorkoutRecordingPage(
                      database: widget.database,
                      selectedPlan: workoutPlan!,
                      workoutId: workoutId!,
                      mode: widget.mode,
                    ),
                  ),
                ).then((_) {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (_) => WorkoutResultsPage(
                        workoutId: workoutId!,
                        mode: widget.mode,
                      ),
                    ),
                  );
                });
              }
                  : null,
              child: Text("Proceed to Workout"),
            ),



          ],
        ],
      ),
    );
  }
}
