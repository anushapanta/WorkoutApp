import 'package:flutter/material.dart';
import '../database/app_database.dart';
import '../models/workout_plan.dart';
import 'workout_mode_selection.dart';
import '../data/hardcoded_workout.dart';

class WorkoutSelectionPage extends StatefulWidget {
  final AppDatabase database;

  WorkoutSelectionPage({required this.database});

  @override
  _WorkoutSelectionPageState createState() => _WorkoutSelectionPageState();
}

class _WorkoutSelectionPageState extends State<WorkoutSelectionPage> {
  late Future<List<WorkoutPlan>> _workoutPlans;

  @override
  void initState() {
    super.initState();
    _workoutPlans = _fetchWorkoutPlans();
  }

  Future<List<WorkoutPlan>> _fetchWorkoutPlans() async {
    final dbPlans = await widget.database.workoutPlanDao.getAllWorkoutPlans();
    return [sampleWorkoutPlan, ...dbPlans];
  }

  void _selectWorkoutMode(WorkoutPlan plan) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (_) => WorkoutModeSelectionPage(database: widget.database, plan: plan),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("Select Workout Plan")),
      body: FutureBuilder<List<WorkoutPlan>>(
        future: _workoutPlans,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(child: CircularProgressIndicator());
          } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
            return Center(child: Text("No workout plans available."));
          }

          return ListView.builder(
            itemCount: snapshot.data!.length,
            itemBuilder: (context, index) {
              final plan = snapshot.data![index];

              return ListTile(
                title: Text(plan.name),
                subtitle: Text("${plan.exercises.length} exercises"),
                trailing: ElevatedButton(
                  child: Text("Select"),
                  onPressed: () => _selectWorkoutMode(plan),
                ),
              );
            },
          );
        },
      ),
    );
  }
}
