import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import '../models/exercise_result.dart' as er;
import '../models/workout.dart' as w;
import '../models/workout_plan.dart';
import '../database/app_database.dart';

class WorkoutRecordingPage extends StatefulWidget {
  final AppDatabase database;
  final String? workoutId;
  final WorkoutPlan selectedPlan;
  final String mode;

  WorkoutRecordingPage({
    required this.database,
    required this.selectedPlan,
    required this.mode,
    this.workoutId,
  });

  @override
  _WorkoutRecordingPageState createState() => _WorkoutRecordingPageState();
}

class _WorkoutRecordingPageState extends State<WorkoutRecordingPage> {
  final Map<String, TextEditingController> _controllers = {};

  @override
  void initState() {
    super.initState();

    for (var exercise in widget.selectedPlan.exercises) {
      _controllers[exercise.name] = TextEditingController();
    }
  }

  @override
  void dispose() {
    for (var controller in _controllers.values) {
      controller.dispose();
    }
    super.dispose();
  }

  // Future<void> _saveWorkout() async {
  //   List<er.ExerciseResult> results = widget.selectedPlan.exercises.map((exercise) {
  //     return er.ExerciseResult(
  //       name: exercise.name,
  //       target: exercise.target,
  //       unit: exercise.unit ?? "",
  //       exerciseOutput: _controllers[exercise.name]?.text ?? "0",
  //     );
  //   }).toList();
  //
  //   if (widget.mode == "solo") {
  //     final newWorkout = w.Workout(
  //       id: DateTime.now().millisecondsSinceEpoch,
  //       workoutDate: DateTime.now(),
  //       resultsJson: jsonEncode(results),
  //     );
  //     await widget.database.workoutDao.insertWorkout(newWorkout);
  //   } else {
  //     if (widget.workoutId != null) {
  //       await FirebaseFirestore.instance.collection("workouts").doc(widget.workoutId).update({
  //         "results": FieldValue.arrayUnion(results.map((e) => e.toJson()).toList()),
  //       });
  //     } else {
  //     }
  //   }
  //
  //   Navigator.pop(context);
  // }

  Future<void> _saveWorkout() async {
    List<Map<String, dynamic>> results = widget.selectedPlan.exercises.map((exercise) {
      return {
        "name": exercise.name,
        "exerciseOutput": int.tryParse(_controllers[exercise.name]?.text ?? "0") ?? 0,
        "unit": exercise.unit,
        "target": exercise.target,
      };
    }).toList();

    String userId = "user_${DateTime.now().millisecondsSinceEpoch}";

    if (widget.mode == "solo") {
      final newWorkout = w.Workout(
        id: DateTime.now().millisecondsSinceEpoch,
        workoutDate: DateTime.now(),
        resultsJson: jsonEncode(results),
      );
      await widget.database.workoutDao.insertWorkout(newWorkout);
    } else {
      if (widget.workoutId != null) {
        DocumentReference workoutRef = FirebaseFirestore.instance.collection("workouts").doc(widget.workoutId);

        if (widget.mode == "collaborative") {
          for (var result in results) {
            await workoutRef.collection("results").doc(result["name"]).set({
              "totalOutput": FieldValue.increment(result["exerciseOutput"]),
              "unit": result["unit"],
              "target": result["target"],
            }, SetOptions(merge: true));
          }
        } else if (widget.mode == "competitive") {
          await workoutRef.collection("results").doc(userId).set({
            "userName": userId,
            "exercises": results.map((e) => {
              "name": e["name"],
              "exerciseOutput": int.tryParse(e["exerciseOutput"].toString()) ?? 0,
              "unit": e["unit"],
              "target": e["target"],
            }).toList(),
            "totalScore": results.fold<int>(0, (sum, e) => sum + (int.tryParse(e["exerciseOutput"].toString()) ?? 0)),
          });
        }
      }
    }

    Navigator.pop(context);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("Record Workout")),
      body: ListView(
        padding: EdgeInsets.all(16),
        children: [
          Text(widget.selectedPlan.name, style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
          SizedBox(height: 10),
          if (widget.selectedPlan.exercises.isEmpty)
            Text("No exercises found!", style: TextStyle(color: Colors.red)),
          ...widget.selectedPlan.exercises.map((exercise) {
            return Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text("${exercise.name} (${exercise.unit})", style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
                TextField(
                  controller: _controllers[exercise.name],
                  keyboardType: TextInputType.number,
                  decoration: InputDecoration(hintText: "Enter ${exercise.unit}"),
                ),
                SizedBox(height: 12),
              ],
            );
          }).toList(),
          ElevatedButton(
            onPressed: _saveWorkout,
            child: Text("Finish Workout"),
          ),
        ],
      ),
    );
  }
}
