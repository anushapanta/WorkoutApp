import 'package:flutter/material.dart';
import '../database/app_database.dart';

class RecentPerformanceWidget extends StatefulWidget {
  final AppDatabase database;

  const RecentPerformanceWidget({Key? key, required this.database}) : super(key: key);

  @override
  _RecentPerformanceWidgetState createState() => _RecentPerformanceWidgetState();
}

class _RecentPerformanceWidgetState extends State<RecentPerformanceWidget> {
  late Future<Map<String, dynamic>> _performanceData;

  @override
  void initState() {
    super.initState();
    _performanceData = _calculatePerformanceData();
  }

  Future<Map<String, dynamic>> _calculatePerformanceData() async {
    final now = DateTime.now();
    final pastWeek = now.subtract(const Duration(days: 7));

    final allWorkouts = await widget.database.workoutDao.getAllWorkouts();
    final recentWorkouts = allWorkouts.where((w) => w.workoutDate.isAfter(pastWeek)).toList();

    if (recentWorkouts.isEmpty) {
      return {
        'score': 0.0,
        'totalWorkouts': 0,
        'totalExercises': 0,
        'successfulExercises': 0,
        'successRate': 0.0,
      };
    }

    int totalWorkouts = recentWorkouts.length;
    int totalExercises = recentWorkouts.fold(0, (sum, w) => sum + w.exerciseResults.length);
    int successfulExercises = recentWorkouts.fold(0, (sum, w) => sum + w.successfulExerciseCount);

    double successRate = totalExercises > 0 ? (successfulExercises / totalExercises) : 0.0;

    double score = (totalWorkouts * 10) + (successRate * 100);
    score = score.clamp(0, 100);

    return {
      'score': score,
      'totalWorkouts': totalWorkouts,
      'totalExercises': totalExercises,
      'successfulExercises': successfulExercises,
      'successRate': successRate,
    };
  }

  @override
  Widget build(BuildContext context) {
    return Align(
      alignment: Alignment.topRight,
      child: Card(
        elevation: 4,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: FutureBuilder<Map<String, dynamic>>(
            future: _performanceData,
            builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.waiting) {
                return const Center(child: CircularProgressIndicator());
              } else if (snapshot.hasError) {
                return Text('Error: ${snapshot.error}');
              }
              else if (snapshot.data!['totalWorkouts'] == 0) {
                return const Text("No data available.");
              }

              final data = snapshot.data!;
              double score = data['score'];
              int totalWorkouts = data['totalWorkouts'];
              int totalExercises = data['totalExercises'];
              int successfulExercises = data['successfulExercises'];
              double successRate = data['successRate'];

              return Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Text(
                    "Performance Score",
                    style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 8),
                  const Divider(height: 20, thickness: 1),
                  _rowDetails("Total Workouts", totalWorkouts.toString()),
                  _rowDetails("Total Exercises", totalExercises.toString()),
                  _rowDetails("Successful Exercises", successfulExercises.toString()),
                  _rowDetails("Success Rate", "${(successRate * 100).toStringAsFixed(1)}%"),
                ],
              );
            },
          ),
        ),
      ),
    );
  }

  Widget _rowDetails(String label, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(label, style: TextStyle(fontSize: 14, fontWeight: FontWeight.w500)),
          Text(value, style: TextStyle(fontSize: 14, fontWeight: FontWeight.bold)),
        ],
      ),
    );
  }
}

