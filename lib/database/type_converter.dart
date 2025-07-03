import 'dart:convert';
import 'package:floor/floor.dart';
import '../models/exercise.dart';

class DateTimeConverter extends TypeConverter<DateTime, int> {
  @override
  DateTime decode(int databaseValue) {
    return DateTime.fromMillisecondsSinceEpoch(databaseValue);
  }
  @override
  int encode(DateTime value) {
    return value.millisecondsSinceEpoch;
  }
}

class ExerciseListConverter extends TypeConverter<List<Exercise>, String> {
  @override
  List<Exercise> decode(String databaseValue) {
    if (databaseValue.isEmpty) return [];
    final List<dynamic> decoded = jsonDecode(databaseValue);
    return decoded.map((e) => Exercise.fromJson(e)).toList();
  }
  @override
  String encode(List<Exercise> value) {
    return jsonEncode(value.map((e) => e.toJson()).toList());
  }
}