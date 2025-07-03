import 'dart:async';
import 'package:floor/floor.dart';
import 'package:workoutapp/database/type_converter.dart';
import 'package:sqflite/sqflite.dart' as sqflite;
import '../models/workout.dart';
import '../models/workout_plan.dart';
import 'workout_dao.dart';
import 'workout_plan_dao.dart';

part 'app_database.g.dart';

@Database(version: 1, entities: [Workout, WorkoutPlan])
abstract class AppDatabase extends FloorDatabase {
  WorkoutDao get workoutDao;
  WorkoutPlanDao get workoutPlanDao;
}
