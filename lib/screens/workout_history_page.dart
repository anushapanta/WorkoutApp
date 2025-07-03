import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import '../database/app_database.dart';
import '../models/workout.dart';

class WorkoutHistoryPage extends StatefulWidget {
  final AppDatabase database;

  WorkoutHistoryPage({required this.database});

  @override
  _WorkoutHistoryPageState createState() => _WorkoutHistoryPageState();
}

class _WorkoutHistoryPageState extends State<WorkoutHistoryPage> {
  late Future<List<Workout>> _workoutHistory;

  @override
  void initState() {
    super.initState();
    _workoutHistory = widget.database.workoutDao.getAllWorkouts();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("Workout History")),
      body: FutureBuilder<List<Workout>>(
        future: _workoutHistory,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(child: CircularProgressIndicator());
          } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
            return Center(child: Text("No workout history available."));
          }

          return ListView.builder(
            itemCount: snapshot.data!.length,
            itemBuilder: (context, index) {
              final workout = snapshot.data![index];
              return ListTile(
                title: Text("Workout on ${DateFormat('yyyy-MM-dd').format(workout.workoutDate)}"),
                subtitle: Text("${workout.exerciseResults.length} exercises"),
                trailing: Icon(Icons.arrow_forward_ios, color: Colors.grey),
                onTap: () => _showWorkoutDetails(context, workout),
              );
            },
          );
        },
      ),
    );
  }

  void _showWorkoutDetails(BuildContext context, Workout workout) {
    showDialog(
      context: context,
      builder: (_) => AlertDialog(
        title: Text("Workout Details"),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: workout.exerciseResults
              .map((result) => Text("${result.name}: ${result.exerciseOutput} ${result.unit}"))
              .toList(),

        ),
        actions: [
          TextButton(child: Text("Close"), onPressed: () => Navigator.pop(context)),
        ],
      ),
    );
  }
}
