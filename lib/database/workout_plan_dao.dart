import 'package:floor/floor.dart';
import '../models/workout_plan.dart';

@dao
abstract class WorkoutPlanDao {
  @Insert(onConflict: OnConflictStrategy.replace)
  Future<void> insertWorkoutPlan(WorkoutPlan workoutPlan);

  @Query('SELECT * FROM workout_plans')
  Future<List<WorkoutPlan>> getAllWorkoutPlans();
}
