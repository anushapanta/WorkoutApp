import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import '../database/app_database.dart';
import '../models/workout_plan.dart';

class WorkoutDownloadPage extends StatefulWidget {
  final AppDatabase database;
  WorkoutDownloadPage({required this.database});

  @override
  _WorkoutDownloadPageState createState() => _WorkoutDownloadPageState();
}

class _WorkoutDownloadPageState extends State<WorkoutDownloadPage> {
  final TextEditingController _urlController = TextEditingController();
  WorkoutPlan? _downloadedPlan;

  Future<void> _downloadWorkoutPlan(BuildContext context) async {
    try {
      final response = await http.get(Uri.parse(_urlController.text));
      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        final plan = WorkoutPlan(name: data['name'], exercisesJson: json.encode(data['exercises']));

        setState(() {
          _downloadedPlan = plan;
        });

        _showPreviewDialog(context, plan);
      } else {
        _showMessage(context, 'Invalid server response');
      }
    } catch (_) {
      _showMessage(context, 'Invalid URL ');
    }
  }

  void _showPreviewDialog(BuildContext context, WorkoutPlan plan) {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) => AlertDialog(
        title: Text("Preview Workout Plan"),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text("Workout Name: ${plan.name}", style: TextStyle(fontWeight: FontWeight.bold)),
            SizedBox(height: 10),
            ...json.decode(plan.exercisesJson).map<Widget>((exercise) {
              return Text("${exercise['name']} - ${exercise['target']} ${exercise['unit']}");
            }).toList(),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => _discardAndGoHome(context),
            child: Text("Discard"),
          ),
          ElevatedButton(
            onPressed: () => _saveAndGoHome(context, plan),
            child: Text("Save"),
          ),
        ],
      ),
    );
  }

  Future<void> _saveAndGoHome(BuildContext context, WorkoutPlan plan) async {
    await widget.database.workoutPlanDao.insertWorkoutPlan(plan);
    Navigator.pop(context);
    _goHome(context);
  }

  void _discardAndGoHome(BuildContext context) {
    Navigator.pop(context);
    _goHome(context);
  }

  void _goHome(BuildContext context) {
    Navigator.pop(context);
  }

  void _showMessage(BuildContext context, String message) {
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(message)));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("Download Workout Plan")),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            TextField(
              controller: _urlController,
              decoration: InputDecoration(labelText: "Enter workout data URL"),
            ),
            SizedBox(height: 10),
            ElevatedButton(
              onPressed: () => _downloadWorkoutPlan(context),
              child: Text("Download Workout Plan"),
            ),
          ],
        ),
      ),
    );
  }
}


