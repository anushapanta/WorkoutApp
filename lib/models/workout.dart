import 'dart:convert';
import 'package:floor/floor.dart';
import '../database/type_converter.dart';

@Entity(tableName: 'workouts')
class Workout {
  @PrimaryKey(autoGenerate: true)
  final int id;
  @TypeConverters([DateTimeConverter])
  final DateTime workoutDate;
  final String resultsJson;

  Workout({required this.id, required this.workoutDate, required this.resultsJson});

  List<ExerciseResult> get exerciseResults {
    if (resultsJson.isEmpty) return [];
    try {
      final decoded = jsonDecode(resultsJson);
      return decoded is List
          ? decoded.map((e) => ExerciseResult.fromJson(e)).toList()
          : [];
    } catch (e) {
      return [];
    }
  }
  int get successfulExerciseCount {
    return exerciseResults.where((exercise) => exercise.isSuccessful).length;
  }
}

class ExerciseResult {
  final String name;
  final String unit;
  final String target;
  final String exerciseOutput;

  ExerciseResult({required this.name, required this.unit,required this.target, required this.exerciseOutput});

  factory ExerciseResult.fromJson(Map<String, dynamic> json) {
    return ExerciseResult(
      name: json["name"] ?? "Unknown",
      unit: json["unit"] ?? "",
      exerciseOutput: json["exerciseOutput"] ?? "0",
      target: json["target"] ?? "0",
    );
  }
  double get outputValue => double.tryParse(exerciseOutput) ?? 0;
  double get targetValue => double.tryParse(target) ?? 0;
  bool get isSuccessful => outputValue >= targetValue;
}

