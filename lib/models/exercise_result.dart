class ExerciseResult {
  final String name;
  final String unit;
  final String target;
  final String exerciseOutput;

  ExerciseResult({
    required this.name,
    required this.unit,
    required this.target,
    required this.exerciseOutput,
  });

  // Convert JSON to ExerciseResult
  factory ExerciseResult.fromJson(Map<String, dynamic> json) {
    return ExerciseResult(
      name: json['name'],
      target:json['target'],
      unit: json['unit'],
      exerciseOutput: json['exerciseOutput'],
    );
  }

  // Convert ExerciseResult object to JSON
  Map<String, dynamic> toJson() {
    return {
      'name': name,
      'target':target,
      'unit': unit,
      'exerciseOutput': exerciseOutput,
    };
  }
}
