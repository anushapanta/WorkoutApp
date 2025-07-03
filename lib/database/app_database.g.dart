// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'app_database.dart';

// **************************************************************************
// FloorGenerator
// **************************************************************************

abstract class $AppDatabaseBuilderContract {
  /// Adds migrations to the builder.
  $AppDatabaseBuilderContract addMigrations(List<Migration> migrations);

  /// Adds a database [Callback] to the builder.
  $AppDatabaseBuilderContract addCallback(Callback callback);

  /// Creates the database and initializes it.
  Future<AppDatabase> build();
}

// ignore: avoid_classes_with_only_static_members
class $FloorAppDatabase {
  /// Creates a database builder for a persistent database.
  /// Once a database is built, you should keep a reference to it and re-use it.
  static $AppDatabaseBuilderContract databaseBuilder(String name) =>
      _$AppDatabaseBuilder(name);

  /// Creates a database builder for an in memory database.
  /// Information stored in an in memory database disappears when the process is killed.
  /// Once a database is built, you should keep a reference to it and re-use it.
  static $AppDatabaseBuilderContract inMemoryDatabaseBuilder() =>
      _$AppDatabaseBuilder(null);
}

class _$AppDatabaseBuilder implements $AppDatabaseBuilderContract {
  _$AppDatabaseBuilder(this.name);

  final String? name;

  final List<Migration> _migrations = [];

  Callback? _callback;

  @override
  $AppDatabaseBuilderContract addMigrations(List<Migration> migrations) {
    _migrations.addAll(migrations);
    return this;
  }

  @override
  $AppDatabaseBuilderContract addCallback(Callback callback) {
    _callback = callback;
    return this;
  }

  @override
  Future<AppDatabase> build() async {
    final path = name != null
        ? await sqfliteDatabaseFactory.getDatabasePath(name!)
        : ':memory:';
    final database = _$AppDatabase();
    database.database = await database.open(
      path,
      _migrations,
      _callback,
    );
    return database;
  }
}

class _$AppDatabase extends AppDatabase {
  _$AppDatabase([StreamController<String>? listener]) {
    changeListener = listener ?? StreamController<String>.broadcast();
  }

  WorkoutDao? _workoutDaoInstance;

  WorkoutPlanDao? _workoutPlanDaoInstance;

  Future<sqflite.Database> open(
    String path,
    List<Migration> migrations, [
    Callback? callback,
  ]) async {
    final databaseOptions = sqflite.OpenDatabaseOptions(
      version: 1,
      onConfigure: (database) async {
        await database.execute('PRAGMA foreign_keys = ON');
        await callback?.onConfigure?.call(database);
      },
      onOpen: (database) async {
        await callback?.onOpen?.call(database);
      },
      onUpgrade: (database, startVersion, endVersion) async {
        await MigrationAdapter.runMigrations(
            database, startVersion, endVersion, migrations);

        await callback?.onUpgrade?.call(database, startVersion, endVersion);
      },
      onCreate: (database, version) async {
        await database.execute(
            'CREATE TABLE IF NOT EXISTS `workouts` (`id` INTEGER PRIMARY KEY AUTOINCREMENT NOT NULL, `workoutDate` INTEGER NOT NULL, `resultsJson` TEXT NOT NULL)');
        await database.execute(
            'CREATE TABLE IF NOT EXISTS `workout_plans` (`name` TEXT NOT NULL, `exercisesJson` TEXT NOT NULL, PRIMARY KEY (`name`))');

        await callback?.onCreate?.call(database, version);
      },
    );
    return sqfliteDatabaseFactory.openDatabase(path, options: databaseOptions);
  }

  @override
  WorkoutDao get workoutDao {
    return _workoutDaoInstance ??= _$WorkoutDao(database, changeListener);
  }

  @override
  WorkoutPlanDao get workoutPlanDao {
    return _workoutPlanDaoInstance ??=
        _$WorkoutPlanDao(database, changeListener);
  }
}

class _$WorkoutDao extends WorkoutDao {
  _$WorkoutDao(
    this.database,
    this.changeListener,
  )   : _queryAdapter = QueryAdapter(database),
        _workoutInsertionAdapter = InsertionAdapter(
            database,
            'workouts',
            (Workout item) => <String, Object?>{
                  'id': item.id,
                  'workoutDate': _dateTimeConverter.encode(item.workoutDate),
                  'resultsJson': item.resultsJson
                });

  final sqflite.DatabaseExecutor database;

  final StreamController<String> changeListener;

  final QueryAdapter _queryAdapter;

  final InsertionAdapter<Workout> _workoutInsertionAdapter;

  @override
  Future<List<Workout>> getAllWorkouts() async {
    return _queryAdapter.queryList('SELECT * FROM workouts',
        mapper: (Map<String, Object?> row) => Workout(
            id: row['id'] as int,
            workoutDate: _dateTimeConverter.decode(row['workoutDate'] as int),
            resultsJson: row['resultsJson'] as String));
  }

  @override
  Future<void> insertWorkout(Workout workout) async {
    await _workoutInsertionAdapter.insert(workout, OnConflictStrategy.replace);
  }
}

class _$WorkoutPlanDao extends WorkoutPlanDao {
  _$WorkoutPlanDao(
    this.database,
    this.changeListener,
  )   : _queryAdapter = QueryAdapter(database),
        _workoutPlanInsertionAdapter = InsertionAdapter(
            database,
            'workout_plans',
            (WorkoutPlan item) => <String, Object?>{
                  'name': item.name,
                  'exercisesJson': item.exercisesJson
                });

  final sqflite.DatabaseExecutor database;

  final StreamController<String> changeListener;

  final QueryAdapter _queryAdapter;

  final InsertionAdapter<WorkoutPlan> _workoutPlanInsertionAdapter;

  @override
  Future<List<WorkoutPlan>> getAllWorkoutPlans() async {
    return _queryAdapter.queryList('SELECT * FROM workout_plans',
        mapper: (Map<String, Object?> row) => WorkoutPlan(
            name: row['name'] as String,
            exercisesJson: row['exercisesJson'] as String));
  }

  @override
  Future<void> insertWorkoutPlan(WorkoutPlan workoutPlan) async {
    await _workoutPlanInsertionAdapter.insert(
        workoutPlan, OnConflictStrategy.replace);
  }
}

// ignore_for_file: unused_element
final _dateTimeConverter = DateTimeConverter();
final _exerciseListConverter = ExerciseListConverter();
