class Exercise {
  final String name;
  final String target;
  final String unit;

  Exercise({required this.name, required this.target, required this.unit});

  // creating exercise object fromJson
  factory Exercise.fromJson(Map<String, dynamic> json) {
    return Exercise(
      name: json['name'],
      target: json['target'].toString(),
      unit: json['unit'],
    );
  }

  // converting exercise object to JSON
  Map<String, dynamic> toJson() {
    return {
      'name': name,
      'target': target,
      'unit': unit,
    };
  }
}
