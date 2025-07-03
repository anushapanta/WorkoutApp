//assignment 4
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class WorkoutResultsPage extends StatefulWidget {
  final String workoutId;
  final String mode;

  WorkoutResultsPage({required this.workoutId, required this.mode});

  @override
  _WorkoutResultsPageState createState() => _WorkoutResultsPageState();
}

class _WorkoutResultsPageState extends State<WorkoutResultsPage> {
  List<Map<String, dynamic>> userResults = [];
  Map<String, int> totalExerciseResults = {};
  Map<String, int> exerciseTargets = {};
  int participantCount = 0;

  @override
  void initState() {
    super.initState();
    _fetchResults();
  }
  Future<void> _fetchResults() async {
    try {
      DocumentSnapshot workoutDoc = await FirebaseFirestore.instance
          .collection("workouts")
          .doc(widget.workoutId)
          .get();

      if (workoutDoc.exists) {
        QuerySnapshot resultsSnapshot =
        await workoutDoc.reference.collection("results").get();

        List<Map<String, dynamic>> fetchedResults = [];
        Map<String, int> totalScores = {};
        Set<String> participants = {};

        for (var doc in resultsSnapshot.docs) {
          Map<String, dynamic> resultData = doc.data() as Map<String, dynamic>;

          if (widget.mode == "collaborative") {
            totalExerciseResults[doc.id] = (resultData["totalOutput"] is int)
                ? resultData["totalOutput"]
                : int.tryParse(resultData["totalOutput"].toString()) ?? 0;
            exerciseTargets[doc.id] = (resultData["target"] is int)
                ? resultData["target"]
                : int.tryParse(resultData["target"].toString()) ?? 0;
          } else if (widget.mode == "competitive") {
            String userName = resultData["userName"]?.toString() ?? "Unknown";

            participants.add(userName);

            int totalScore = (resultData["totalScore"] is int)
                ? resultData["totalScore"]
                : int.tryParse(resultData["totalScore"].toString()) ?? 0;

            fetchedResults.add({
              "userName": userName,
              "totalScore": totalScore,
            });

            totalScores[userName] = totalScore;
          }
        }

        setState(() {
          userResults = fetchedResults;
          participantCount = participants.length;
        });
      }
    } catch (e) {

    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("Workout Results")),
      body: Column(
        children: [
          Padding(
            padding: EdgeInsets.all(16.0),
            child: Text(
              "Participants: $participantCount",
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
          ),
          Expanded(
            child: widget.mode == "collaborative"
                ? _buildCollaborativeResults()
                : _buildCompetitiveResults(),
          ),
        ],
      ),
    );
  }

  Widget _buildCollaborativeResults() {
    return ListView(
      children: totalExerciseResults.entries.map((entry) {
        String exercise = entry.key;
        int totalOutput = entry.value;
        int target = exerciseTargets[exercise] ?? 0;

        return ListTile(
          title: Text("$exercise - Goal: $target"),
          subtitle: Text("Total Output: $totalOutput"),
          trailing: totalOutput >= target
              ? Icon(Icons.check_circle, color: Colors.green)
              : Icon(Icons.cancel, color: Colors.red),
        );
      }).toList(),
    );
  }


  Widget _buildCompetitiveResults() {
    List<MapEntry<String, int>> sortedUsers = userResults
        .map((e) => MapEntry(e["userName"] as String, e["totalScore"] as int))
        .toList()
      ..sort((a, b) => b.value.compareTo(a.value));

    return ListView(
      children: sortedUsers.map((entry) {
        int rank = sortedUsers.indexOf(entry) + 1;
        return ListTile(
          title: Text("${entry.key} - Score: ${entry.value}"),
          subtitle: Text("Rank: $rank"),
          trailing: rank == 1
              ? Icon(Icons.emoji_events, color: Colors.orange)
              : rank == 2
              ? Icon(Icons.emoji_events, color: Colors.grey)
              : rank == 3
              ? Icon(Icons.emoji_events, color: Colors.brown)
              : null,
        );
      }).toList(),
    );
  }
}
