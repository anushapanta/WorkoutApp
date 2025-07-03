import 'package:flutter/material.dart';
import 'workout_recording_page.dart';
import 'group_workout_page.dart';
import '../models/workout_plan.dart';
import '../database/app_database.dart';

class WorkoutModeSelectionPage extends StatelessWidget {
  final AppDatabase database;
  final WorkoutPlan plan;

  WorkoutModeSelectionPage({required this.database, required this.plan});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("Choose Workout Mode")),
      body: Column(
        children: [
          ElevatedButton(
            child: Text("Solo Workout"),
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (_) => WorkoutRecordingPage(
                    database: database,
                    selectedPlan: plan,
                    workoutId: null,
                    mode:"solo",
                  ),
                ),
              );
            },
          ),
          ElevatedButton(
            child: Text("Collaborative Workout"),
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (_) => GroupWorkoutPage(
                    database: database,
                    plan: plan,
                    mode: "collaborative",
                  ),
                ),
              );
            },
          ),
          ElevatedButton(
            child: Text("Competitive Workout"),
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (_) => GroupWorkoutPage(
                    database: database,
                    plan: plan,
                    mode: "competitive",
                  ),
                ),
              );
            },
          ),
        ],
      ),
    );
  }
}
