import 'dart:convert';
import '../models/workout_plan.dart';
import '../models/exercise.dart';

// Hardcoded exercise data--assigment 3
final List<Exercise> hardcodedExercises = [
  Exercise(name: "Push-Ups",target: '100', unit: "repetitions"),
  Exercise(name: "Sit-ups",target: '100', unit: "seconds"),
  Exercise(name: "Running",target: '100', unit: "meters"),
  Exercise(name: "Squats", target: '100',unit: "repetitions"),
  Exercise(name: "Plank", target: '100',unit: "seconds"),
  Exercise(name: "Swimming",target: '100', unit: "meters"),
  Exercise(name: "Walking",target: '100', unit: "meters"),
  Exercise(name: "Sit-ups",target: '100', unit: "repetitions"),
];

// Convert hardcoded exercises list to JSON
final String exercisesJson = jsonEncode(
    hardcodedExercises.map((e) => {'name': e.name, 'target':e.target,'unit': e.unit}).toList()
);

// Create Hardcoded Workout Plan to show as one of the workout plan
final WorkoutPlan sampleWorkoutPlan = WorkoutPlan(
  name: "Beginner Full Body Workout",
  exercisesJson: exercisesJson,
);
