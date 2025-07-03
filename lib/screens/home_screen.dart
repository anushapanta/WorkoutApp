import 'package:flutter/material.dart';
import '../widgets/recent_performance_widget.dart';
import 'workout_download_page.dart';
import 'workout_history_page.dart';
import 'workout_selection_page.dart';
import '../database/app_database.dart';

class HomeScreen extends StatelessWidget {
  final AppDatabase database;
  HomeScreen({required this.database});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("Workout Tracker")),
      body: Column(
        children: [
          ElevatedButton(
            child: Text("Download Workout Plan"),
            onPressed: () {
              Navigator.push(context, MaterialPageRoute(builder: (_) => WorkoutDownloadPage(database: database)));
            },
          ),
          ElevatedButton(
            child: Text("View Workout History"),
            onPressed: () {
              Navigator.push(context, MaterialPageRoute(builder: (_) => WorkoutHistoryPage(database: database)));
            },
          ),
          ElevatedButton(
            child: Text("Start a Workout"),
            onPressed: () {
              Navigator.push(context, MaterialPageRoute(builder: (_) => WorkoutSelectionPage(database: database)));
            },
          ),
          RecentPerformanceWidget(database:database),
        ],
      ),


    );
  }
}




