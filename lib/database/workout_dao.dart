import 'package:floor/floor.dart';
import '../models/workout.dart';

@dao
abstract class WorkoutDao {
  @Insert(onConflict: OnConflictStrategy.replace)
  Future<void> insertWorkout(Workout workout);

  @Query('SELECT * FROM workouts')
  Future<List<Workout>> getAllWorkouts();
}
