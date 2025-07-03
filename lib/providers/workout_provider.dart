import 'package:flutter/material.dart';
import '../models/workout.dart';
import '../database/app_database.dart';
import '../models/workout_plan.dart';

class WorkoutProvider with ChangeNotifier {
  final List<Workout> _workouts = [];
  final List<WorkoutPlan> _downloadedWorkoutPlans = [];
  final AppDatabase database;

  WorkoutProvider(this.database) {
    _loadWorkouts();
  }

  List<Workout> get workouts => _workouts;
  List<WorkoutPlan> get downloadedWorkoutPlans => _downloadedWorkoutPlans;

  void addWorkout(Workout workout) async {
    _workouts.add(workout);
    await database.workoutDao.insertWorkout(workout);
    notifyListeners();
  }

  Future<void> _loadWorkouts() async {
    _workouts.clear();
    _workouts.addAll(await database.workoutDao.getAllWorkouts());
    notifyListeners();
  }

  void addWorkoutPlan(WorkoutPlan plan) {
    _downloadedWorkoutPlans.add(plan);
    notifyListeners();
  }
}
