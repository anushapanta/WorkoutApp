import 'package:cloud_firestore/cloud_firestore.dart';
import '../models/workout_plan.dart';

class FirestoreService {
  final FirebaseFirestore _db = FirebaseFirestore.instance;

  Future<String> createWorkoutSession(WorkoutPlan plan, String mode) async {
    final docRef = await _db.collection("workouts").add({
      "plan": plan.toJson(),
      "mode": mode,
      "createdAt": FieldValue.serverTimestamp(),
      "participants": [],
    });
    return docRef.id;
  }
  Future<void> joinWorkout(String workoutId, String userId) async {
    final docRef = _db.collection("workouts").doc(workoutId);
    await docRef.update({
      "participants": FieldValue.arrayUnion([userId]),
    });
  }
  Future<WorkoutPlan?> fetchWorkoutPlan(String workoutId) async {
    DocumentSnapshot doc = await _db.collection("workouts").doc(workoutId).get();

    if (doc.exists && doc.data() != null) {
      var data = doc.data() as Map<String, dynamic>;
      if (data.containsKey('plan')) {
        return WorkoutPlan.fromJson(data['plan']);
      }
    }

    return null;
  }
  Future<void> submitWorkoutResults(String workoutId, Map<String, dynamic> results) async {
    try {
      await _db.collection("group_workouts").doc(workoutId).update({
        "participants": FieldValue.arrayUnion([results]),
      });
    } catch (e) {
    }
  }
}
