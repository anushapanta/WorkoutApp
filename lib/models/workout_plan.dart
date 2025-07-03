import 'dart:convert';
import 'package:floor/floor.dart';
import '../database/type_converter.dart';
import 'exercise.dart';

@Entity(tableName: 'workout_plans')
class WorkoutPlan {
  @primaryKey
  final String name;

  @TypeConverters([ExerciseListConverter])
  final String exercisesJson; // Stores exercises as JSON string

  WorkoutPlan({
    required this.name,
    required this.exercisesJson,
  });

  List<Exercise> get exercises {
    try {
      List<dynamic> decoded = jsonDecode(exercisesJson);
      return decoded.map((e) => Exercise.fromJson(e)).toList();
    } catch (e) {
      return [];
    }
  }

  String encodeExercises(List<Exercise> exercises) {
    return jsonEncode(exercises.map((e) => e.toJson()).toList());
  }

  Map<String, dynamic> toJson() {
    List<Exercise> exerciseList = exercises;
    return {
      "name": name,
      "exercises": exerciseList.map((e) => e.toJson()).toList(),
    };
  }

  factory WorkoutPlan.fromJson(Map<String, dynamic> json) {
    return WorkoutPlan(
      name: json["name"] ?? "Unnamed Workout",
      exercisesJson: json.containsKey("exercises")
          ? jsonEncode(json["exercises"].map((e) => {
        "name": e["name"],
        "target": e["target"],
        "unit": e["unit"]
      }).toList())
          : "[]",
    );
  }
}
